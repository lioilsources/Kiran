// Package ol1nimage is a grokimage.ImageGenerator backed by the self-hosted
// AiStack image API at https://llm.ol1n.com, accessed via Cloudflare Access.
//
// The API is async: POST /v1/images/generations returns 202 + a job ID;
// the client polls GET /v1/images/jobs/{id} until the job reaches a
// terminal state, then downloads each result image as raw PNG bytes and
// re-encodes them as base64 to satisfy the GenerateResponse contract.
package ol1nimage

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"tyrian-pipeline/internal/grokimage"
)

const (
	defaultBaseURL   = "https://llm.ol1n.com"
	generatePath     = "/v1/images/generations"
	jobsPath         = "/v1/images/jobs/"
	defaultPollDelay = 2 * time.Second
	// defaultJobTimeout accounts for single-GPU queue depth: with 3 workers each
	// submitting ~2-min jobs, the 3rd job waits ~4 min before starting.
	defaultJobTimeout = 15 * time.Minute
)

// Client implements grokimage.ImageGenerator against the AiStack image API.
type Client struct {
	baseURL    string
	cfClientID string
	cfSecret   string
	httpClient *http.Client
	maxRetries int
	pollDelay  time.Duration
	jobTimeout time.Duration
}

// ClientOption configures the Client.
type ClientOption func(*Client)

// WithBaseURL overrides the default base URL (primarily for testing).
func WithBaseURL(url string) ClientOption {
	return func(c *Client) { c.baseURL = strings.TrimRight(url, "/") }
}

// WithHTTPClient sets a custom HTTP client.
func WithHTTPClient(hc *http.Client) ClientOption {
	return func(c *Client) { c.httpClient = hc }
}

// WithMaxRetries sets the maximum submit-retry count.
func WithMaxRetries(n int) ClientOption {
	return func(c *Client) { c.maxRetries = n }
}

// WithPollDelay overrides the interval between job-status polls.
func WithPollDelay(d time.Duration) ClientOption {
	return func(c *Client) { c.pollDelay = d }
}

// WithJobTimeout overrides the maximum time to wait for a job to finish.
func WithJobTimeout(d time.Duration) ClientOption {
	return func(c *Client) { c.jobTimeout = d }
}

// NewClient creates a client for the AiStack image API.
// cfClientID and cfSecret are the Cloudflare Access service-token credentials
// (env vars CF_ACCESS_CLIENT_ID / CF_ACCESS_CLIENT_SECRET).
func NewClient(cfClientID, cfSecret string, opts ...ClientOption) *Client {
	c := &Client{
		baseURL:    defaultBaseURL,
		cfClientID: cfClientID,
		cfSecret:   cfSecret,
		httpClient: &http.Client{Timeout: 30 * time.Second},
		maxRetries: 3,
		pollDelay:  defaultPollDelay,
		jobTimeout: defaultJobTimeout,
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

func (c *Client) cfHeaders() map[string]string {
	return map[string]string{
		"Content-Type":            "application/json",
		"CF-Access-Client-Id":     c.cfClientID,
		"CF-Access-Client-Secret": c.cfSecret,
	}
}

// Generate submits a generation job, polls until completion, downloads all
// result images and returns them as base64-encoded PNG in GenerateResponse.
func (c *Client) Generate(ctx context.Context, req grokimage.GenerateRequest) (*grokimage.GenerateResponse, error) {
	n := req.N
	if n <= 0 {
		n = 1
	}

	jobID, err := c.submitWithRetry(ctx, req.Prompt, req.Model, n, sizeFromAspect(req.AspectRatio, req.Resolution))
	if err != nil {
		return nil, err
	}

	resultURL, count, err := c.pollUntilDone(ctx, jobID)
	if err != nil {
		return nil, err
	}

	resp := &grokimage.GenerateResponse{Data: make([]grokimage.ImageData, count)}
	for i := range count {
		b64, err := c.downloadImage(ctx, resultURL, i)
		if err != nil {
			return nil, fmt.Errorf("download image %d: %w", i, err)
		}
		resp.Data[i] = grokimage.ImageData{B64JSON: b64}
	}
	return resp, nil
}

func (c *Client) submitWithRetry(ctx context.Context, prompt, model string, n int, size string) (string, error) {
	reqBody := map[string]any{
		"prompt": prompt,
		"n":      n,
		"size":   size,
	}
	if model != "" {
		reqBody["model"] = model
	}
	body, _ := json.Marshal(reqBody)

	var lastErr error
	for attempt := range c.maxRetries + 1 {
		if attempt > 0 {
			select {
			case <-ctx.Done():
				return "", ctx.Err()
			case <-time.After(time.Duration(1<<uint(attempt-1)) * time.Second):
			}
		}

		jobID, err := c.doSubmit(ctx, body)
		if err == nil {
			return jobID, nil
		}

		apiErr, ok := err.(*grokimage.APIError)
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
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+generatePath, strings.NewReader(string(body)))
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

	if resp.StatusCode != http.StatusAccepted {
		return "", &grokimage.APIError{
			StatusCode: resp.StatusCode,
			Message:    string(respBody),
			Retryable:  resp.StatusCode >= 500,
		}
	}

	var payload struct {
		ID string `json:"id"`
	}
	if err := json.Unmarshal(respBody, &payload); err != nil {
		return "", fmt.Errorf("decode job response: %w", err)
	}
	if payload.ID == "" {
		return "", fmt.Errorf("server returned empty job ID")
	}
	return payload.ID, nil
}

type jobStatus struct {
	Status        string `json:"status"`
	ResultURL     string `json:"result_url"`
	Count         int    `json:"count"`
	Error         string `json:"error"`
	QueuePosition int    `json:"queue_position"`
	Step          int    `json:"step"`
	Total         int    `json:"total"`
}

// pollUntilDone polls the job endpoint until the job is done or fails.
// Prints status transitions to stderr so long-running jobs are visible.
func (c *Client) pollUntilDone(ctx context.Context, jobID string) (resultURL string, count int, err error) {
	deadline := time.Now().Add(c.jobTimeout)
	url := c.baseURL + jobsPath + jobID
	short := jobID
	if len(short) > 8 {
		short = short[:8]
	}
	lastStatus := ""

	for {
		select {
		case <-ctx.Done():
			return "", 0, ctx.Err()
		case <-time.After(c.pollDelay):
		}

		if time.Now().After(deadline) {
			return "", 0, fmt.Errorf("job %s timed out after %s", jobID, c.jobTimeout)
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

		if resp.StatusCode == http.StatusNotFound {
			return "", 0, fmt.Errorf("job %s expired or not found", jobID)
		}
		if resp.StatusCode != http.StatusOK {
			continue
		}

		var js jobStatus
		if err := json.Unmarshal(body, &js); err != nil {
			continue
		}

		switch js.Status {
		case "done":
			if js.Count == 0 {
				js.Count = 1
			}
			return js.ResultURL, js.Count, nil
		case "error":
			return "", 0, fmt.Errorf("job %s failed: %s", jobID, js.Error)
		case "queued":
			if js.Status != lastStatus {
				fmt.Fprintf(os.Stderr, "  [ol1n] job %s: queued (pos %d)\n", short, js.QueuePosition)
				lastStatus = js.Status
			}
		case "running":
			if js.Status != lastStatus {
				fmt.Fprintf(os.Stderr, "  [ol1n] job %s: running (%d/%d steps)\n", short, js.Step, js.Total)
				lastStatus = js.Status
			}
		}
	}
}

func (c *Client) downloadImage(ctx context.Context, resultURL string, index int) (string, error) {
	url := c.baseURL + resultURL
	if index > 0 {
		url = fmt.Sprintf("%s?index=%d", url, index)
	}

	dlClient := &http.Client{Timeout: 120 * time.Second}
	req, _ := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
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
		return "", &grokimage.APIError{
			StatusCode: resp.StatusCode,
			Message:    string(body),
			Retryable:  false,
		}
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("read body: %w", err)
	}
	return base64.StdEncoding.EncodeToString(data), nil
}

// sizeFromAspect maps aspect ratio + resolution hints to the "WxH" string
// the AiStack image API expects.
func sizeFromAspect(aspectRatio, resolution string) string {
	switch aspectRatio {
	case "1:2":
		if resolution == "2k" {
			return "1024x2048"
		}
		return "512x1024"
	case "2:1":
		if resolution == "2k" {
			return "2048x1024"
		}
		return "1024x512"
	default:
		if resolution == "2k" {
			return "2048x2048"
		}
		return "1024x1024"
	}
}
