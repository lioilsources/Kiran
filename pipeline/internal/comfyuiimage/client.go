// Package comfyuiimage is an imagegen.ImageGenerator backed by a ComfyUI server
// running a Flux text-to-image workflow, accessed via Cloudflare Access.
//
// ComfyUI's API is async and workflow-graph oriented:
//
//	POST /prompt                                   → {"prompt_id": "..."}
//	GET  /history/{prompt_id}                      → {} until done, then the
//	                                                 entry with outputs + status
//	GET  /view?filename=..&subfolder=..&type=..    → raw image bytes
//
// The client injects the per-asset prompt, pixel dimensions, batch size (= N
// variations) and a random seed into a versioned workflow graph, submits it,
// polls until the job completes, downloads each output image and re-encodes it
// as base64 to satisfy the GenerateResponse contract.
package comfyuiimage

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"net/http"
	"net/url"
	"os"
	"sort"
	"strings"
	"time"

	_ "embed"

	"tyrian-pipeline/internal/imagegen"
)

const (
	promptPath        = "/prompt"
	historyPath       = "/history/"
	viewPath          = "/view"
	defaultPollDelay  = 2 * time.Second
	defaultJobTimeout = 15 * time.Minute
)

// defaultWorkflow is a minimal Flux txt2img graph (API format). It uses the
// single-file fp8 checkpoint + plain KSampler at cfg=1 so it runs out of the box;
// swap it for a UNETLoader/DualCLIPLoader/FluxGuidance graph via WithWorkflow if
// you use the full dev model.
//
//go:embed workflows/flux_sprite.json
var defaultWorkflow []byte

//go:embed workflows/pony_sprite.json
var ponyWorkflow []byte

// PonyWorkflow returns the embedded Pony SDXL workflow graph (EmptyLatentImage,
// cfg=6, dpmpp_2m/karras, with quality negative prompt).
func PonyWorkflow() []byte { return ponyWorkflow }

// NodeRoles maps logical roles to node IDs in the workflow graph. The defaults
// match the embedded flux workflow; override with WithNodeRoles after re-exporting a
// workflow whose node IDs differ.
type NodeRoles struct {
	PositivePrompt string // CLIPTextEncode node whose inputs.text is the prompt
	Latent         string // Empty*LatentImage node carrying width/height/batch_size
	Sampler        string // KSampler node carrying the seed
	CheckpointNode string // loader node to override when WithCheckpoint is used
	CheckpointKey  string // input key on that node (e.g. "unet_name" or "ckpt_name")
}

// defaultNodeRoles matches the embedded flux_sprite.json (UNETLoader architecture).
var defaultNodeRoles = NodeRoles{
	PositivePrompt: "4",
	Latent:         "6",
	Sampler:        "8",
	CheckpointNode: "1",
	CheckpointKey:  "unet_name",
}

// ponyNodeRoles matches pony_sprite.json (CheckpointLoaderSimple architecture).
var ponyNodeRoles = NodeRoles{
	PositivePrompt: "6",
	Latent:         "5",
	Sampler:        "3",
	CheckpointNode: "4",
	CheckpointKey:  "ckpt_name",
}

// PonyNodeRoles returns the NodeRoles for the embedded pony_sprite.json workflow.
func PonyNodeRoles() NodeRoles { return ponyNodeRoles }

// Client implements imagegen.ImageGenerator against a ComfyUI server.
type Client struct {
	baseURL      string
	cfClientID   string
	cfSecret     string
	clientID     string
	httpClient   *http.Client
	maxRetries   int
	pollDelay    time.Duration
	jobTimeout   time.Duration
	workflowJSON []byte
	roles        NodeRoles
	checkpoint   string // optional: overrides the checkpoint loader node named in roles
}

// ClientOption configures the Client.
type ClientOption func(*Client)

// WithBaseURL overrides the base URL (primarily for testing).
func WithBaseURL(u string) ClientOption {
	return func(c *Client) { c.baseURL = strings.TrimRight(u, "/") }
}

// WithHTTPClient sets a custom HTTP client.
func WithHTTPClient(hc *http.Client) ClientOption {
	return func(c *Client) { c.httpClient = hc }
}

// WithMaxRetries sets the maximum submit-retry count.
func WithMaxRetries(n int) ClientOption {
	return func(c *Client) { c.maxRetries = n }
}

// WithPollDelay overrides the interval between history polls.
func WithPollDelay(d time.Duration) ClientOption {
	return func(c *Client) { c.pollDelay = d }
}

// WithJobTimeout overrides the maximum time to wait for a job to finish.
func WithJobTimeout(d time.Duration) ClientOption {
	return func(c *Client) { c.jobTimeout = d }
}

// WithWorkflow replaces the embedded workflow graph (API format JSON).
func WithWorkflow(graph []byte) ClientOption {
	return func(c *Client) { c.workflowJSON = graph }
}

// WithNodeRoles overrides the node-ID mapping used for injection.
func WithNodeRoles(r NodeRoles) ClientOption {
	return func(c *Client) { c.roles = r }
}

// WithCheckpoint overrides the model name in the loader node identified by
// NodeRoles.CheckpointNode / NodeRoles.CheckpointKey. For the default flux
// workflow that is UNETLoader node "1" / "unet_name"; for pony it is
// CheckpointLoaderSimple node "4" / "ckpt_name".
func WithCheckpoint(name string) ClientOption {
	return func(c *Client) { c.checkpoint = name }
}

// NewClient creates a client for a ComfyUI server. cfClientID and cfSecret are
// the Cloudflare Access service-token credentials (env vars
// CF_ACCESS_CLIENT_ID / CF_ACCESS_CLIENT_SECRET); pass empty strings for a
// server with no access control.
func NewClient(baseURL, cfClientID, cfSecret string, opts ...ClientOption) *Client {
	c := &Client{
		baseURL:      strings.TrimRight(baseURL, "/"),
		cfClientID:   cfClientID,
		cfSecret:     cfSecret,
		clientID:     randHex(16),
		httpClient:   &http.Client{Timeout: 30 * time.Second},
		maxRetries:   3,
		pollDelay:    defaultPollDelay,
		jobTimeout:   defaultJobTimeout,
		workflowJSON: defaultWorkflow,
		roles:        defaultNodeRoles,
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

func (c *Client) cfHeaders() map[string]string {
	h := map[string]string{"Content-Type": "application/json"}
	if c.cfClientID != "" {
		h["CF-Access-Client-Id"] = c.cfClientID
	}
	if c.cfSecret != "" {
		h["CF-Access-Client-Secret"] = c.cfSecret
	}
	return h
}

// Generate builds a workflow for the request, submits it, polls until the job
// completes, downloads all output images and returns them as base64 PNG.
func (c *Client) Generate(ctx context.Context, req imagegen.GenerateRequest) (*imagegen.GenerateResponse, error) {
	n := req.N
	if n <= 0 {
		n = 1
	}

	w, h := dimensions(req.AspectRatio, req.Resolution)
	graph, err := c.buildWorkflow(req.Prompt, w, h, n)
	if err != nil {
		return nil, err
	}

	promptID, err := c.submitWithRetry(ctx, graph)
	if err != nil {
		return nil, err
	}

	images, err := c.pollUntilDone(ctx, promptID)
	if err != nil {
		return nil, err
	}

	resp := &imagegen.GenerateResponse{Data: make([]imagegen.ImageData, len(images))}
	for i, im := range images {
		b64, err := c.downloadImage(ctx, im)
		if err != nil {
			return nil, fmt.Errorf("download image %d: %w", i, err)
		}
		resp.Data[i] = imagegen.ImageData{B64JSON: b64}
	}
	return resp, nil
}

// buildWorkflow parses a fresh copy of the workflow graph (so concurrent workers
// never share mutable state) and injects the prompt, dimensions, batch size and a
// random seed into the role-mapped nodes.
func (c *Client) buildWorkflow(prompt string, w, h, batch int) (map[string]any, error) {
	var graph map[string]any
	if err := json.Unmarshal(c.workflowJSON, &graph); err != nil {
		return nil, fmt.Errorf("parse workflow: %w", err)
	}

	if err := setNodeInput(graph, c.roles.PositivePrompt, "text", prompt); err != nil {
		return nil, err
	}
	if err := setNodeInput(graph, c.roles.Latent, "width", w); err != nil {
		return nil, err
	}
	if err := setNodeInput(graph, c.roles.Latent, "height", h); err != nil {
		return nil, err
	}
	if err := setNodeInput(graph, c.roles.Latent, "batch_size", batch); err != nil {
		return nil, err
	}
	if err := setNodeInput(graph, c.roles.Sampler, "seed", randSeed()); err != nil {
		return nil, err
	}
	if c.checkpoint != "" {
		if err := setNodeInput(graph, c.roles.CheckpointNode, c.roles.CheckpointKey, c.checkpoint); err != nil {
			return nil, err
		}
	}
	return graph, nil
}

func setNodeInput(graph map[string]any, nodeID, key string, val any) error {
	node, ok := graph[nodeID].(map[string]any)
	if !ok {
		return fmt.Errorf("workflow node %q not found", nodeID)
	}
	inputs, ok := node["inputs"].(map[string]any)
	if !ok {
		return fmt.Errorf("workflow node %q has no inputs object", nodeID)
	}
	inputs[key] = val
	return nil
}

func (c *Client) submitWithRetry(ctx context.Context, graph map[string]any) (string, error) {
	body, err := json.Marshal(map[string]any{
		"prompt":    graph,
		"client_id": c.clientID,
	})
	if err != nil {
		return "", fmt.Errorf("marshal prompt: %w", err)
	}

	var lastErr error
	for attempt := 0; attempt <= c.maxRetries; attempt++ {
		if attempt > 0 {
			select {
			case <-ctx.Done():
				return "", ctx.Err()
			case <-time.After(time.Duration(1<<uint(attempt-1)) * time.Second):
			}
		}

		promptID, err := c.doSubmit(ctx, body)
		if err == nil {
			return promptID, nil
		}

		apiErr, ok := err.(*imagegen.APIError)
		if !ok {
			lastErr = err
			continue
		}
		if apiErr.StatusCode == 401 {
			return "", fmt.Errorf("CF Access auth failed: %w", apiErr)
		}
		if !apiErr.Retryable {
			return "", apiErr
		}
		lastErr = apiErr
	}
	return "", fmt.Errorf("max retries exceeded: %w", lastErr)
}

func (c *Client) doSubmit(ctx context.Context, body []byte) (string, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+promptPath, strings.NewReader(string(body)))
	if err != nil {
		return "", err
	}
	for k, v := range c.cfHeaders() {
		req.Header.Set(k, v)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("HTTP request: %w", err)
	}
	defer resp.Body.Close()
	respBody, _ := io.ReadAll(resp.Body)

	if resp.StatusCode != http.StatusOK {
		return "", &imagegen.APIError{
			StatusCode: resp.StatusCode,
			Message:    string(respBody),
			// 4xx (e.g. invalid graph / node_errors) is fatal; 5xx is transient.
			Retryable: resp.StatusCode >= 500,
		}
	}

	var payload struct {
		PromptID   string         `json:"prompt_id"`
		NodeErrors map[string]any `json:"node_errors"`
	}
	if err := json.Unmarshal(respBody, &payload); err != nil {
		return "", fmt.Errorf("decode prompt response: %w", err)
	}
	if payload.PromptID == "" {
		return "", fmt.Errorf("server returned empty prompt_id (node_errors: %v)", payload.NodeErrors)
	}
	return payload.PromptID, nil
}

// imageRef identifies one output image in ComfyUI's output store.
type imageRef struct {
	Filename  string `json:"filename"`
	Subfolder string `json:"subfolder"`
	Type      string `json:"type"`
}

// historyEntry is the per-prompt record returned by /history/{id}.
type historyEntry struct {
	Status struct {
		StatusStr string `json:"status_str"`
		Completed bool   `json:"completed"`
	} `json:"status"`
	Outputs map[string]struct {
		Images []imageRef `json:"images"`
	} `json:"outputs"`
}

// pollUntilDone polls /history/{id} until the job completes, then returns its
// output images in a deterministic order (by node ID). Status transitions are
// printed to stderr so long-running jobs are visible.
func (c *Client) pollUntilDone(ctx context.Context, promptID string) ([]imageRef, error) {
	deadline := time.Now().Add(c.jobTimeout)
	url := c.baseURL + historyPath + promptID
	short := promptID
	if len(short) > 8 {
		short = short[:8]
	}
	announced := false

	for {
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		case <-time.After(c.pollDelay):
		}

		if time.Now().After(deadline) {
			return nil, fmt.Errorf("job %s timed out after %s", promptID, c.jobTimeout)
		}

		req, _ := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
		for k, v := range c.cfHeaders() {
			req.Header.Set(k, v)
		}
		resp, err := c.httpClient.Do(req)
		if err != nil {
			continue
		}
		body, _ := io.ReadAll(resp.Body)
		resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			continue
		}

		// History is keyed by prompt_id; absent/empty means still pending.
		var hist map[string]historyEntry
		if err := json.Unmarshal(body, &hist); err != nil {
			continue
		}
		entry, ok := hist[promptID]
		if !ok {
			if !announced {
				fmt.Fprintf(os.Stderr, "  [comfyui] job %s: queued/running\n", short)
				announced = true
			}
			continue
		}

		if entry.Status.StatusStr == "error" {
			return nil, fmt.Errorf("job %s failed in ComfyUI", promptID)
		}
		if !entry.Status.Completed {
			continue
		}

		images := collectImages(entry)
		if len(images) == 0 {
			return nil, fmt.Errorf("job %s completed with no output images", promptID)
		}
		return images, nil
	}
}

// collectImages flattens the output images across all nodes in deterministic
// (sorted node-ID) order.
func collectImages(entry historyEntry) []imageRef {
	nodeIDs := make([]string, 0, len(entry.Outputs))
	for id := range entry.Outputs {
		nodeIDs = append(nodeIDs, id)
	}
	sort.Strings(nodeIDs)

	var images []imageRef
	for _, id := range nodeIDs {
		for _, im := range entry.Outputs[id].Images {
			if im.Type != "" && im.Type != "output" {
				continue // skip temp/preview images
			}
			images = append(images, im)
		}
	}
	return images
}

func (c *Client) downloadImage(ctx context.Context, im imageRef) (string, error) {
	q := url.Values{}
	q.Set("filename", im.Filename)
	q.Set("subfolder", im.Subfolder)
	typ := im.Type
	if typ == "" {
		typ = "output"
	}
	q.Set("type", typ)
	reqURL := c.baseURL + viewPath + "?" + q.Encode()

	dlClient := &http.Client{Timeout: 120 * time.Second}
	req, _ := http.NewRequestWithContext(ctx, http.MethodGet, reqURL, nil)
	for k, v := range c.cfHeaders() {
		req.Header.Set(k, v)
	}

	resp, err := dlClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("HTTP request: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return "", &imagegen.APIError{StatusCode: resp.StatusCode, Message: string(body)}
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("read body: %w", err)
	}
	return base64.StdEncoding.EncodeToString(data), nil
}

// dimensions maps the backend-neutral aspect/resolution hints to concrete pixel
// sizes for the latent node. Mirrors the qwenimage mapping; "4:1" is the wide
// 4-frame sprite sheet (square cells).
func dimensions(aspectRatio, resolution string) (int, int) {
	switch aspectRatio {
	case "1:2":
		if resolution == "2k" {
			return 1024, 2048
		}
		return 512, 1024
	case "2:1":
		if resolution == "2k" {
			return 2048, 1024
		}
		return 1024, 512
	case "3:1":
		if resolution == "2k" {
			return 3072, 1024
		}
		return 1536, 512
	case "4:1":
		if resolution == "2k" {
			return 4096, 1024
		}
		return 2048, 512
	case "5:1":
		if resolution == "2k" {
			return 5120, 1024
		}
		return 2560, 512
	case "6:1":
		if resolution == "2k" {
			return 6144, 1024
		}
		return 3072, 512
	default: // "1:1" or unspecified
		if resolution == "2k" {
			return 2048, 2048
		}
		return 1024, 1024
	}
}

// randSeed returns a non-negative 63-bit random seed for the sampler.
func randSeed() int64 {
	max := big.NewInt(1)
	max.Lsh(max, 63)
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		return time.Now().UnixNano()
	}
	return n.Int64()
}

// randHex returns a random lowercase hex string of length 2*nbytes, used as the
// ComfyUI client_id.
func randHex(nbytes int) string {
	b := make([]byte, nbytes)
	if _, err := rand.Read(b); err != nil {
		return fmt.Sprintf("%x", time.Now().UnixNano())
	}
	return fmt.Sprintf("%x", b)
}
