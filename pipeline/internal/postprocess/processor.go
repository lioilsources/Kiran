package postprocess

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"tyrian-pipeline/internal/skin"
)

// Config controls the postprocess pipeline.
type Config struct {
	SkinDir     string // input: pipeline output/assets/skins/{id}
	OutputDir   string // output: tyrian_mobile/assets/skins/{id}
	Variation   int    // which _v{N} to pick (default 1; explosion always uses 1-4)
	TargetSize  int    // max dimension in px (default 128)
	BgThreshold int    // color distance threshold (default 60)
	BgMargin    int    // soft-edge ramp width (default 20)
}

// DefaultConfig returns a Config with sensible defaults. The threshold/margin
// defaults are tuned for RemoveBackgroundFlood, whose border-connectivity
// guard makes a wider threshold safe for the sprite artwork.
func DefaultConfig() Config {
	return Config{
		Variation:   1,
		TargetSize:  128,
		BgThreshold: 60,
		BgMargin:    20,
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

	// Image failures must not take the audio down with them. The hand-authored
	// `default` skin has a manifest but no generated sprite sources, so this
	// block always errors for it — and used to return before processSfx ever
	// ran, which is why that skin's sound was never reprocessed. Record the
	// error, finish the audio, report at the end.
	var imgErr error
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
		if _, err := exec.LookPath("cwebp"); err != nil {
			return fmt.Errorf("cwebp not found in PATH (brew install webp): %w", err)
		}

		// Background base names written this run, used to prune superseded files.
		// bgComplete stays true only if every background in the manifest landed;
		// a partial run must not prune the fallback art it failed to replace.
		bgWritten := map[string]bool{}
		bgComplete := true

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
					imgErr = fmt.Errorf("process explosion: %w", err)
					continue
				}

			case asset.Name == "ship_frames":
				// Special: sprite sheet with N frames side-by-side → vessel_0..N-1.png
				if err := processShipFrames(cfg, asset, spritesDir, manifest.Skin.FrameCount); err != nil {
					imgErr = fmt.Errorf("process ship_frames: %w", err)
					continue
				}

			case asset.Type == "background":
				// A skin whose zone art has not been generated yet is the normal
				// case, not an error: the manifest lists every zone for every
				// skin, but only some skins have the source images. Missing
				// sources are skipped so the rest of the skin still processes,
				// and the game falls back to that skin's flat layer_N files.
				switch err := processBackgrounds(cfg, asset, bgDir); {
				case err == nil:
					bgWritten[asset.Name] = true
				case errors.Is(err, os.ErrNotExist):
					fmt.Printf("  [bg] no source for %s — skipping\n", asset.Name)
					bgComplete = false
				default:
					imgErr = fmt.Errorf("process background %s: %w", asset.Name, err)
					continue
				}

			case asset.Type == "hud_icon":
				// Copy HUD icons to ui/ subdir
				if err := processAsset(cfg, asset, uiDir); err != nil {
					imgErr = fmt.Errorf("process %s: %w", asset.Name, err)
					continue
				}

			case asset.Name == "preview":
				// Copy preview to ui/preview.png
				if err := processAsset(cfg, asset, uiDir); err != nil {
					imgErr = fmt.Errorf("process preview: %w", err)
					continue
				}

			case asset.Type == "comcenter_bg":
				// Full-screen ComCenter background — opaque, exact resize, no bg removal
				if err := processUiBg(cfg, asset, uiDir); err != nil {
					imgErr = fmt.Errorf("process %s: %w", asset.Name, err)
					continue
				}

			case asset.Type == "ui_card_bg" || asset.Type == "ui_button" || asset.Type == "ui_tab_active":
				// ComCenter panel sprites — opaque, exact resize, no bg removal
				if err := processOpaqueUiSprite(cfg, asset, uiDir); err != nil {
					imgErr = fmt.Errorf("process %s: %w", asset.Name, err)
					continue
				}

			default:
				// Standard sprite: apply name mapping
				gameName, ok := GameName(asset.Name)
				if !ok {
					continue
				}
				if err := processNamedAsset(cfg, asset, spritesDir, gameName); err != nil {
					imgErr = fmt.Errorf("process %s: %w", asset.Name, err)
					continue
				}
			}
		}

		if len(bgWritten) > 0 {
			if !bgComplete {
				fmt.Printf("  [bg] incomplete set — keeping fallback art\n")
			}
			if err := pruneStaleBackgrounds(bgDir, bgWritten, bgComplete); err != nil {
				fmt.Printf("  [bg] prune failed: %v\n", err)
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
	return imgErr
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

	rgba := RemoveBackgroundFlood(img, cfg.BgThreshold, cfg.BgMargin)
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

	ship := RemoveBackgroundFlood(img, cfg.BgThreshold, cfg.BgMargin)
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

		rgba := RemoveBackgroundFlood(img, cfg.BgThreshold, cfg.BgMargin)
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

// Luminance cut-offs for parallax overlay alpha. black sits just above the JPEG
// noise floor so flat black stays flat; white is deliberately low so the dim
// mid-tones of a gas bank still carry visible alpha rather than vanishing.
const (
	bgAlphaBlack = 8
	bgAlphaWhite = 70
)

func processBackgrounds(cfg Config, asset skin.ManifestAsset, bgDir string) error {
	srcPath := variationPath(cfg.SkinDir, asset.Dir, asset.Name, cfg.Variation)
	img, err := loadJPEG(srcPath)
	if err != nil {
		return fmt.Errorf("load %s: %w", srcPath, err)
	}

	resized := ResizeExact(img, 512, 1024)

	// layer_0 is the opaque base plate; layer_1+ are luminous overlays drawn on
	// black and composited over it. The decision rides on the parsed layer
	// index, not the literal name, because zone variants are named layer_0_z3 —
	// testing asset.Name == "layer_0" would key every zone's base plate and let
	// the starfield bleed through the sky.
	//
	// Overlays get AlphaFromLuminance rather than either chroma key. A key asks
	// a yes/no question and so deletes the soft falloff that ought to read as
	// translucent; on real art it left these layers 97% transparent. Luminance
	// keying turns that same falloff into proportional alpha.
	layerIdx, _, ok := parseLayerName(asset.Name)
	opaque := ok && layerIdx == 0
	var out image.Image
	if opaque {
		out = resized
	} else {
		out = AlphaFromLuminance(resized, bgAlphaBlack, bgAlphaWhite)
	}

	outPath := filepath.Join(bgDir, asset.Name+".webp")
	return saveWebP(outPath, out, opaque)
}

// parseLayerName splits a background asset name into its parallax layer index
// and its optional zone index: "layer_0" -> (0, -1, true), "layer_1_z3" ->
// (1, 3, true), anything else -> ok=false.
//
// The layer index alone decides opacity: layer 0 is always the opaque base
// plate, every other layer is chroma-keyed. A prefix match would be subtly
// wrong here — it would also accept "layer_01".
func parseLayerName(name string) (layer, zone int, ok bool) {
	rest, found := strings.CutPrefix(name, "layer_")
	if !found {
		return 0, 0, false
	}
	zone = -1
	if i := strings.Index(rest, "_z"); i >= 0 {
		z, err := strconv.Atoi(rest[i+2:])
		if err != nil {
			return 0, 0, false
		}
		zone, rest = z, rest[:i]
	}
	l, err := strconv.Atoi(rest)
	if err != nil {
		return 0, 0, false
	}
	return l, zone, true
}

// saveWebP encodes img to path as lossy WebP via the cwebp binary.
//
// Backgrounds are the bulk of the asset bundle and WebP buys roughly an order
// of magnitude over Go's default png.Encode, which is what makes per-zone art
// affordable. Opaque base plates encode with no alpha plane at all; every other
// layer keeps a near-lossless alpha channel, because the chroma-keyed edges are
// what sell the parallax depth and lossy alpha shows up as halos around stars.
//
// The image is piped in as PNG and the WebP comes back on stdout, so no
// temporary files are involved. Note the argument order: -o must come before
// the "--" separator, otherwise cwebp reads "-o" and "-" as further input files
// and silently produces nothing.
func saveWebP(path string, img image.Image, opaque bool) error {
	var src bytes.Buffer
	if err := png.Encode(&src, img); err != nil {
		return fmt.Errorf("encode png for %s: %w", path, err)
	}

	args := []string{"-q", "82", "-m", "6", "-metadata", "none"}
	if opaque {
		args = append(args, "-noalpha")
	} else {
		args = append(args, "-alpha_q", "90", "-alpha_filter", "best")
	}
	args = append(args, "-o", "-", "--", "-")

	cmd := exec.Command("cwebp", args...)
	cmd.Stdin = &src
	var out, stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("cwebp %s: %w\n%s", path, err, stderr.String())
	}
	return os.WriteFile(path, out.Bytes(), 0644)
}

// pruneStaleBackgrounds removes background files this run superseded, so a
// migrated skin never ships both the PNG and the WebP. The pubspec entry for
// backgrounds/ globs the whole directory, so a leftover PNG set would silently
// double the bundle cost of the per-zone art while the game looked perfect.
//
// Two conservative rules:
//  1. delete layer_X.png whenever layer_X.webp was written this run — always
//     safe, the replacement is right there under the same name;
//  2. delete any other layer_* file not written this run, but only when the run
//     produced a *complete* zone set (complete=true) — i.e. nothing was skipped
//     for a missing source.
//
// Rule 2 hangs on completeness rather than on "wrote at least one zone file"
// because a half-finished generation run (an image backend dying mid-way) would
// otherwise delete the flat art the game still falls back on for every zone the
// run never reached, leaving those zones with no base plate at all.
func pruneStaleBackgrounds(bgDir string, written map[string]bool, complete bool) error {
	entries, err := os.ReadDir(bgDir)
	if err != nil {
		return err
	}
	for _, e := range entries {
		if e.IsDir() || !strings.HasPrefix(e.Name(), "layer_") {
			continue // leaves .gitkeep and anything hand-added alone
		}
		base := strings.TrimSuffix(e.Name(), filepath.Ext(e.Name()))
		stale := (strings.HasSuffix(e.Name(), ".png") && written[base]) ||
			(complete && !written[base])
		if !stale {
			continue
		}
		if err := os.Remove(filepath.Join(bgDir, e.Name())); err != nil {
			return err
		}
		fmt.Printf("  [bg] pruned stale %s\n", e.Name())
	}
	return nil
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

// Loudness targets for SFX, measured over the band a phone speaker can actually
// reproduce rather than full range.
//
// loudnorm was the obvious tool and the wrong one. It measures integrated
// loudness with K-weighting, which de-emphasises bass — so a sub-heavy file
// reads as quiet and gets turned *up*, pushing yet more energy into a band the
// hardware cannot render. Measured on the shipped set, that left the laser shot
// 13dB above the big explosion in the only band that reaches the player's ears,
// which is exactly how it sounded: shots everywhere, explosions with no weight.
//
// Measuring above sfxAudibleFloorHz instead makes the comparison the one the
// player experiences. The gain clamp keeps a file that simply has nothing up
// there from being dragged up by 50dB of pure noise floor.
const (
	sfxAudibleFloorHz = 500 // below this a phone speaker gives up
	sfxSubCutHz       = 60  // inaudible on the target device; only eats headroom
	// How far the audible-band peak may sit below the file's overall peak before
	// the content counts as unreachable on a phone. Absolute level says nothing
	// here — loudnorm sets that — so the diagnostic has to be a ratio.
	sfxWeakRatioDb = -12.0
)

// audibleShortfall reports how far a file's peak within the phone-reproducible
// band sits below its overall peak. Near 0 means the energy is where it can be
// heard; a large negative means the sound lives in bass the device cannot
// render, which no amount of levelling can recover.
//
// Peak, not mean. These are short one-shots with a fast transient and a long
// quiet tail, so a mean taken over the whole file mostly measures the silence:
// rtype's hull hit reads -29dB mean against a -6.6dB peak, and levelling on the
// mean asked for +34dB of gain on a file that was already loud enough. Peak is
// insensitive to how much of the clip is empty, which is what makes it the
// right statistic here.
func audibleShortfall(path string) (float64, error) {
	peak := func(filter string) (float64, error) {
		cmd := exec.Command("ffmpeg", "-hide_banner", "-i", path,
			"-af", filter, "-f", "null", "-")
		out, err := cmd.CombinedOutput()
		if err != nil {
			return 0, fmt.Errorf("volumedetect: %w", err)
		}
		m := regexp.MustCompile(`max_volume:\s*(-?[0-9.]+) dB`).FindSubmatch(out)
		if m == nil {
			return 0, fmt.Errorf("no max_volume in ffmpeg output")
		}
		return strconv.ParseFloat(string(m[1]), 64)
	}

	full, err := peak("volumedetect")
	if err != nil {
		return 0, err
	}
	audible, err := peak(fmt.Sprintf("highpass=f=%d,volumedetect", sfxAudibleFloorHz))
	if err != nil {
		return 0, err
	}
	return audible - full, nil
}

// processSfx converts MP3 files in {skinDir}/sfx/ to OGG in {outputDir}/sfx/,
// levelled on the phone-audible band (see audibleBandGain).
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

		// Diagnostic only. A file with nothing up here cannot be rescued by
		// levelling — no gain reaches content that was never generated — so the
		// fix is to regenerate it, and the point of measuring is to say which.
		if d, err := audibleShortfall(srcPath); err == nil && d < sfxWeakRatioDb {
			fmt.Printf("  [sfx] %s is %.1f dB down above %dHz — its energy sits "+
				"in bass a phone cannot render, regenerate it\n",
				baseName, d, sfxAudibleFloorHz)
		}

		// Drop the inaudible sub before normalising. That part is unambiguous:
		// on the target device it is silent, and all it does here is consume
		// headroom and drag loudnorm's K-weighted measurement around. The
		// levelling itself stays with loudnorm — a hand-rolled peak normaliser
		// measured no better than it and is a worse tool.
		filter := fmt.Sprintf("highpass=f=%d,loudnorm=I=-14:TP=-3", sfxSubCutHz)
		cmd := exec.Command("ffmpeg", "-y",
			"-i", srcPath,
			"-af", filter,
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
