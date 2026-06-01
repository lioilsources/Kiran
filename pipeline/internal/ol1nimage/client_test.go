package ol1nimage

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
	"time"

	"tyrian-pipeline/internal/imagegen"
)

// fakeImage returns a trivial base64-encoded byte slice for response fixtures.
func fakeImage(s string) string { return base64.StdEncoding.EncodeToString([]byte(s)) }

// newTestServer builds a server that serves a complete async job cycle:
//
//	POST /v1/images/generations → 202 {"id":"job1"}
//	GET  /v1/images/jobs/job1   → {"status":"done","result_url":"/v1/results/job1","count":N}
//	GET  /v1/results/job1       → raw PNG bytes
func newTestServer(t *testing.T, imageCount int, cfID, cfSecret string) *httptest.Server {
	t.Helper()
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if cfID != "" && r.Header.Get("CF-Access-Client-Id") != cfID {
			t.Errorf("CF-Access-Client-Id: want %q, got %q", cfID, r.Header.Get("CF-Access-Client-Id"))
		}
		if cfSecret != "" && r.Header.Get("CF-Access-Client-Secret") != cfSecret {
			t.Errorf("CF-Access-Client-Secret mismatch")
		}

		switch {
		case r.Method == http.MethodPost && r.URL.Path == generatePath:
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "job1"})

		case r.Method == http.MethodGet && r.URL.Path == jobsPath+"job1":
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(jobStatus{
				Status:    "done",
				ResultURL: "/v1/results/job1",
				Count:     imageCount,
			})

		case r.Method == http.MethodGet && r.URL.Path == "/v1/results/job1":
			idx := r.URL.Query().Get("index")
			w.WriteHeader(http.StatusOK)
			w.Write([]byte("img-" + idx))

		default:
			t.Errorf("unexpected request: %s %s", r.Method, r.URL.Path)
			w.WriteHeader(http.StatusNotFound)
		}
	}))
}

func TestGenerateSuccess(t *testing.T) {
	srv := newTestServer(t, 1, "id123", "sec456")
	defer srv.Close()

	c := NewClient("id123", "sec456",
		WithBaseURL(srv.URL),
		WithPollDelay(0),
		WithMaxRetries(0),
	)
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{
		Prompt:      "space ship",
		Model:       "flux-1-dev",
		N:           1,
		AspectRatio: "1:1",
		Resolution:  "1k",
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
	if string(b) != "img-" {
		t.Errorf("image data: got %q, want %q", string(b), "img-")
	}
}

func TestGenerateModelForwarded(t *testing.T) {
	var gotModel string
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == generatePath:
			var body map[string]any
			json.NewDecoder(r.Body).Decode(&body)
			if m, ok := body["model"].(string); ok {
				gotModel = m
			}
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "j1"})
		case r.Method == http.MethodGet && r.URL.Path == jobsPath+"j1":
			json.NewEncoder(w).Encode(jobStatus{Status: "done", ResultURL: "/r/j1", Count: 1})
		case r.Method == http.MethodGet && r.URL.Path == "/r/j1":
			w.Write([]byte("px"))
		}
	}))
	defer srv.Close()

	c := NewClient("", "", WithBaseURL(srv.URL), WithPollDelay(0), WithMaxRetries(0))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{
		Prompt: "test", Model: "flux-1-dev", N: 1,
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if gotModel != "flux-1-dev" {
		t.Errorf("model forwarded: got %q, want %q", gotModel, "flux-1-dev")
	}
}

func TestGenerateEmptyModelOmitted(t *testing.T) {
	var bodyFields map[string]any
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost:
			json.NewDecoder(r.Body).Decode(&bodyFields)
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "j1"})
		case r.Method == http.MethodGet && r.URL.Path == jobsPath+"j1":
			json.NewEncoder(w).Encode(jobStatus{Status: "done", ResultURL: "/r/j1", Count: 1})
		case r.Method == http.MethodGet && r.URL.Path == "/r/j1":
			w.Write([]byte("px"))
		}
	}))
	defer srv.Close()

	c := NewClient("", "", WithBaseURL(srv.URL), WithPollDelay(0), WithMaxRetries(0))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "test", N: 1})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if _, present := bodyFields["model"]; present {
		t.Error("model field should be omitted when empty")
	}
}

func TestGenerateMultipleImages(t *testing.T) {
	srv := newTestServer(t, 4, "", "")
	defer srv.Close()

	c := NewClient("", "", WithBaseURL(srv.URL), WithPollDelay(0), WithMaxRetries(0))
	resp, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "test", N: 4})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Data) != 4 {
		t.Fatalf("expected 4 images, got %d", len(resp.Data))
	}
	// Index 0 has no query param; indices 1..3 carry ?index=N
	for i, d := range resp.Data {
		b, _ := d.Bytes()
		want := ""
		if i > 0 {
			want = string(rune('0' + i))
		}
		if string(b) != "img-"+want {
			t.Errorf("image[%d]: got %q, want %q", i, string(b), "img-"+want)
		}
	}
}

func TestGenerateSubmitRetryOn500(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == generatePath:
			if calls.Add(1) <= 2 {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "j1"})
		case r.Method == http.MethodGet && r.URL.Path == jobsPath+"j1":
			json.NewEncoder(w).Encode(jobStatus{Status: "done", ResultURL: "/r/j1", Count: 1})
		case r.Method == http.MethodGet && r.URL.Path == "/r/j1":
			w.Write([]byte("px"))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer srv.Close()

	c := NewClient("", "", WithBaseURL(srv.URL), WithPollDelay(0), WithMaxRetries(3))
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

func TestGenerateJobError(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost:
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "j1"})
		case r.Method == http.MethodGet:
			json.NewEncoder(w).Encode(jobStatus{Status: "error", Error: "VRAM OOM"})
		}
	}))
	defer srv.Close()

	c := NewClient("", "", WithBaseURL(srv.URL), WithPollDelay(0))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil || err.Error() == "" {
		t.Fatal("expected error for failed job")
	}
}

func TestGenerateJobTimeout(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			w.WriteHeader(http.StatusAccepted)
			json.NewEncoder(w).Encode(map[string]string{"id": "j1"})
			return
		}
		// always return "running" — never finishes
		json.NewEncoder(w).Encode(jobStatus{Status: "running"})
	}))
	defer srv.Close()

	c := NewClient("", "",
		WithBaseURL(srv.URL),
		WithPollDelay(10*time.Millisecond),
		WithJobTimeout(50*time.Millisecond),
	)
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil {
		t.Fatal("expected timeout error")
	}
}

func TestSizeFromAspect(t *testing.T) {
	cases := []struct {
		ratio, res string
		want       string
	}{
		{"1:1", "1k", "1024x1024"},
		{"1:1", "2k", "2048x2048"},
		{"1:2", "1k", "512x1024"},
		{"1:2", "2k", "1024x2048"},
		{"2:1", "1k", "1024x512"},
		{"2:1", "2k", "2048x1024"},
		{"", "", "1024x1024"},
	}
	for _, c := range cases {
		got := sizeFromAspect(c.ratio, c.res)
		if got != c.want {
			t.Errorf("sizeFromAspect(%q,%q) = %q, want %q", c.ratio, c.res, got, c.want)
		}
	}
}

func TestGenerate401NoRetry(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte("unauthorized"))
	}))
	defer srv.Close()

	c := NewClient("bad", "bad", WithBaseURL(srv.URL), WithMaxRetries(3))
	_, err := c.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "x", N: 1})
	if err == nil {
		t.Fatal("expected error for 401")
	}
	if calls.Load() != 1 {
		t.Errorf("expected no retry on 401, got %d calls", calls.Load())
	}
}
