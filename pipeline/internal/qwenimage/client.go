// Package qwenimage is an imagegen.ImageGenerator backed by a self-hosted
// Qwen-Image diffusion microservice (see pipeline/qwen_service/).
package qwenimage

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"tyrian-pipeline/internal/imagegen"
)

const generatePath = "/v1/images/generations"

// Client implements imagegen.ImageGenerator by calling the Qwen-Image
// FastAPI microservice. The service returns JPEG-encoded image bytes
// (base64) on a flat solid background, ready for the existing Go
// post-process (corner-key + resize).
type Client struct {
	baseURL    string
	token      string
	httpClient *http.Client
	maxRetries int
	steps      int
	seed       int64
}

// ClientOption configures the Client.
type ClientOption func(*Client)

// WithHTTPClient sets a custom HTTP client.
func WithHTTPClient(hc *http.Client) ClientOption {
	return func(c *Client) { c.httpClient = hc }
}

// WithMaxRetries sets the maximum retry count.
func WithMaxRetries(n int) ClientOption {
	return func(c *Client) { c.maxRetries = n }
}

// WithSteps sets the diffusion step count (8 suits the lightning LoRA).
func WithSteps(n int) ClientOption {
	return func(c *Client) {
		if n > 0 {
			c.steps = n
		}
	}
}

// WithSeed pins the base RNG seed (-1 = random per request).
func WithSeed(s int64) ClientOption {
	return func(c *Client) { c.seed = s }
}

// NewClient creates a client for the Qwen-Image service at baseURL.
// token is optional (LAN deployments may run without auth).
func NewClient(baseURL, token string, opts ...ClientOption) *Client {
	c := &Client{
		baseURL:    strings.TrimRight(baseURL, "/"),
		token:      token,
		httpClient: &http.Client{Timeout: 300 * time.Second},
		maxRetries: 3,
		steps:      8,
		seed:       -1,
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

// serviceRequest is the JSON body the Qwen-Image microservice expects.
type serviceRequest struct {
	Prompt string `json:"prompt"`
	N      int    `json:"n"`
	Width  int    `json:"width"`
	Height int    `json:"height"`
	Steps  int    `json:"steps"`
	Seed   int64  `json:"seed"`
}

// dimensions maps the backend-neutral aspect/resolution hints to concrete
// pixel sizes. Sprites are square 1k; backgrounds are 1:2 portrait and
// at "2k" map to 1024x2048 to match the background prompt's stated size.
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
	default: // "1:1" or unspecified
		if resolution == "2k" {
			return 2048, 2048
		}
		return 1024, 1024
	}
}

// Generate sends a request to the Qwen-Image service with retry logic.
func (c *Client) Generate(ctx context.Context, req imagegen.GenerateRequest) (*imagegen.GenerateResponse, error) {
	w, h := dimensions(req.AspectRatio, req.Resolution)
	n := req.N
	if n <= 0 {
		n = 1
	}
	body := serviceRequest{
		Prompt: req.Prompt,
		N:      n,
		Width:  w,
		Height: h,
		Steps:  c.steps,
		Seed:   c.seed,
	}

	var lastErr error
	for attempt := 0; attempt <= c.maxRetries; attempt++ {
		if attempt > 0 {
			backoff := time.Duration(1<<uint(attempt-1)) * time.Second
			select {
			case <-ctx.Done():
				return nil, ctx.Err()
			case <-time.After(backoff):
			}
		}

		resp, err := c.doRequest(ctx, body)
		if err == nil {
			return resp, nil
		}

		apiErr, ok := err.(*imagegen.APIError)
		if !ok {
			lastErr = err
			continue
		}
		if !apiErr.Retryable {
			return nil, apiErr
		}
		lastErr = apiErr
	}

	return nil, fmt.Errorf("max retries exceeded: %w", lastErr)
}

func (c *Client) doRequest(ctx context.Context, body serviceRequest) (*imagegen.GenerateResponse, error) {
	raw, err := json.Marshal(body)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+generatePath, bytes.NewReader(raw))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")
	if c.token != "" {
		httpReq.Header.Set("Authorization", "Bearer "+c.token)
	}

	httpResp, err := c.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("HTTP request: %w", err)
	}
	defer httpResp.Body.Close()

	respBody, err := io.ReadAll(httpResp.Body)
	if err != nil {
		return nil, fmt.Errorf("read response: %w", err)
	}

	if httpResp.StatusCode != http.StatusOK {
		return nil, &imagegen.APIError{
			StatusCode: httpResp.StatusCode,
			Message:    string(respBody),
			Retryable:  httpResp.StatusCode >= 500,
		}
	}

	var result imagegen.GenerateResponse
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}
	return &result, nil
}
