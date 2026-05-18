package grokimage

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"time"

	"tyrian-pipeline/internal/imagegen"
)

const defaultAPIURL = "https://api.x.ai/v1/images/generations"

// The image generation contract lives in the backend-neutral imagegen
// package. These aliases keep grokimage.* references working for callers
// and tests while the concrete types are shared across backends.
type (
	ImageGenerator   = imagegen.ImageGenerator
	GenerateRequest  = imagegen.GenerateRequest
	GenerateResponse = imagegen.GenerateResponse
	ImageData        = imagegen.ImageData
	APIError         = imagegen.APIError
)

// Client implements ImageGenerator using the xAI Grok Image API.
type Client struct {
	apiKey     string
	apiURL     string
	httpClient *http.Client
	maxRetries int
}

// ClientOption configures the Client.
type ClientOption func(*Client)

// WithAPIURL overrides the default API endpoint (for testing).
func WithAPIURL(url string) ClientOption {
	return func(c *Client) { c.apiURL = url }
}

// WithHTTPClient sets a custom HTTP client.
func WithHTTPClient(hc *http.Client) ClientOption {
	return func(c *Client) { c.httpClient = hc }
}

// WithMaxRetries sets the maximum retry count.
func WithMaxRetries(n int) ClientOption {
	return func(c *Client) { c.maxRetries = n }
}

// NewClient creates a new Grok Image API client.
func NewClient(apiKey string, opts ...ClientOption) *Client {
	c := &Client{
		apiKey:     apiKey,
		apiURL:     defaultAPIURL,
		httpClient: &http.Client{Timeout: 120 * time.Second},
		maxRetries: 3,
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

// Generate sends an image generation request with retry logic.
func (c *Client) Generate(ctx context.Context, req GenerateRequest) (*GenerateResponse, error) {
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

		resp, err := c.doRequest(ctx, req)
		if err == nil {
			return resp, nil
		}

		apiErr, ok := err.(*APIError)
		if !ok {
			lastErr = err
			continue
		}

		// Fatal errors — don't retry
		if apiErr.StatusCode == 401 {
			return nil, fmt.Errorf("authentication failed: %w", apiErr)
		}

		// Content policy rejection — skip this asset
		if apiErr.StatusCode == 400 {
			return nil, fmt.Errorf("content rejected: %w", apiErr)
		}

		// Rate limit — respect Retry-After
		if apiErr.StatusCode == 429 {
			lastErr = apiErr
			// backoff is already handled above, but could parse Retry-After
			continue
		}

		// Model not found — try fallback
		if apiErr.StatusCode == 404 && req.Model == "grok-imagine-image" {
			req.Model = "grok-2-image"
			attempt-- // don't count this as a retry
			continue
		}

		if !apiErr.Retryable {
			return nil, apiErr
		}
		lastErr = apiErr
	}

	return nil, fmt.Errorf("max retries exceeded: %w", lastErr)
}

func (c *Client) doRequest(ctx context.Context, req GenerateRequest) (*GenerateResponse, error) {
	body, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, c.apiURL, bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	httpReq.Header.Set("Authorization", "Bearer "+c.apiKey)
	httpReq.Header.Set("Content-Type", "application/json")

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
		retryAfter := httpResp.Header.Get("Retry-After")
		msg := string(respBody)
		retryable := httpResp.StatusCode >= 500 || httpResp.StatusCode == 429

		if retryAfter != "" {
			if secs, err := strconv.Atoi(retryAfter); err == nil {
				msg += fmt.Sprintf(" (retry-after: %ds)", secs)
			}
		}

		return nil, &APIError{
			StatusCode: httpResp.StatusCode,
			Message:    msg,
			Retryable:  retryable,
		}
	}

	var result GenerateResponse
	if err := json.Unmarshal(respBody, &result); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}
	return &result, nil
}
