package qwenimage

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"

	"tyrian-pipeline/internal/imagegen"
)

func TestClientGenerateSuccess(t *testing.T) {
	fakeImage := base64.StdEncoding.EncodeToString([]byte("fake-jpg-data"))

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != generatePath {
			t.Errorf("expected path %s, got %s", generatePath, r.URL.Path)
		}
		if r.Header.Get("Authorization") != "Bearer test-token" {
			t.Error("missing or wrong Authorization header")
		}
		var req serviceRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			t.Fatalf("decode request: %v", err)
		}
		if req.Width != 1024 || req.Height != 1024 {
			t.Errorf("expected 1024x1024 for 1:1/1k, got %dx%d", req.Width, req.Height)
		}
		if req.Steps != 8 {
			t.Errorf("expected steps=8, got %d", req.Steps)
		}
		if req.N != 4 {
			t.Errorf("expected N=4, got %d", req.N)
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(imagegen.GenerateResponse{
			Data: []imagegen.ImageData{{B64JSON: fakeImage}},
		})
	}))
	defer server.Close()

	client := NewClient(server.URL, "test-token", WithMaxRetries(0))
	resp, err := client.Generate(context.Background(), imagegen.GenerateRequest{
		Prompt:      "test prompt",
		N:           4,
		AspectRatio: "1:1",
		Resolution:  "1k",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Data) != 1 {
		t.Fatalf("expected 1 image, got %d", len(resp.Data))
	}
	imgBytes, err := resp.Data[0].Bytes()
	if err != nil {
		t.Fatalf("decode image: %v", err)
	}
	if string(imgBytes) != "fake-jpg-data" {
		t.Error("decoded image data mismatch")
	}
}

func TestDimensionMapping(t *testing.T) {
	cases := []struct {
		ratio, res string
		w, h       int
	}{
		{"1:1", "1k", 1024, 1024},
		{"1:1", "2k", 2048, 2048},
		{"1:2", "2k", 1024, 2048},
		{"1:2", "1k", 512, 1024},
		{"", "", 1024, 1024},
	}
	for _, c := range cases {
		w, h := dimensions(c.ratio, c.res)
		if w != c.w || h != c.h {
			t.Errorf("dimensions(%q,%q) = %dx%d, want %dx%d", c.ratio, c.res, w, h, c.w, c.h)
		}
	}
}

func TestClientNoAuthHeaderWhenNoToken(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("Authorization") != "" {
			t.Error("expected no Authorization header when token is empty")
		}
		json.NewEncoder(w).Encode(imagegen.GenerateResponse{
			Data: []imagegen.ImageData{{B64JSON: base64.StdEncoding.EncodeToString([]byte("x"))}},
		})
	}))
	defer server.Close()

	client := NewClient(server.URL, "", WithMaxRetries(0))
	if _, err := client.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "p", N: 1}); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestClientRetryOn500(t *testing.T) {
	var calls atomic.Int32
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if calls.Add(1) <= 2 {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte("server error"))
			return
		}
		json.NewEncoder(w).Encode(imagegen.GenerateResponse{
			Data: []imagegen.ImageData{{B64JSON: base64.StdEncoding.EncodeToString([]byte("ok"))}},
		})
	}))
	defer server.Close()

	client := NewClient(server.URL, "", WithMaxRetries(3))
	resp, err := client.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "test", N: 1})
	if err != nil {
		t.Fatalf("expected success after retries, got: %v", err)
	}
	if len(resp.Data) != 1 {
		t.Error("expected 1 image after retry")
	}
	if calls.Load() != 3 {
		t.Errorf("expected 3 calls (2 failures + 1 success), got %d", calls.Load())
	}
}

func TestClientFatalOn400(t *testing.T) {
	var calls atomic.Int32
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("bad request"))
	}))
	defer server.Close()

	client := NewClient(server.URL, "", WithMaxRetries(3))
	_, err := client.Generate(context.Background(), imagegen.GenerateRequest{Prompt: "test", N: 1})
	if err == nil {
		t.Fatal("expected error for 400")
	}
	if calls.Load() != 1 {
		t.Errorf("expected no retries on 400, got %d calls", calls.Load())
	}
}
