package postprocess

import (
	"bytes"
	"errors"
	"image"
	"image/color"
	"image/jpeg"
	"image/png"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"tyrian-pipeline/internal/skin"
)

func TestParseLayerName(t *testing.T) {
	tests := []struct {
		name      string
		wantLayer int
		wantZone  int
		wantOk    bool
	}{
		{"layer_0", 0, -1, true},
		{"layer_3", 3, -1, true},
		{"layer_0_z0", 0, 0, true},
		{"layer_1_z3", 1, 3, true},
		{"layer_1_z10", 1, 10, true},
		// Not backgrounds at all.
		{"preview", 0, 0, false},
		{"falcon", 0, 0, false},
		{"", 0, 0, false},
		// Malformed: a prefix match would wrongly accept these as layer 0.
		{"layer_", 0, 0, false},
		{"layer_0x", 0, 0, false},
		{"layer_1_zx", 0, 0, false},
	}

	for _, tt := range tests {
		layer, zone, ok := parseLayerName(tt.name)
		if ok != tt.wantOk {
			t.Errorf("parseLayerName(%q) ok=%v, want %v", tt.name, ok, tt.wantOk)
			continue
		}
		if !ok {
			continue
		}
		if layer != tt.wantLayer || zone != tt.wantZone {
			t.Errorf("parseLayerName(%q) = (%d, %d), want (%d, %d)",
				tt.name, layer, zone, tt.wantLayer, tt.wantZone)
		}
	}
}

// TestParseLayerNameRejectsLayer01 pins the reason parseLayerName exists rather
// than a strings.HasPrefix check: "layer_01" must not be treated as layer 0, or
// a future layer would silently skip chroma-keying.
func TestParseLayerNameRejectsLayer01(t *testing.T) {
	layer, _, ok := parseLayerName("layer_01")
	if !ok {
		t.Fatalf("layer_01 should parse")
	}
	if layer == 0 {
		t.Errorf("layer_01 parsed as layer 0 — a prefix match leaked in")
	}
}

// TestProcessBackgroundsZoneOpacity is the regression guard for the whole
// naming scheme: the opaque-vs-chroma-key decision must follow the parsed layer
// index, so every zone variant of layer_0 stays opaque. Getting this wrong lets
// the starfield bleed through the sky in game.
func TestProcessBackgroundsZoneOpacity(t *testing.T) {
	if _, err := exec.LookPath("dwebp"); err != nil {
		t.Skip("dwebp not installed; skipping WebP round-trip")
	}

	tmpDir := t.TempDir()
	srcDir := filepath.Join(tmpDir, "in", "backgrounds")
	bgDir := filepath.Join(tmpDir, "out", "backgrounds")
	if err := os.MkdirAll(srcDir, 0755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(bgDir, 0755); err != nil {
		t.Fatal(err)
	}

	// Uniform black frame with a bright centre. The corner-sampled chroma key
	// turns the black to alpha=0; the opaque branch leaves it alone.
	img := image.NewRGBA(image.Rect(0, 0, 16, 32))
	for y := 0; y < 32; y++ {
		for x := 0; x < 16; x++ {
			img.Set(x, y, color.RGBA{0, 0, 0, 255})
		}
	}
	img.Set(8, 16, color.RGBA{255, 32, 32, 255})

	var buf bytes.Buffer
	if err := jpeg.Encode(&buf, img, nil); err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{"layer_0_z3", "layer_1_z3"} {
		p := filepath.Join(srcDir, name+"_v1.jpg")
		if err := os.WriteFile(p, buf.Bytes(), 0644); err != nil {
			t.Fatal(err)
		}
	}

	cfg := Config{
		SkinDir:     filepath.Join(tmpDir, "in"),
		OutputDir:   filepath.Join(tmpDir, "out"),
		Variation:   1,
		BgThreshold: 60,
		BgMargin:    20,
	}

	for _, tc := range []struct {
		name       string
		wantOpaque bool
	}{
		{"layer_0_z3", true},
		{"layer_1_z3", false},
	} {
		asset := skin.ManifestAsset{Name: tc.name, Type: "background", Dir: "backgrounds"}
		if err := processBackgrounds(cfg, asset, bgDir); err != nil {
			t.Fatalf("processBackgrounds(%s): %v", tc.name, err)
		}

		outPath := filepath.Join(bgDir, tc.name+".webp")
		if _, err := os.Stat(outPath); err != nil {
			t.Fatalf("%s: expected .webp output: %v", tc.name, err)
		}

		if gotOpaque := webpIsOpaque(t, outPath); gotOpaque != tc.wantOpaque {
			t.Errorf("%s: opaque=%v, want %v", tc.name, gotOpaque, tc.wantOpaque)
		}
	}
}

// TestProcessBackgroundsMissingSourceIsNotExist pins the error identity the
// rollout depends on: postprocess must be able to tell "this skin has no zone
// art yet" apart from a real failure, or one un-generated skin aborts the whole
// run including its sprites and audio.
func TestProcessBackgroundsMissingSourceIsNotExist(t *testing.T) {
	tmpDir := t.TempDir()
	bgDir := filepath.Join(tmpDir, "out", "backgrounds")
	if err := os.MkdirAll(bgDir, 0755); err != nil {
		t.Fatal(err)
	}

	cfg := Config{
		SkinDir:   filepath.Join(tmpDir, "in"),
		OutputDir: filepath.Join(tmpDir, "out"),
		Variation: 1,
	}
	asset := skin.ManifestAsset{Name: "layer_0_z5", Type: "background", Dir: "backgrounds"}

	err := processBackgrounds(cfg, asset, bgDir)
	if err == nil {
		t.Fatal("expected an error for a missing source")
	}
	// errors.Is, not os.IsNotExist: the error is wrapped with %w and the legacy
	// helper does not unwrap. Run() relies on errors.Is for exactly this.
	if !errors.Is(err, os.ErrNotExist) {
		t.Errorf("error does not unwrap to os.ErrNotExist: %v", err)
	}
}

func TestPruneStaleBackgrounds(t *testing.T) {
	tests := []struct {
		name     string
		files    []string
		written  map[string]bool
		complete bool
		wantKept []string
		wantGone []string
	}{
		{
			// Fully migrated skin: the PNGs it replaced go, the WebPs stay.
			name:     "complete migration drops superseded png",
			files:    []string{"layer_0.png", "layer_1.png", "layer_0_z0.webp", "layer_1_z0.webp", ".gitkeep"},
			written:  map[string]bool{"layer_0_z0": true, "layer_1_z0": true},
			complete: true,
			wantKept: []string{"layer_0_z0.webp", "layer_1_z0.webp", ".gitkeep"},
			wantGone: []string{"layer_0.png", "layer_1.png"},
		},
		{
			// Un-migrated skin re-run: its old flat manifest yields four flat
			// WebPs, each superseding the PNG of the same name via rule 1.
			name:     "unmigrated skin converts flat art in place",
			files:    []string{"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png", "layer_0.webp", "layer_1.webp", "layer_2.webp", "layer_3.webp"},
			written:  map[string]bool{"layer_0": true, "layer_1": true, "layer_2": true, "layer_3": true},
			complete: true,
			wantKept: []string{"layer_0.webp", "layer_1.webp", "layer_2.webp", "layer_3.webp"},
			wantGone: []string{"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png"},
		},
		{
			// Nothing succeeded: Run() would compute complete=false (and in fact
			// skips the prune entirely), so the flat art must survive.
			name:     "failed run keeps everything",
			files:    []string{"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png"},
			written:  map[string]bool{},
			complete: false,
			wantKept: []string{"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png"},
		},
		{
			// Same-name replacement: the PNG a WebP just superseded goes.
			// Safe even on an incomplete run — the replacement is right there.
			name:     "png superseded by same-name webp",
			files:    []string{"layer_2.png", "layer_2.webp", "layer_3.png"},
			written:  map[string]bool{"layer_2": true},
			complete: false,
			wantKept: []string{"layer_2.webp", "layer_3.png"},
			wantGone: []string{"layer_2.png"},
		},
		{
			// The regression this rule exists for: an image backend dying
			// mid-run leaves only some zones generated. Pruning the flat art
			// then would strand every zone the run never reached with no base
			// plate at all — the fallback must survive.
			name: "partial run keeps fallback art for unreached zones",
			files: []string{
				"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png",
				"layer_0_z0.webp", "layer_0_z1.webp",
			},
			written:  map[string]bool{"layer_0_z0": true, "layer_0_z1": true},
			complete: false,
			wantKept: []string{
				"layer_0.png", "layer_1.png", "layer_2.png", "layer_3.png",
				"layer_0_z0.webp", "layer_0_z1.webp",
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			bgDir := t.TempDir()
			for _, f := range tt.files {
				if err := os.WriteFile(filepath.Join(bgDir, f), []byte("x"), 0644); err != nil {
					t.Fatal(err)
				}
			}

			if err := pruneStaleBackgrounds(bgDir, tt.written, tt.complete); err != nil {
				t.Fatalf("pruneStaleBackgrounds: %v", err)
			}

			for _, f := range tt.wantKept {
				if _, err := os.Stat(filepath.Join(bgDir, f)); err != nil {
					t.Errorf("%s was pruned but should have been kept", f)
				}
			}
			for _, f := range tt.wantGone {
				if _, err := os.Stat(filepath.Join(bgDir, f)); err == nil {
					t.Errorf("%s survived but should have been pruned", f)
				}
			}
		})
	}
}

// webpIsOpaque decodes a WebP via dwebp and reports whether every pixel is
// fully opaque.
func webpIsOpaque(t *testing.T, path string) bool {
	t.Helper()

	cmd := exec.Command("dwebp", path, "-o", "-")
	var out, stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("dwebp %s: %v\n%s", path, err, stderr.String())
	}

	img, err := png.Decode(&out)
	if err != nil {
		t.Fatalf("decode dwebp output for %s: %v", path, err)
	}

	b := img.Bounds()
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			if _, _, _, a := img.At(x, y).RGBA(); a != 0xffff {
				return false
			}
		}
	}
	return true
}
