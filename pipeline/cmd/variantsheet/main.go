// Command variantsheet packs every generated variation of a skin's sprites into
// one preview sheet per skin, keyed exactly as postprocess keys them, so the
// variants can be curated side by side in a browser.
//
// Output: <out>/<skin>.webp (rows = assets, columns = variations) and
// <out>/manifest.json describing rows, variation tags and the shipped pick.
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"image"
	"image/draw"
	"image/png"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"tyrian-pipeline/internal/postprocess"
	"tyrian-pipeline/internal/skin"
)

// Sprite kinds worth curating; backgrounds and full-screen UI plates have
// their own pickers.
var kinds = map[string]bool{
	"ship": true, "bullet": true, "enemy": true,
	"boss_part": true, "structure": true, "hud_icon": true,
}

type row struct {
	Name     string   `json:"name"`
	Type     string   `json:"type"`
	Variants []string `json:"variants"`
	Shipped  string   `json:"shipped"`
}

type sheet struct {
	Cols int   `json:"cols"`
	Cell int   `json:"cell"`
	Rows []row `json:"rows"`
}

func main() {
	input := flag.String("input", "output/assets/skins", "Pipeline output dir holding <skin>/manifest.json")
	sel := flag.String("selections", "selections", "Directory of <skin>.json variation records")
	out := flag.String("out", "output/variantsheet", "Output directory")
	only := flag.String("skin", "", "Single skin (empty = all)")
	cell := flag.Int("cell", 160, "Cell size in px")
	extra := flag.String("extra", "", "Second output dir whose assets fill rows the input lacks (not shipped, so no pick is marked)")
	flag.Parse()

	if err := os.MkdirAll(*out, 0o755); err != nil {
		fail(err)
	}
	entries, err := os.ReadDir(*input)
	if err != nil {
		fail(err)
	}
	man := map[string]sheet{}
	for _, e := range entries {
		id := e.Name()
		if !e.IsDir() || strings.HasPrefix(id, ".") || (*only != "" && id != *only) {
			continue
		}
		dirs := []string{filepath.Join(*input, id)}
		if *extra != "" {
			dirs = append(dirs, filepath.Join(*extra, id))
		}
		sh, err := build(dirs, filepath.Join(*sel, id+".json"), filepath.Join(*out, id), *cell)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s: %v\n", id, err)
			continue
		}
		man[id] = sh
		fmt.Printf("%s: %d rows × %d cols\n", id, len(sh.Rows), sh.Cols)
	}
	b, _ := json.Marshal(man)
	if err := os.WriteFile(filepath.Join(*out, "manifest.json"), b, 0o644); err != nil {
		fail(err)
	}
}

// build reads dirs[0] as the shipped run; later dirs only add rows it lacks.
func build(dirs []string, selPath, outBase string, cell int) (sheet, error) {
	type asset struct {
		skin.ManifestAsset
		dir   string
		extra bool
	}
	var assets []asset
	seen := map[string]bool{}
	for i, d := range dirs {
		var m skin.Manifest
		b, err := os.ReadFile(filepath.Join(d, "manifest.json"))
		if err != nil {
			if i > 0 {
				continue
			}
			return sheet{}, err
		}
		if err := json.Unmarshal(b, &m); err != nil {
			return sheet{}, err
		}
		for _, a := range m.Assets {
			if seen[a.Name] {
				continue
			}
			seen[a.Name] = true
			assets = append(assets, asset{a, d, i > 0})
		}
	}
	shipped := map[string]int{}
	if b, err := os.ReadFile(selPath); err == nil {
		var s struct {
			Assets map[string]int `json:"assets"`
		}
		if json.Unmarshal(b, &s) == nil {
			shipped = s.Assets
		}
	}

	type src struct {
		row  row
		imgs []image.Image
	}
	var srcs []src
	cols := 0
	for _, a := range assets {
		skinDir := a.dir
		if !kinds[a.Type] {
			continue
		}
		var files []string
		matches, _ := filepath.Glob(filepath.Join(skinDir, a.Dir, a.Name+"_v*.jpg"))
		for _, f := range matches {
			var n int
			if _, err := fmt.Sscanf(strings.TrimPrefix(filepath.Base(f), a.Name+"_v"), "%d.jpg", &n); err == nil {
				files = append(files, f)
			}
		}
		sort.Slice(files, func(i, j int) bool { return variation(files[i]) < variation(files[j]) })
		if len(files) == 0 {
			continue
		}
		r := row{Name: a.Name, Type: a.Type}
		switch v := shipped[a.Name]; {
		case a.extra:
		case v > 0:
			r.Shipped = fmt.Sprintf("A%d", v)
		default:
			r.Shipped = "A1"
		}
		var imgs []image.Image
		for _, f := range files {
			fh, err := os.Open(f)
			if err != nil {
				return sheet{}, err
			}
			img, _, err := image.Decode(fh)
			fh.Close()
			if err != nil {
				return sheet{}, fmt.Errorf("%s: %w", f, err)
			}
			// Same name postprocess keys under: thresholds are tuned per game name.
			keyName := a.Name
			if g, ok := postprocess.GameName(a.Name); ok && a.Type != "ship" && a.Type != "hud_icon" {
				keyName = g
			}
			keyed := postprocess.KeySprite(img, 60, 20, keyName)
			imgs = append(imgs, postprocess.Resize(postprocess.Trim(keyed), cell-8))
			r.Variants = append(r.Variants, fmt.Sprintf("A%d", variation(f)))
		}
		if len(imgs) > cols {
			cols = len(imgs)
		}
		srcs = append(srcs, src{r, imgs})
	}
	if len(srcs) == 0 {
		return sheet{}, fmt.Errorf("no sprite variations")
	}

	canvas := image.NewNRGBA(image.Rect(0, 0, cols*cell, len(srcs)*cell))
	sh := sheet{Cols: cols, Cell: cell}
	for y, s := range srcs {
		for x, img := range s.imgs {
			bd := img.Bounds()
			ox := x*cell + (cell-bd.Dx())/2
			oy := y*cell + (cell-bd.Dy())/2
			draw.Draw(canvas, image.Rect(ox, oy, ox+bd.Dx(), oy+bd.Dy()), img, bd.Min, draw.Over)
		}
		sh.Rows = append(sh.Rows, s.row)
	}

	pngPath := outBase + ".png"
	fh, err := os.Create(pngPath)
	if err != nil {
		return sheet{}, err
	}
	if err := png.Encode(fh, canvas); err != nil {
		fh.Close()
		return sheet{}, err
	}
	fh.Close()
	cmd := exec.Command("cwebp", "-quiet", "-q", "85", "-alpha_q", "90", pngPath, "-o", outBase+".webp")
	if b, err := cmd.CombinedOutput(); err != nil {
		return sheet{}, fmt.Errorf("cwebp: %v %s", err, b)
	}
	os.Remove(pngPath)
	return sh, nil
}

func variation(path string) int {
	base := strings.TrimSuffix(filepath.Base(path), ".jpg")
	i := strings.LastIndex(base, "_v")
	var n int
	fmt.Sscanf(base[i+2:], "%d", &n)
	return n
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
