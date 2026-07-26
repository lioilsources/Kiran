// Command fixbg repairs already-published skin sprites that still carry a
// baked-in background (the global chroma key in postprocess failed on noisy or
// sprite-colored backgrounds). It detects affected PNGs by their opaque border,
// strips the background with flood-fill removal, re-normalizes the artwork to
// the canonical reference size, and overwrites the file in place.
//
// Usage:
//
//	go run ./cmd/fixbg -skins asteroids,blazing_lazers -assets ../tyrian_mobile/assets/skins
//
// Rebuild the texture atlases afterwards (dart run tool/pack_atlas.dart) —
// the game renders from atlas.png, not the individual sprites.
package main

import (
	"flag"
	"fmt"
	"image"
	"image/png"
	"os"
	"path/filepath"
	"strings"

	"tyrian-pipeline/internal/postprocess"
)

func main() {
	skins := flag.String("skins", "", "comma-separated skin ids to repair (required)")
	assets := flag.String("assets", "../tyrian_mobile/assets/skins", "path to the game's skins directory")
	threshold := flag.Int("threshold", 60, "color distance threshold for background match")
	margin := flag.Int("margin", 20, "soft-edge ramp width beyond threshold")
	detect := flag.Float64("detect", 0.45, "border opaque fraction above which a sprite counts as baked")
	minSize := flag.Int("min-size", 64, "skip sprites smaller than this (tiny sprites touch borders by design)")
	files := flag.String("files", "", "comma-separated file names to process (default: every detected sprite); use with -threshold for per-file overrides, e.g. background shadows")
	dry := flag.Bool("dry", false, "report what would change without writing")
	flag.Parse()

	only := map[string]bool{}
	for _, f := range strings.Split(*files, ",") {
		if f = strings.TrimSpace(f); f != "" {
			only[f] = true
		}
	}

	if *skins == "" {
		fmt.Fprintln(os.Stderr, "error: -skins is required")
		flag.Usage()
		os.Exit(2)
	}

	fixed, skipped := 0, 0
	for _, skin := range strings.Split(*skins, ",") {
		skin = strings.TrimSpace(skin)
		dir := filepath.Join(*assets, skin, "sprites")
		entries, err := os.ReadDir(dir)
		if err != nil {
			fmt.Fprintf(os.Stderr, "error: read %s: %v\n", dir, err)
			os.Exit(1)
		}
		fmt.Printf("[%s]\n", skin)
		for _, e := range entries {
			if e.IsDir() || !strings.HasSuffix(strings.ToLower(e.Name()), ".png") {
				continue
			}
			if len(only) > 0 && !only[e.Name()] {
				continue
			}
			path := filepath.Join(dir, e.Name())
			img, err := loadPNG(path)
			if err != nil {
				fmt.Fprintf(os.Stderr, "error: load %s: %v\n", path, err)
				os.Exit(1)
			}

			b := img.Bounds()
			if b.Dx() < *minSize || b.Dy() < *minSize {
				skipped++
				continue
			}
			// Check the border plus a slightly inset ring — an earlier chroma
			// key may have cleared only a thin outer rim of a baked background.
			frac := postprocess.BorderOpaqueFraction(img)
			if inner := postprocess.RingOpaqueFraction(img, 0.04); inner > frac {
				frac = inner
			}
			if frac < *detect {
				skipped++
				continue
			}

			name := strings.TrimSuffix(e.Name(), ".png")
			fmt.Printf("  %-16s border %3.0f%% opaque → flood bg removal", e.Name(), frac*100)

			out := postprocess.RemoveBackgroundFlood(img, *threshold, *margin)
			if refW, refH, ok := postprocess.ReferenceSize(name); ok {
				out = postprocess.FitCanvas(postprocess.Trim(out), refW, refH)
				fmt.Printf(" + fit %dx%d", refW, refH)
			}
			fmt.Println()

			if !*dry {
				if err := writePNG(path, out); err != nil {
					fmt.Fprintf(os.Stderr, "error: write %s: %v\n", path, err)
					os.Exit(1)
				}
			}
			fixed++
		}
	}
	fmt.Printf("\n%d sprites repaired, %d clean/skipped", fixed, skipped)
	if *dry {
		fmt.Print(" (dry run — nothing written)")
	}
	fmt.Println()
}

func loadPNG(path string) (image.Image, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return png.Decode(f)
}

func writePNG(path string, img image.Image) error {
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	return png.Encode(f, img)
}
