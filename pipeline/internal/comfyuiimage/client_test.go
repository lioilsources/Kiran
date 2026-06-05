package comfyuiimage

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
	"time"

	"tyrian-pipeline/internal/imagegen"
)

// historyResponse builds a completed /history payload with imageCount output
// images on the SaveImage node.
func historyResponse(promptID string, imageCount int) map[string]any {
	images := make([]map[string]any, imageCount)
	for i := range images {
		images[i] = map[string]any{
			"filename":  "tyrian_0000" + string(rune('1'+i)) + ".png",
			"subfolder": "",
			"type":      "output",
		}
	}
	return map[string]any{
		promptID: map[string]any{
			"status":  map[string]any{"status_str": "success", "completed": true},
			"outputs": map[string]any{"9": map[string]any{"images": images}},
		},
	}
}

func TestGenerateSuccess(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("CF-Access-Client-Id") != "id123" {
			t.Errorf("missing/incorrect CF-Access-Client-Id: %q", r.Header.Get("CF-Access-Client-Id"))
		}
		switch {
		case r.Method == http.MethodPost && r.URL.Path == promptPath:
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.Method == http.MethodGet && r.URL.Path == historyPath+"p1":
			json.NewEncoder(w).Encode(historyResponse("p1", 1))
		case r.Method == http.MethodGet && r.URL.Path == viewPath:
			w.Write([]byte("png-" + r.URL.Query().Get("filename")))
		default:
			t.Errorf("unexpected request: %s %s", r.Method, r.URL.Path)
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "id123", "sec456", WithPollDelay(0), WithMaxRetries(0))
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{
		Prompt: "space ship", Model: "flux-1-dev", N: 1, AspectRatio: "1:1", Resolution: "1k",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Data) != 1 {
		t.Fatalf("expected 1 image, got %d", len(resp.Data))
	}
	b, err := resp.Data[0].Bytes()
	if err != nil {
		t.Fatalf("decode b64: %v", err)
	}
	if string(b) != "png-tyrian_00001.png" {
		t.Errorf("image data: got %q", string(b))
	}
}

func TestGenerateInjectsWorkflow(t *testing.T) {
	var graph map[string]any
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == promptPath:
			var body struct {
				Prompt   map[string]any `json:"prompt"`
				ClientID string         `json:"client_id"`
			}
			json.NewDecoder(r.Body).Decode(&body)
			graph = body.Prompt
			if body.ClientID == "" {
				t.Error("client_id should not be empty")
			}
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.URL.Path == historyPath+"p1":
			json.NewEncoder(w).Encode(historyResponse("p1", 4))
		case r.URL.Path == viewPath:
			w.Write([]byte("x"))
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(0), WithMaxRetries(0))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{
		Prompt: "a falcon fighter", N: 4, AspectRatio: "4:1", Resolution: "1k",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	pos := graph["6"].(map[string]any)["inputs"].(map[string]any)
	if pos["text"] != "a falcon fighter" {
		t.Errorf("positive prompt not injected: %v", pos["text"])
	}
	latent := graph["5"].(map[string]any)["inputs"].(map[string]any)
	if latent["width"] != float64(2048) || latent["height"] != float64(512) {
		t.Errorf("dimensions not injected: %vx%v", latent["width"], latent["height"])
	}
	if latent["batch_size"] != float64(4) {
		t.Errorf("batch_size: got %v, want 4", latent["batch_size"])
	}
	sampler := graph["3"].(map[string]any)["inputs"].(map[string]any)
	if _, ok := sampler["seed"]; !ok {
		t.Error("seed not present on sampler node")
	}
}

func TestGenerateMultipleImages(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == promptPath:
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.URL.Path == historyPath+"p1":
			json.NewEncoder(w).Encode(historyResponse("p1", 4))
		case r.URL.Path == viewPath:
			w.Write([]byte("img-" + r.URL.Query().Get("filename")))
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(0), WithMaxRetries(0))
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 4})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Data) != 4 {
		t.Fatalf("expected 4 images, got %d", len(resp.Data))
	}
}

func TestGeneratePollsUntilReady(t *testing.T) {
	var polls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == promptPath:
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.URL.Path == historyPath+"p1":
			// First two polls: job not in history yet (empty object).
			if polls.Add(1) <= 2 {
				json.NewEncoder(w).Encode(map[string]any{})
				return
			}
			json.NewEncoder(w).Encode(historyResponse("p1", 1))
		case r.URL.Path == viewPath:
			w.Write([]byte("done"))
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(time.Millisecond), WithMaxRetries(0))
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Data) != 1 {
		t.Fatalf("expected 1 image, got %d", len(resp.Data))
	}
	if polls.Load() < 3 {
		t.Errorf("expected at least 3 polls, got %d", polls.Load())
	}
}

func TestGenerateSubmitRetryOn500(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == promptPath:
			if calls.Add(1) <= 2 {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.URL.Path == historyPath+"p1":
			json.NewEncoder(w).Encode(historyResponse("p1", 1))
		case r.URL.Path == viewPath:
			w.Write([]byte("ok"))
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(0), WithMaxRetries(3))
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err != nil {
		t.Fatalf("expected success after retries: %v", err)
	}
	if len(resp.Data) != 1 {
		t.Error("expected 1 image")
	}
	if calls.Load() != 3 {
		t.Errorf("expected 3 submit calls, got %d", calls.Load())
	}
}

func TestGenerateInvalidGraphNoRetry(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]any{"node_errors": map[string]any{"3": "bad"}})
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(0), WithMaxRetries(3))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil {
		t.Fatal("expected error for 400 invalid graph")
	}
	if calls.Load() != 1 {
		t.Errorf("expected no retry on 400, got %d calls", calls.Load())
	}
}

func TestGenerateJobError(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost:
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
		case r.URL.Path == historyPath+"p1":
			json.NewEncoder(w).Encode(map[string]any{
				"p1": map[string]any{
					"status": map[string]any{"status_str": "error", "completed": false},
				},
			})
		}
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(0))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil {
		t.Fatal("expected error for failed job")
	}
}

func TestGenerateJobTimeout(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			json.NewEncoder(w).Encode(map[string]any{"prompt_id": "p1"})
			return
		}
		// History never contains the job → never finishes.
		json.NewEncoder(w).Encode(map[string]any{})
	}))
	defer srv.Close()

	c := NewClient(srv.URL, "", "",
		WithPollDelay(10*time.Millisecond),
		WithJobTimeout(50*time.Millisecond),
	)
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil {
		t.Fatal("expected timeout error")
	}
}

func TestDimensions(t *testing.T) {
	cases := []struct {
		ratio, res string
		wantW      int
		wantH      int
	}{
		{"1:1", "1k", 1024, 1024},
		{"1:1", "2k", 2048, 2048},
		{"1:2", "1k", 512, 1024},
		{"2:1", "1k", 1024, 512},
		{"4:1", "1k", 2048, 512},
		{"4:1", "2k", 4096, 1024},
		{"", "", 1024, 1024},
	}
	for _, c := range cases {
		w, h := dimensions(c.ratio, c.res)
		if w != c.wantW || h != c.wantH {
			t.Errorf("dimensions(%q,%q) = %dx%d, want %dx%d", c.ratio, c.res, w, h, c.wantW, c.wantH)
		}
	}
}

func TestDefaultWorkflowParsesAndHasRoleNodes(t *testing.T) {
	c := NewClient("http://x", "", "")
	graph, err := c.buildWorkflow("hello", 1024, 1024, 2)
	if err != nil {
		t.Fatalf("buildWorkflow failed: %v", err)
	}
	for _, id := range []string{c.roles.PositivePrompt, c.roles.Latent, c.roles.Sampler} {
		if _, ok := graph[id]; !ok {
			t.Errorf("embedded workflow missing role node %q", id)
		}
	}
}
