// Command bossart turns a picked boss creature and its Kontext idle frames
// (cmd/animate) into the game sprites rododendron, rododendron_blink,
// rododendron_twitch_l and rododendron_twitch_r for one skin.
//
// The frames are keyed one by one, then cropped to the union of their opaque
// areas and fitted to the boss reference box with one shared crop. Per-frame
// trimming would re-centre each frame and erase the twitch, which is the whole
// movement; a shared crop keeps it.
//
//	go run ./cmd/bossart -skin default \
//	    -anim output/creatures_a/anim/default_kraken_v2 \
//	    -out ../tyrian_mobile/assets/skins/default/sprites
package main

import (
	"flag"
	"fmt"
	"image"
	"image/color"
	"image/draw"
	_ "image/jpeg"
	"image/png"
	"math"
	"os"
	"path/filepath"

	"tyrian-pipeline/internal/postprocess"
)

// animFrames maps an animate output file to the sprite it becomes. flare is
// left out: Kontext does not flare reliably (a beholder grew wings).
var animFrames = []struct{ file, sprite string }{
	{"blink_1.png", "rododendron_blink"},
	{"twitch_l_1.png", "rododendron_twitch_l"},
	{"twitch_r_1.png", "rododendron_twitch_r"},
}

func main() {
	skinID := flag.String("skin", "", "skin id (for messages)")
	anim := flag.String("anim", "", "directory written by cmd/animate (optional)")
	out := flag.String("out", "", "skin sprites directory")
	pick := flag.Int("variant", 1, "which blink_N/twitch_*_N edit to use")
	flag.Parse()
	if *anim == "" || *out == "" {
		fmt.Fprintln(os.Stderr, "usage: bossart -skin id -anim dir -out spritesdir")
		os.Exit(2)
	}

	fmt.Println("boss art for skin", *skinID)
	type frame struct {
		name string
		img  *image.NRGBA
	}
	var frames []frame
	add := func(name, path string) {
		im, err := load(path)
		if err != nil {
			fmt.Fprintln(os.Stderr, "load:", err)
			os.Exit(1)
		}
		frames = append(frames, frame{name, keyMagenta(im)})
	}
	{
		add("rododendron", filepath.Join(*anim, replaceVariant("open_1.png", *pick)))
		for _, f := range animFrames {
			p := filepath.Join(*anim, replaceVariant(f.file, *pick))
			if _, err := os.Stat(p); err != nil {
				fmt.Fprintf(os.Stderr, "skip %s: %v\n", f.sprite, err)
				continue
			}
			add(f.sprite, p)
		}
	}

	box := image.Rectangle{}
	for _, f := range frames {
		box = box.Union(opaqueBounds(f.img))
	}
	refW, refH, ok := postprocess.ReferenceSize("rododendron")
	if !ok {
		fmt.Fprintln(os.Stderr, "no reference size for rododendron")
		os.Exit(1)
	}
	for _, f := range frames {
		crop := image.NewNRGBA(image.Rect(0, 0, box.Dx(), box.Dy()))
		draw.Draw(crop, crop.Bounds(), f.img, box.Min, draw.Src)
		sprite := postprocess.FitCanvas(crop, refW, refH)
		dst := filepath.Join(*out, f.name+".png")
		fh, err := os.Create(dst)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		err = png.Encode(fh, sprite)
		fh.Close()
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		fmt.Println("wrote", dst)
	}
}

// keyMagenta removes the flat magenta background cmd/animate paints. Kontext
// returns it noisy, tinted darker and with a soft drop shadow, so the key is
// chroma, not distance to #FF00FF: m = min(R,B) - G is large for any magenta
// and negative for the teal, navy, black and red bodies these creatures have.
// Alpha ramps from opaque at m <= 35 to clear at m >= 75, and the magenta
// spill is taken out of the partly covered edge pixels.
func keyMagenta(im *image.NRGBA) *image.NRGBA {
	const lo, hi = 35.0, 75.0
	out := image.NewNRGBA(im.Bounds())
	for y := im.Bounds().Min.Y; y < im.Bounds().Max.Y; y++ {
		for x := im.Bounds().Min.X; x < im.Bounds().Max.X; x++ {
			c := im.NRGBAAt(x, y)
			m := float64(min(c.R, c.B)) - float64(c.G)
			a := 1 - math.Min(1, math.Max(0, (m-lo)/(hi-lo)))
			if a == 0 {
				continue
			}
			r, b := float64(c.R), float64(c.B)
			if m > 0 {
				r, b = r-m, b-m // despill
			}
			out.SetNRGBA(x, y, color.NRGBA{uint8(math.Max(0, r)), c.G, uint8(math.Max(0, b)), uint8(a * 255)})
		}
	}
	return out
}

func replaceVariant(file string, n int) string {
	return file[:len(file)-len("1.png")] + fmt.Sprint(n) + ".png"
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
				if x < r.Min.X {
					r.Min.X = x
				}
				if y < r.Min.Y {
					r.Min.Y = y
				}
				if x+1 > r.Max.X {
					r.Max.X = x + 1
				}
				if y+1 > r.Max.Y {
					r.Max.Y = y + 1
				}
			}
		}
	}
	if r.Empty() {
		return b
	}
	return r
}
