package postprocess

import (
	"bytes"
	"encoding/json"
	"image"
	"image/color"
	"image/jpeg"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"tyrian-pipeline/internal/skin"
)

func TestGameName_Mapping(t *testing.T) {
	tests := []struct {
		input    string
		wantName string
		wantOk   bool
	}{
		{"ship_frames", "vessel", true},
		{"falcon", "falcon", true},
		{"falcon1", "falcon1", true},
		{"falconx", "falconx", true},
		{"laser", "laser", true},
		{"asteroid", "asteroid", true},
	}
	for _, tt := range tests {
		name, ok := GameName(tt.input)
		if name != tt.wantName || ok != tt.wantOk {
			t.Errorf("GameName(%q) = (%q, %v), want (%q, %v)",
				tt.input, name, ok, tt.wantName, tt.wantOk)
		}
	}
}

func TestStripVariationSuffix(t *testing.T) {
	tests := []struct{ input, want string }{
		{"falcon_v2", "falcon"},
		{"explosion_v1", "explosion"},
		{"falconxb_v10", "falconxb"},
		{"no_suffix", "no_suffix"},
		{"has_vx", "has_vx"}, // non-digit after _v
	}
	for _, tt := range tests {
		got := StripVariationSuffix(tt.input)
		if got != tt.want {
			t.Errorf("StripVariationSuffix(%q) = %q, want %q", tt.input, got, tt.want)
		}
	}
}

func TestRun_SyntheticSkin(t *testing.T) {
	// Create a minimal fake skin directory with a manifest and synthetic JPEGs
	tmpDir := t.TempDir()
	skinDir := filepath.Join(tmpDir, "input", "test_skin")
	spritesDir := filepath.Join(skinDir, "sprites")
	uiDir := filepath.Join(skinDir, "ui")
	os.MkdirAll(spritesDir, 0755)
	os.MkdirAll(uiDir, 0755)

	// Minimal manifest with just a few assets
	manifest := skin.Manifest{
		Version: "1.0.0",
		Model:   "test",
		Skin: skin.ManifestSkin{
			ID:         "test_skin",
			Name:       "Test Skin",
			FrameCount: 4,
		},
		Assets: []skin.ManifestAsset{
			{Name: "ship_frames", Type: "ship", Dir: "sprites", Variations: 4},
			{Name: "falcon", Type: "enemy", Dir: "sprites", Variations: 4},
			{Name: "laser", Type: "bullet", Dir: "sprites", Variations: 4},
			{Name: "preview", Type: "preview", Dir: "ui", Variations: 4},
		},
	}

	manifestData, _ := json.MarshalIndent(manifest, "", "  ")
	os.WriteFile(filepath.Join(skinDir, "manifest.json"), manifestData, 0644)

	// Create synthetic 8×8 JPEGs: black bg with colored center
	createTestJPEG := func(dir, name string, variations int) {
		for v := 1; v <= variations; v++ {
			img := image.NewRGBA(image.Rect(0, 0, 8, 8))
			// Black background
			for y := 0; y < 8; y++ {
				for x := 0; x < 8; x++ {
					img.Set(x, y, color.RGBA{0, 0, 0, 255})
				}
			}
			// Colored center
			img.Set(4, 4, color.RGBA{255, 0, 0, 255})

			var buf bytes.Buffer
			jpeg.Encode(&buf, img, nil)
			path := filepath.Join(dir, name+"_v"+string(rune('0'+v))+".jpg")
			os.WriteFile(path, buf.Bytes(), 0644)
		}
	}

	createTestJPEG(spritesDir, "ship_frames", 4)
	createTestJPEG(spritesDir, "explosion", 4)
	createTestJPEG(spritesDir, "falcon", 4)
	createTestJPEG(spritesDir, "laser", 4)
	createTestJPEG(uiDir, "preview", 4)

	// Run postprocess
	outDir := filepath.Join(tmpDir, "output", "test_skin")
	cfg := Config{
		SkinDir:     skinDir,
		OutputDir:   outDir,
		Variation:   1,
		TargetSize:  128,
		BgThreshold: 30,
		BgMargin:    15,
	}

	if err := Run(cfg); err != nil {
		t.Fatalf("Run() error: %v", err)
	}

	// Verify output files exist
	expectedFiles := []string{
		"sprites/vessel_0.png",    // ship_frames → animated vessel frames
		"sprites/vessel_1.png",
		"sprites/vessel_2.png",
		"sprites/vessel_3.png",
		"sprites/falcon.png",      // falcon
		"sprites/laser.png",       // laser
		"ui/preview.png",          // preview
	}

	for _, f := range expectedFiles {
		path := filepath.Join(outDir, f)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("expected file %s not found", f)
		}
	}
}

func TestListSpriteNames(t *testing.T) {
	m := &skin.Manifest{
		Assets: []skin.ManifestAsset{
			{Name: "ship_frames", Type: "ship"},
			{Name: "falcon", Type: "enemy"},
			{Name: "layer_0", Type: "background"},
			{Name: "icon_life", Type: "hud_icon"},
			{Name: "preview", Type: "preview"},
		},
	}

	names := ListSpriteNames(m)
	expected := []string{"vessel", "falcon"}
	if len(names) != len(expected) {
		t.Fatalf("got %d names, want %d: %v", len(names), len(expected), names)
	}
	for i, name := range names {
		if name != expected[i] {
			t.Errorf("names[%d]=%q, want %q", i, name, expected[i])
		}
	}
}

// A -only re-pick of one background layer must leave the other layers alone.
// The asset loop skips everything but the one asset, so nothing in it can mark
// the run incomplete — and pruneStaleBackgrounds' rule 2 then deletes every
// layer the run did not write. Seen on axelay: sixteen layers in, one out.
func TestRun_OnlyBackgroundKeepsOtherLayers(t *testing.T) {
	if _, err := exec.LookPath("cwebp"); err != nil {
		t.Skip("cwebp not installed; backgrounds cannot be encoded")
	}
	tmpDir := t.TempDir()
	skinDir := filepath.Join(tmpDir, "input", "test_skin")
	bgDir := filepath.Join(skinDir, "backgrounds")
	os.MkdirAll(bgDir, 0755)

	manifest := skin.Manifest{
		Version: "1.0.0",
		Model:   "test",
		Skin:    skin.ManifestSkin{ID: "test_skin", Name: "Test Skin", FrameCount: 4},
		Assets: []skin.ManifestAsset{
			{Name: "layer_0_z0", Type: "background", Dir: "backgrounds", Variations: 2},
			{Name: "layer_1_z0", Type: "background", Dir: "backgrounds", Variations: 2},
		},
	}
	manifestData, _ := json.MarshalIndent(manifest, "", "  ")
	os.WriteFile(filepath.Join(skinDir, "manifest.json"), manifestData, 0644)

	for _, name := range []string{"layer_0_z0", "layer_1_z0"} {
		for v := 1; v <= 2; v++ {
			img := image.NewRGBA(image.Rect(0, 0, 16, 32))
			for y := 0; y < 32; y++ {
				for x := 0; x < 16; x++ {
					img.Set(x, y, color.RGBA{uint8(40 * v), 20, 60, 255})
				}
			}
			var buf bytes.Buffer
			jpeg.Encode(&buf, img, nil)
			os.WriteFile(filepath.Join(bgDir, name+"_v"+string(rune('0'+v))+".jpg"), buf.Bytes(), 0644)
		}
	}

	outDir := filepath.Join(tmpDir, "output", "test_skin")
	cfg := Config{SkinDir: skinDir, OutputDir: outDir, Variation: 1, TargetSize: 128, BgThreshold: 30, BgMargin: 15}
	if err := Run(cfg); err != nil {
		t.Fatalf("full Run() error: %v", err)
	}
	cfg.Only = "layer_0_z0"
	cfg.Variation = 2
	if err := Run(cfg); err != nil {
		t.Fatalf("-only Run() error: %v", err)
	}

	for _, f := range []string{"layer_0_z0.webp", "layer_1_z0.webp"} {
		if _, err := os.Stat(filepath.Join(outDir, "backgrounds", f)); err != nil {
			t.Errorf("%s missing after a -only run on layer_0_z0: %v", f, err)
		}
	}
}
