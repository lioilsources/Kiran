package comfyuiimage

import (
	"bytes"
	"context"
	_ "embed"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
)

// editWorkflow is the Flux Kontext image-edit graph: the source image is
// uploaded to ComfyUI, encoded, and fed to the sampler as a reference latent
// next to the edit instruction, so the output keeps the source's design and
// changes only what the instruction names.
//
//go:embed workflows/flux_kontext_edit.json
var editWorkflow []byte

const uploadPath = "/upload/image"

// Edit applies a natural-language edit instruction to src (PNG or JPEG bytes)
// and returns the edited image as PNG bytes. seed=0 picks a random seed.
func (c *Client) Edit(ctx context.Context, src []byte, instruction, filenamePrefix string, seed int64) ([]byte, error) {
	name, err := c.upload(ctx, src)
	if err != nil {
		return nil, fmt.Errorf("upload source: %w", err)
	}

	var graph map[string]any
	if err := json.Unmarshal(editWorkflow, &graph); err != nil {
		return nil, fmt.Errorf("parse edit workflow: %w", err)
	}
	if seed == 0 {
		seed = randSeed()
	}
	for _, in := range []struct {
		node, key string
		val       any
	}{
		{"11", "image", name},
		{"4", "text", instruction},
		{"8", "seed", seed},
		{"10", "filename_prefix", filenamePrefix},
	} {
		if err := setNodeInput(graph, in.node, in.key, in.val); err != nil {
			return nil, err
		}
	}

	promptID, err := c.submitWithRetry(ctx, graph)
	if err != nil {
		return nil, err
	}
	images, err := c.pollUntilDone(ctx, promptID)
	if err != nil {
		return nil, err
	}
	if len(images) == 0 {
		return nil, fmt.Errorf("edit job %s produced no image", promptID)
	}
	b64, err := c.downloadImage(ctx, images[0])
	if err != nil {
		return nil, err
	}
	return base64.StdEncoding.DecodeString(b64)
}

// upload stores src in ComfyUI's input folder and returns the name LoadImage
// must use to read it back.
func (c *Client) upload(ctx context.Context, src []byte) (string, error) {
	var buf bytes.Buffer
	mw := multipart.NewWriter(&buf)
	fw, err := mw.CreateFormFile("image", "tyrian_src_"+randHex(6)+".png")
	if err != nil {
		return "", err
	}
	if _, err := fw.Write(src); err != nil {
		return "", err
	}
	if err := mw.Close(); err != nil {
		return "", err
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+uploadPath, &buf)
	if err != nil {
		return "", err
	}
	for k, v := range c.cfHeaders() {
		req.Header.Set(k, v)
	}
	// After cfHeaders: those default to a JSON content type.
	req.Header.Set("Content-Type", mw.FormDataContentType())
	resp, err := c.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("HTTP request: %w", err)
	}
	defer resp.Body.Close()
	body, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("upload: HTTP %d: %s", resp.StatusCode, body)
	}
	var out struct {
		Name string `json:"name"`
	}
	if err := json.Unmarshal(body, &out); err != nil || out.Name == "" {
		return "", fmt.Errorf("upload: unexpected response %q", body)
	}
	return out.Name, nil
}
