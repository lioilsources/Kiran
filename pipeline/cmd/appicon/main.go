// Command appicon renders app icon candidates for Kirian through ComfyUI.
//
// Each concept in concepts.json is wrapped in a shared icon frame (square,
// full-bleed background, one bold centred subject, no text) so the variants
// stay comparable. Output: <out>/<concept>_v<i>.png.
package main

import (
	"bufio"
	"context"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"time"

	"tyrian-pipeline/internal/comfyuiimage"
	"tyrian-pipeline/internal/imagegen"
)

type concept struct {
	ID     string `json:"id"`
	Title  string `json:"title"`
	Prompt string `json:"prompt"`
}

const frame = `Mobile game app icon for "Kirian", a vertical-scrolling space shooter. Square 1:1 composition.
Subject: %s.
One bold subject, centred, filling about 70%% of the frame, readable at 60x60 pixels. Full-bleed opaque background in deep space blue with a subtle glow, reaching every edge (the corners are rounded off by the phone, so nothing important near them).
Polished, high-contrast, saturated game key art. No text, no letters, no logo type, no border, no frame, no watermark, no UI.`

func main() {
	loadEnvFile(".env")
	conceptsPath := flag.String("concepts", "cmd/appicon/concepts.json", "Concept list")
	outDir := flag.String("out", "output/appicon", "Output directory")
	n := flag.Int("n", 6, "Variations per concept")
	only := flag.String("only", "", "Comma-separated concept ids (empty = all)")
	steps := flag.Int("steps", 0, "KSampler steps (0 = workflow default)")
	flag.Parse()

	raw, err := os.ReadFile(*conceptsPath)
	if err != nil {
		fail(err)
	}
	var concepts []concept
	if err := json.Unmarshal(raw, &concepts); err != nil {
		fail(err)
	}
	want := map[string]bool{}
	for _, id := range strings.Split(*only, ",") {
		if id = strings.TrimSpace(id); id != "" {
			want[id] = true
		}
	}

	url := os.Getenv("COMFYUI_API_URL")
	if url == "" {
		fail(fmt.Errorf("COMFYUI_API_URL is required"))
	}
	opts := []comfyuiimage.ClientOption{comfyuiimage.WithJobTimeout(20 * time.Minute)}
	if *steps > 0 {
		opts = append(opts, comfyuiimage.WithSteps(*steps))
	}
	client := comfyuiimage.NewClient(url, os.Getenv("CF_ACCESS_CLIENT_ID"), os.Getenv("CF_ACCESS_CLIENT_SECRET"), opts...)

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()
	if err := os.MkdirAll(*outDir, 0o755); err != nil {
		fail(err)
	}

	failed := 0
	for _, c := range concepts {
		if len(want) > 0 && !want[c.ID] {
			continue
		}
		fmt.Printf("--- %s (%s)\n", c.ID, c.Title)
		resp, err := client.Generate(ctx, imagegen.GenerateRequest{
			Prompt:         fmt.Sprintf(frame, c.Prompt),
			N:              *n,
			AspectRatio:    "1:1",
			Resolution:     "1k",
			FilenamePrefix: "appicon_" + c.ID,
		})
		if err != nil {
			fmt.Fprintf(os.Stderr, "FAIL %s: %v\n", c.ID, err)
			failed++
			continue
		}
		for i, d := range resp.Data {
			img, err := base64.StdEncoding.DecodeString(d.B64JSON)
			if err != nil {
				fmt.Fprintf(os.Stderr, "FAIL %s v%d: %v\n", c.ID, i+1, err)
				continue
			}
			p := filepath.Join(*outDir, fmt.Sprintf("%s_v%d.png", c.ID, i+1))
			if err := os.WriteFile(p, img, 0o644); err != nil {
				fail(err)
			}
		}
		fmt.Printf("  OK %d images\n", len(resp.Data))
	}
	if failed > 0 {
		os.Exit(1)
	}
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "Error:", err)
	os.Exit(1)
}

// loadEnvFile mirrors cmd/generate: KEY=VALUE lines, existing env wins.
func loadEnvFile(path string) {
	f, err := os.Open(path)
	if err != nil {
		return
	}
	defer f.Close()
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		key, val, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		if key = strings.TrimSpace(key); os.Getenv(key) == "" {
			os.Setenv(key, strings.TrimSpace(val))
		}
	}
}
