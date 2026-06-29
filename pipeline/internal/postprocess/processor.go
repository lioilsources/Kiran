package postprocess

import (
	"encoding/json"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"tyrian-pipeline/internal/skin"
)

// Config controls the postprocess pipeline.
type Config struct {
	SkinDir     string // input: pipeline output/assets/skins/{id}
	OutputDir   string // output: tyrian_mobile/assets/skins/{id}
	Variation   int    // which _v{N} to pick (default 1; explosion always uses 1-4)
	TargetSize  int    // max dimension in px (default 128)
	BgThreshold int    // color distance threshold (default 30)
	BgMargin    int    // soft-edge ramp width (default 15)
}

// DefaultConfig returns a Config with sensible defaults.
func DefaultConfig() Config {
	return Config{
		Variation:   1,
		TargetSize:  128,
		BgThreshold: 30,
		BgMargin:    15,
	}
}

// Run executes the full postprocess pipeline for one skin.
func Run(cfg Config) error {
	// Read manifest. Audio-only skins (the hand-authored `default`, or any
	// `-music`/`-sfx`-only generation) have no image manifest — that's fine, we
	// skip sprite/UI/background processing and still convert SFX + music below.
	manifest, err := readManifest(cfg.SkinDir)
	hasManifest := err == nil
	if !hasManifest {
		fmt.Printf("No image manifest for %s — processing audio only (%v)\n",
			filepath.Base(cfg.SkinDir), err)
	}

	if hasManifest {
		// Create output directories
		spritesDir := filepath.Join(cfg.OutputDir, "sprites")
		uiDir := filepath.Join(cfg.OutputDir, "ui")
		bgDir := filepath.Join(cfg.OutputDir, "backgrounds")
		if err := os.MkdirAll(spritesDir, 0755); err != nil {
			return fmt.Errorf("create sprites dir: %w", err)
		}
		if err := os.MkdirAll(uiDir, 0755); err != nil {
			return fmt.Errorf("create ui dir: %w", err)
		}
		if err := os.MkdirAll(bgDir, 0755); err != nil {
			return fmt.Errorf("create bg dir: %w", err)
		}

		for _, asset := range manifest.Assets {
			switch {
			case asset.Type == "sfx":
				// SFX handled separately by processSfx(); skip here.
				continue

			case asset.Type == "music":
				// Music handled separately by processMusic(); skip here.
				continue

			case asset.Name == "explosion":
				// Special: load v1-v4 → explosion1-explosion4.png
				if err := processExplosions(cfg, asset, spritesDir); err != nil {
					return fmt.Errorf("process explosion: %w", err)
				}

			case asset.Name == "ship_frames":
				// Special: sprite sheet with N frames side-by-side → vessel_0..N-1.png
				if err := processShipFrames(cfg, asset, spritesDir, manifest.Skin.FrameCount); err != nil {
					return fmt.Errorf("process ship_frames: %w", err)
				}

			case asset.Type == "background":
				if err := processBackgrounds(cfg, asset, bgDir); err != nil {
					return fmt.Errorf("process background %s: %w", asset.Name, err)
				}

			case asset.Type == "hud_icon":
				// Copy HUD icons to ui/ subdir
				if err := processAsset(cfg, asset, uiDir); err != nil {
					return fmt.Errorf("process %s: %w", asset.Name, err)
				}

			case asset.Name == "preview":
				// Copy preview to ui/preview.png
				if err := processAsset(cfg, asset, uiDir); err != nil {
					return fmt.Errorf("process preview: %w", err)
				}

			case asset.Type == "comcenter_bg":
				// Full-screen ComCenter background — opaque, exact resize, no bg removal
				if err := processUiBg(cfg, asset, uiDir); err != nil {
					return fmt.Errorf("process %s: %w", asset.Name, err)
				}

			case asset.Type == "ui_card_bg" || asset.Type == "ui_button" || asset.Type == "ui_tab_active":
				// ComCenter panel sprites — opaque, exact resize, no bg removal
				if err := processOpaqueUiSprite(cfg, asset, uiDir); err != nil {
					return fmt.Errorf("process %s: %w", asset.Name, err)
				}

			default:
				// Standard sprite: apply name mapping
				gameName, ok := GameName(asset.Name)
				if !ok {
					continue
				}
				if err := processNamedAsset(cfg, asset, spritesDir, gameName); err != nil {
					return fmt.Errorf("process %s: %w", asset.Name, err)
				}
			}
		}
	}

	// Process SFX: convert MP3 → OGG with volume normalization
	if err := processSfx(cfg); err != nil {
		fmt.Printf("Warning: SFX processing: %v\n", err)
	}

	// Process music: convert MP3 → OGG with music-grade loudness normalization
	if err := processMusic(cfg); err != nil {
		fmt.Printf("Warning: music processing: %v\n", err)
	}

	fmt.Printf("Postprocessed skin %s → %s\n", filepath.Base(cfg.SkinDir), cfg.OutputDir)
	return nil
}

func processAsset(cfg Config, asset skin.ManifestAsset, outDir string) error {
	return processNamedAsset(cfg, asset, outDir, asset.Name)
}

func processNamedAsset(cfg Config, asset skin.ManifestAsset, outDir, gameName string) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}

	rgba := RemoveBackground(img, cfg.BgThreshold, cfg.BgMargin)
	out := normalizeSprite(rgba, gameName, cfg.TargetSize)

	outPath := filepath.Join(outDir, gameName+".png")
	return savePNG(outPath, out)
}

// normalizeSprite produces the final sprite bitmap. For game sprites with a
// canonical reference size it trims the transparent padding and fits the artwork
// into that reference box, so every skin renders at the same in-game scale.
// Assets without a reference (UI icons, previews) fall back to a plain
// max-dimension downscale.
func normalizeSprite(rgba *image.NRGBA, gameName string, targetSize int) *image.NRGBA {
	if refW, refH, ok := ReferenceSize(gameName); ok {
		return FitCanvas(Trim(rgba), refW, refH)
	}
	return Resize(rgba, targetSize)
}

func processShipFrames(cfg Config, asset skin.ManifestAsset, outDir string, frameCount int) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}

	// The source is a single square ship image; the animation frames are
	// synthesized below. Legacy multi-frame strips (wide images from the old
	// one-shot workflow) are handled by taking their first cell as the source.
	bounds := img.Bounds()
	if bounds.Dx() >= 2*bounds.Dy() {
		cells := int(math.Round(float64(bounds.Dx()) / float64(bounds.Dy())))
		cellW := bounds.Dx() / cells
		cropped := image.NewNRGBA(image.Rect(0, 0, cellW, bounds.Dy()))
		for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
			for x := bounds.Min.X; x < bounds.Min.X+cellW; x++ {
				cropped.Set(x-bounds.Min.X, y-bounds.Min.Y, img.At(x, y))
			}
		}
		img = cropped
	}

	numFrames := frameCount
	if numFrames < 1 {
		numFrames = 6
	}

	ship := RemoveBackground(img, cfg.BgThreshold, cfg.BgMargin)
	frames := SynthesizeGlowFrames(ship, numFrames, shipGlowMinGain, shipGlowMaxGain, shipGlowLumGamma)

	// Normalize all frames together so the animation keeps a steady size and
	// footprint, then write each to its own exact reference-sized canvas.
	refW, refH, ok := ReferenceSize("vessel")
	if !ok {
		refW, refH = img.Bounds().Dx(), img.Bounds().Dy()
	}
	for f, out := range FitFramesToCanvas(frames, refW, refH) {
		outPath := filepath.Join(outDir, fmt.Sprintf("vessel_%d.png", f))
		if err := savePNG(outPath, out); err != nil {
			return err
		}
	}
	return nil
}

func processExplosions(cfg Config, asset skin.ManifestAsset, outDir string) error {
	available := asset.Variations
	if available < 1 {
		available = 1
	}
	for frame := 1; frame <= 4; frame++ {
		v := ((frame - 1) % available) + 1
		srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, v)
		img, err := loadJPEG(srcPath)
		if err != nil {
			return fmt.Errorf("load explosion v%d: %w", v, err)
		}

		rgba := RemoveBackground(img, cfg.BgThreshold, cfg.BgMargin)
		out := normalizeSprite(rgba, fmt.Sprintf("explosion%d", frame), cfg.TargetSize)

		outPath := filepath.Join(outDir, fmt.Sprintf("explosion%d.png", frame))
		if err := savePNG(outPath, out); err != nil {
			return err
		}
	}
	return nil
}

// processUiBg handles the ComCenter background — opaque full-screen art, exact resize.
func processUiBg(cfg Config, asset skin.ManifestAsset, outDir string) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}
	w, h, ok := UiSize(asset.Name)
	if !ok {
		w, h = 512, 1024
	}
	out := ResizeExact(img, w, h)
	outPath := filepath.Join(outDir, asset.Name+".png")
	return savePNG(outPath, out)
}

// processOpaqueUiSprite handles ComCenter panel sprites (button, card, tab):
// opaque, exact resize to reference dimensions, no background removal.
func processOpaqueUiSprite(cfg Config, asset skin.ManifestAsset, outDir string) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}
	w, h, ok := UiSize(asset.Name)
	if !ok {
		w, h = 128, 128
	}
	out := ResizeExact(img, w, h)
	outPath := filepath.Join(outDir, asset.Name+".png")
	return savePNG(outPath, out)
}

func processBackgrounds(cfg Config, asset skin.ManifestAsset, bgDir string) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}

	resized := ResizeExact(img, 512, 1024)

	// layer_0 is opaque (no bg removal); layer_1+ get bg removal
	var out image.Image
	if asset.Name == "layer_0" {
		out = resized
	} else {
		out = RemoveBackground(resized, cfg.BgThreshold, cfg.BgMargin)
	}

	outPath := filepath.Join(bgDir, asset.Name+".png")
	return savePNG(outPath, out)
}

func variationPath(skinDir, subDir, name string, variation int) string {
	return filepath.Join(skinDir, subDir, fmt.Sprintf("%s_v%d.jpg", name, variation))
}

func loadJPEG(path string) (image.Image, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	// Try JPEG first, fall back to generic decode
	img, err := jpeg.Decode(f)
	if err != nil {
		f.Seek(0, 0)
		img, _, err = image.Decode(f)
		if err != nil {
			return nil, fmt.Errorf("decode %s: %w", path, err)
		}
	}
	return img, nil
}

func savePNG(path string, img image.Image) error {
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	return png.Encode(f, img)
}

func readManifest(skinDir string) (*skin.Manifest, error) {
	data, err := os.ReadFile(filepath.Join(skinDir, "manifest.json"))
	if err != nil {
		return nil, err
	}
	var m skin.Manifest
	if err := json.Unmarshal(data, &m); err != nil {
		return nil, err
	}
	return &m, nil
}

// ListSpriteNames returns the expected game sprite file names (without extension)
// for a given manifest, useful for verification.
func ListSpriteNames(manifest *skin.Manifest) []string {
	var names []string
	for _, a := range manifest.Assets {
		switch {
		case a.Name == "explosion":
			for i := 1; i <= 4; i++ {
				names = append(names, fmt.Sprintf("explosion%d", i))
			}
		case a.Type == "background":
			continue
		case a.Type == "hud_icon" || a.Name == "preview":
			continue
		default:
			name, ok := GameName(a.Name)
			if ok {
				names = append(names, name)
			}
		}
	}
	return names
}

// processSfx converts MP3 files in {skinDir}/sfx/ to OGG in {outputDir}/sfx/
// using ffmpeg with loudnorm volume normalization.
func processSfx(cfg Config) error {
	srcSfxDir := filepath.Join(cfg.SkinDir, "sfx")
	entries, err := os.ReadDir(srcSfxDir)
	if err != nil {
		// No sfx directory — not an error, just skip
		return nil
	}

	dstSfxDir := filepath.Join(cfg.OutputDir, "sfx")
	if err := os.MkdirAll(dstSfxDir, 0755); err != nil {
		return fmt.Errorf("create sfx output dir: %w", err)
	}

	converted := 0
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".mp3") {
			continue
		}

		baseName := strings.TrimSuffix(entry.Name(), ".mp3")
		srcPath := filepath.Join(srcSfxDir, entry.Name())
		dstPath := filepath.Join(dstSfxDir, baseName+".ogg")

		// Skip if output already exists
		if _, err := os.Stat(dstPath); err == nil {
			continue
		}

		// ffmpeg: normalize volume + convert to OGG/Opus
		cmd := exec.Command("ffmpeg", "-y",
			"-i", srcPath,
			"-af", "loudnorm=I=-14:TP=-3",
			"-c:a", "libopus",
			"-b:a", "96k",
			dstPath,
		)
		if output, err := cmd.CombinedOutput(); err != nil {
			fmt.Printf("  [sfx] ffmpeg error for %s: %v\n%s\n", baseName, err, output)
			continue
		}

		converted++
		fmt.Printf("  [sfx] %s.mp3 → %s.ogg\n", baseName, baseName)
	}

	if converted > 0 {
		fmt.Printf("  Converted %d SFX files\n", converted)
	}
	return nil
}

// processMusic converts MP3 files in {skinDir}/music/ to OGG/Opus in
// {outputDir}/music/ using ffmpeg. Music uses a gentler loudness target than
// SFX (more headroom, wider dynamic range) and a higher bitrate.
//
// NOTE: tracks are converted as-is. Seamless-loop "surgery" (crossfading the
// tail into the head) is intentionally NOT done here — the Eleven Music prompt
// already asks for loopable output, and the runtime crossfades between tiers
// mask any residual seam. Bake a proper loop point here if loop clicks appear.
func processMusic(cfg Config) error {
	srcDir := filepath.Join(cfg.SkinDir, "music")
	entries, err := os.ReadDir(srcDir)
	if err != nil {
		// No music directory — not an error, just skip
		return nil
	}

	dstDir := filepath.Join(cfg.OutputDir, "music")
	if err := os.MkdirAll(dstDir, 0755); err != nil {
		return fmt.Errorf("create music output dir: %w", err)
	}

	converted := 0
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".mp3") {
			continue
		}

		baseName := strings.TrimSuffix(entry.Name(), ".mp3")
		srcPath := filepath.Join(srcDir, entry.Name())
		dstPath := filepath.Join(dstDir, baseName+".ogg")

		// Skip if output already exists
		if _, err := os.Stat(dstPath); err == nil {
			continue
		}

		// ffmpeg: music-grade loudnorm + convert to OGG/Opus at a higher bitrate
		cmd := exec.Command("ffmpeg", "-y",
			"-i", srcPath,
			"-af", "loudnorm=I=-16:TP=-1.5:LRA=11",
			"-c:a", "libopus",
			"-b:a", "128k",
			dstPath,
		)
		if output, err := cmd.CombinedOutput(); err != nil {
			fmt.Printf("  [music] ffmpeg error for %s: %v\n%s\n", baseName, err, output)
			continue
		}

		converted++
		fmt.Printf("  [music] %s.mp3 → %s.ogg\n", baseName, baseName)
	}

	if converted > 0 {
		fmt.Printf("  Converted %d music files\n", converted)
	}
	return nil
}

// init registers jpeg decoder (imported for side effects in loadJPEG fallback)
func init() {
	_ = strings.NewReader // ensure strings import
}
