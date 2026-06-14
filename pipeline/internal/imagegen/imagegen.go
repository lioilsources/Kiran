// Package imagegen defines the backend-neutral image generation contract
// shared by all image backends (Grok, self-hosted Qwen-Image, etc.).
package imagegen

import (
	"context"
	"encoding/base64"
	"fmt"
)

// ImageGenerator is the interface for image generation backends.
type ImageGenerator interface {
	Generate(ctx context.Context, req GenerateRequest) (*GenerateResponse, error)
}

// GenerateRequest is a backend-neutral image generation request.
// AspectRatio/Resolution are semantic hints; each backend maps them to
// its own native parameters (e.g. concrete pixel dimensions).
type GenerateRequest struct {
	Model          string `json:"model"`
	Prompt         string `json:"prompt"`
	NegativePrompt string `json:"negative_prompt,omitempty"`
	N              int    `json:"n"`
	AspectRatio    string `json:"aspect_ratio,omitempty"`
	Resolution     string `json:"resolution,omitempty"`
	ResponseFormat string `json:"response_format"`
	Seed           int64  `json:"seed,omitempty"`
	FilenamePrefix string `json:"filename_prefix,omitempty"` // injected into SaveImage node
}

// GenerateResponse holds generated images.
type GenerateResponse struct {
	Data []ImageData `json:"data"`
}

// ImageData represents a single generated image.
type ImageData struct {
	B64JSON       string `json:"b64_json"`
	RevisedPrompt string `json:"revised_prompt"`
	URL           string `json:"url"`
}

// Bytes decodes the base64 image data.
func (d ImageData) Bytes() ([]byte, error) {
	return base64.StdEncoding.DecodeString(d.B64JSON)
}

// APIError represents an error response from an image backend.
type APIError struct {
	StatusCode int
	Message    string
	Retryable  bool
}

func (e *APIError) Error() string {
	return fmt.Sprintf("API error %d: %s", e.StatusCode, e.Message)
}
