package comfyuiimage

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

// TestEditUploadsAndInjects drives Edit against a fake ComfyUI: the source is
// uploaded, the returned name lands in the LoadImage node, the instruction in
// the text node, and the first output image comes back decoded.
func TestEditUploadsAndInjects(t *testing.T) {
	var graph map[string]map[string]any
	mux := http.NewServeMux()
	mux.HandleFunc("/upload/image", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseMultipartForm(1 << 20); err != nil {
			t.Errorf("upload not multipart: %v", err)
		}
		io.WriteString(w, `{"name":"stored.png","subfolder":"","type":"input"}`)
	})
	mux.HandleFunc("/prompt", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Prompt map[string]map[string]any `json:"prompt"`
		}
		json.NewDecoder(r.Body).Decode(&body)
		graph = body.Prompt
		io.WriteString(w, `{"prompt_id":"p1"}`)
	})
	mux.HandleFunc("/history/p1", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, `{"p1":{"status":{"status_str":"success","completed":true},"outputs":{"10":{"images":[{"filename":"o.png","subfolder":"","type":"output"}]}}}}`)
	})
	mux.HandleFunc("/view", func(w http.ResponseWriter, r *http.Request) { io.WriteString(w, "PNGDATA") })
	srv := httptest.NewServer(mux)
	defer srv.Close()

	c := NewClient(srv.URL, "", "", WithPollDelay(1))
	got, err := c.Edit(context.Background(), []byte("src"), "shut the eyes", "anim_blink", 7)
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != "PNGDATA" {
		t.Errorf("got %q", got)
	}
	in := func(node, key string) any { return graph[node]["inputs"].(map[string]any)[key] }
	if in("11", "image") != "stored.png" {
		t.Errorf("LoadImage got %v", in("11", "image"))
	}
	if s, _ := in("4", "text").(string); !strings.Contains(s, "shut the eyes") {
		t.Errorf("instruction not injected: %v", in("4", "text"))
	}
	if in("8", "seed") != float64(7) {
		t.Errorf("seed got %v", in("8", "seed"))
	}
}
