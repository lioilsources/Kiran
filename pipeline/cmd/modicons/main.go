// Command modicons packs one skin's picked mod icons into the sheet the
// hangar draws from: ui/mod_icons.webp plus ui/mod_icons.json.
//
// The source directory holds one render per mod, named after ModSpec.id
// (double.png, rate_plus.jpg, ...), on a flat magenta background. Each icon
// is keyed, trimmed to what survived the key, fitted into a square cell and
// laid out on a grid; the JSON maps every id to its cell index.
//
//	go run ./cmd/modicons -skin default \
//	    -src output/modicons/default/picked \
//	    -out ../tyrian_mobile/assets/skins/default/ui
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"image"
	"image/draw"
	_ "image/jpeg"
	"image/png"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"tyrian-pipeline/internal/postprocess"
)

func main() {
	skinID := flag.String("skin", "", "skin id (for messages)")
	src := flag.String("src", "", "directory with one <mod id>.png|jpg per mod")
	out := flag.String("out", "", "the skin's ui/ directory")
	cell := flag.Int("cell", 128, "cell size in pixels")
	cols := flag.Int("cols", 8, "cells per row")
	pad := flag.Int("pad", 6, "transparent margin inside each cell")
	keyMode := flag.String("key", "flood", "background key: flood (KeySprite, like the variant sheets) or none")
	flag.Parse()
	if *src == "" || *out == "" {
		fmt.Fprintln(os.Stderr, "usage: modicons -skin <id> -src <dir> -out <skin ui dir>")
		os.Exit(2)
	}

	entries, err := os.ReadDir(*src)
	if err != nil {
		fail(err)
	}
	var ids []string
	files := map[string]string{}
	for _, e := range entries {
		ext := strings.ToLower(filepath.Ext(e.Name()))
		if e.IsDir() || (ext != ".png" && ext != ".jpg" && ext != ".jpeg") {
			continue
		}
		id := strings.TrimSuffix(e.Name(), filepath.Ext(e.Name()))
		if _, dup := files[id]; dup {
			fail(fmt.Errorf("two sources for %q", id))
		}
		files[id] = filepath.Join(*src, e.Name())
		ids = append(ids, id)
	}
	if len(ids) == 0 {
		fail(fmt.Errorf("no icons in %s", *src))
	}
	sort.Strings(ids)

	rows := int(math.Ceil(float64(len(ids)) / float64(*cols)))
	sheet := image.NewNRGBA(image.Rect(0, 0, *cols**cell, rows**cell))
	index := map[string]int{}
	for i, id := range ids {
		im, err := load(files[id])
		if err != nil {
			fail(err)
		}
		if *keyMode == "flood" {
			im = postprocess.KeySprite(im, 60, 20, "mod_"+id)
		}
		if b := opaqueBounds(im); b != im.Bounds() {
			crop := image.NewNRGBA(image.Rect(0, 0, b.Dx(), b.Dy()))
			draw.Draw(crop, crop.Bounds(), im, b.Min, draw.Src)
			im = crop
		}
		inner := *cell - 2**pad
		icon := postprocess.FitCanvas(im, inner, inner)
		x, y := (i%*cols)**cell+*pad, (i / *cols)**cell+*pad
		draw.Draw(sheet, image.Rect(x, y, x+inner, y+inner), icon, icon.Bounds().Min, draw.Over)
		index[id] = i
	}

	if err := os.MkdirAll(*out, 0o755); err != nil {
		fail(err)
	}
	pngPath := filepath.Join(*out, "mod_icons.png")
	if err := writePNG(pngPath, sheet); err != nil {
		fail(err)
	}
	webpPath := filepath.Join(*out, "mod_icons.webp")
	// Same encoder the atlas uses; exact alpha keeps the keyed edges clean.
	cmd := exec.Command("cwebp", "-quiet", "-q", "90", "-alpha_q", "100", "-exact", pngPath, "-o", webpPath)
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fail(fmt.Errorf("cwebp: %w", err))
	}
	os.Remove(pngPath)

	meta, _ := json.MarshalIndent(map[string]any{"cell": *cell, "cols": *cols, "icons": index}, "", "  ")
	if err := os.WriteFile(filepath.Join(*out, "mod_icons.json"), append(meta, '\n'), 0o644); err != nil {
		fail(err)
	}
	fmt.Printf("[%s] %d icons → %s (%dx%d)\n", *skinID, len(ids), webpPath, sheet.Bounds().Dx(), sheet.Bounds().Dy())
}

func load(path string) (*image.NRGBA, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	im, _, err := image.Decode(f)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", path, err)
	}
	n := image.NewNRGBA(im.Bounds())
	draw.Draw(n, n.Bounds(), im, im.Bounds().Min, draw.Src)
	return n, nil
}

// opaqueBounds is the bounding box of pixels that survived the key.
func opaqueBounds(im *image.NRGBA) image.Rectangle {
	b := im.Bounds()
	r := image.Rectangle{Min: b.Max, Max: b.Min}
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			if im.NRGBAAt(x, y).A > 16 {
				r = r.Union(image.Rect(x, y, x+1, y+1))
			}
		}
	}
	if r.Empty() {
		return b
	}
	return r
}

func writePNG(path string, im image.Image) error {
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	return png.Encode(f, im)
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "modicons:", err)
	os.Exit(1)
}
