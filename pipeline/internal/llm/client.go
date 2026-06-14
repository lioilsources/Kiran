// Package llm is a minimal OpenAI-compatible chat-completion client used for
// prompt validation (vision) and prompt refinement (text) in the tuning loop.
package llm

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

const defaultTimeout = 300 * time.Second

// Client calls an OpenAI-compatible /v1/chat/completions endpoint.
type Client struct {
	baseURL    string
	model      string
	cfClientID string
	cfSecret   string
	httpClient *http.Client
}

// NewClient creates a client. cfClientID and cfSecret are optional Cloudflare
// Access service-token credentials (pass empty strings for open endpoints).
func NewClient(baseURL, model, cfClientID, cfSecret string) *Client {
	return &Client{
		baseURL:    strings.TrimRight(baseURL, "/"),
		model:      model,
		cfClientID: cfClientID,
		cfSecret:   cfSecret,
		httpClient: &http.Client{Timeout: defaultTimeout},
	}
}

// Model returns the model name this client targets.
func (c *Client) Model() string { return c.model }

// Complete sends a system + user message and returns the assistant reply.
func (c *Client) Complete(ctx context.Context, system, user string) (string, error) {
	messages := []any{
		map[string]any{"role": "system", "content": system},
		map[string]any{"role": "user", "content": user},
	}
	return c.complete(ctx, messages)
}

// CompleteVision sends a system + user message with an image and returns the
// assistant reply. img must be raw JPEG/PNG/WebP bytes.
func (c *Client) CompleteVision(ctx context.Context, system, user string, img []byte) (string, error) {
	dataURI := "data:" + sniffMIME(img) + ";base64," + base64.StdEncoding.EncodeToString(img)
	messages := []any{
		map[string]any{"role": "system", "content": system},
		map[string]any{"role": "user", "content": []any{
			map[string]any{"type": "text", "text": user},
			map[string]any{"type": "image_url", "image_url": map[string]any{"url": dataURI}},
		}},
	}
	return c.complete(ctx, messages)
}

func (c *Client) complete(ctx context.Context, messages []any) (string, error) {
	body, err := json.Marshal(map[string]any{
		"model":       c.model,
		"messages":    messages,
		"temperature": 0.2,
		"max_tokens":  2048,
	})
	if err != nil {
		return "", fmt.Errorf("marshal request: %w", err)
	}

	newReq := func() (*http.Request, error) {
		req, err := http.NewRequestWithContext(ctx, http.MethodPost,
			c.baseURL+"/v1/chat/completions", bytes.NewReader(body))
		if err != nil {
			return nil, err
		}
		req.Header.Set("Content-Type", "application/json")
		if c.cfClientID != "" {
			req.Header.Set("CF-Access-Client-Id", c.cfClientID)
		}
		if c.cfSecret != "" {
			req.Header.Set("CF-Access-Client-Secret", c.cfSecret)
		}
		return req, nil
	}

	var respBody []byte
	for attempt := 0; attempt < 4; attempt++ {
		if attempt > 0 {
			select {
			case <-ctx.Done():
				return "", ctx.Err()
			case <-time.After(time.Duration(2<<uint(attempt-1)) * time.Second):
			}
		}
		req, err := newReq()
		if err != nil {
			return "", fmt.Errorf("build request: %w", err)
		}
		resp, doErr := c.httpClient.Do(req)
		if doErr != nil {
			if attempt == 3 {
				return "", fmt.Errorf("HTTP request: %w", doErr)
			}
			continue
		}
		respBody, _ = io.ReadAll(resp.Body)
		resp.Body.Close()
		if resp.StatusCode == http.StatusOK {
			break
		}
		if resp.StatusCode < 500 && resp.StatusCode != http.StatusNotFound {
			return "", fmt.Errorf("HTTP %d: %s", resp.StatusCode, respBody)
		}
		if attempt == 3 {
			return "", fmt.Errorf("HTTP %d: %s", resp.StatusCode, respBody)
		}
	}

	var payload struct {
		Choices []struct {
			Message struct {
				Content *string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}
	if err := json.Unmarshal(respBody, &payload); err != nil {
		return "", fmt.Errorf("decode response: %w", err)
	}
	if len(payload.Choices) == 0 || payload.Choices[0].Message.Content == nil {
		return "", fmt.Errorf("empty response from model")
	}
	return *payload.Choices[0].Message.Content, nil
}

func sniffMIME(b []byte) string {
	switch {
	case len(b) >= 8 && string(b[:8]) == "\x89PNG\r\n\x1a\n":
		return "image/png"
	case len(b) >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF:
		return "image/jpeg"
	case len(b) >= 12 && string(b[:4]) == "RIFF" && string(b[8:12]) == "WEBP":
		return "image/webp"
	default:
		return "image/png"
	}
}
