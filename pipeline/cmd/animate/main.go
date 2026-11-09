// Command animate turns one picked boss creature into an idle-animation set by
// asking Flux Kontext to edit the picked image: the eyes shut, the body jerks
// to either side, the limbs flare. Kontext keeps the design, so the frames
// differ only in the edited part and the game can cycle them like a flip-book.
//
//	COMFYUI_API_URL=http://127.0.0.1:18188 go run ./cmd/animate \
//	    -src output/creatures_a/skins/default/sprites/creature_dragon_v2.jpg \
//	    -out output/creatures_a/anim/default_dragon -variants 2
//
// Writes <out>/source.png (the source, re-encoded) and, on a magenta
// background, open_N.png, blink_N.png, twitch_l_N.png, twitch_r_N.png and
// flare_N.png, N = 1..variants (re-roll duds by picking another N).
package main

import (
	"bytes"
	"context"
	"flag"
	"fmt"
	"image"
	_ "image/jpeg"
	"image/png"
	"os"
	"path/filepath"
	"sync"

	"tyrian-pipeline/internal/comfyuiimage"
)

// keep pins everything the edit must not touch and swaps the background for
// pure magenta in the same pass: the generator's dark vignette backgrounds sit
// too close to the dark bodies to key, magenta keys cleanly (cmd/bossart).
const keep = " Keep the creature's design, colours, markings, size and framing exactly identical; change nothing else. Replace the whole background with one flat solid pure magenta (#FF00FF) colour: no gradient, no vignette, no glow or shadow in the background."

var frames = []struct{ name, instruction string }{
	{"open", "Keep the creature exactly as it is, eyes open." + keep},
	{"blink", "Close every eye of the creature: the eyelids are shut, each eye becomes a thin closed slit with no glowing iris visible." + keep},
	{"twitch_l", "Make the creature jerk to one side: its head and neck snap a few degrees to the left of the image, the body shifts slightly left, wings, tentacles or necks are drawn mid-spasm, with the eyes still open." + keep},
	{"twitch_r", "Make the creature jerk to one side: its head and neck snap a few degrees to the right of the image, the body shifts slightly right, wings, tentacles or necks are drawn mid-spasm, with the eyes still open." + keep},
	{"flare", "Make the creature flare up: wings, tentacles, necks or eye stalks spread slightly wider and the glowing veins burn brighter, eyes wide open." + keep},
}

func main() {
	src := flag.String("src", "", "picked creature image (jpg/png)")
	out := flag.String("out", "", "output directory for the frames")
	variants := flag.Int("variants", 2, "edits per frame kind")
	workers := flag.Int("workers", 3, "concurrent edit jobs")
	flag.Parse()
	url := os.Getenv("COMFYUI_API_URL")
	if *src == "" || *out == "" || url == "" {
		fmt.Fprintln(os.Stderr, "usage: COMFYUI_API_URL=... animate -src img -out dir [-variants N]")
		os.Exit(2)
	}

	png0, err := toPNG(*src)
	if err != nil {
		fmt.Fprintln(os.Stderr, "read source:", err)
		os.Exit(1)
	}
	if err := os.MkdirAll(*out, 0o755); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	if err := os.WriteFile(filepath.Join(*out, "source.png"), png0, 0o644); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	c := comfyuiimage.NewClient(url, os.Getenv("CF_ACCESS_CLIENT_ID"), os.Getenv("CF_ACCESS_CLIENT_SECRET"))
	sem := make(chan struct{}, *workers)
	var wg sync.WaitGroup
	var mu sync.Mutex
	failed := 0
	for _, f := range frames {
		for n := 1; n <= *variants; n++ {
			name := fmt.Sprintf("%s_%d.png", f.name, n)
			dst := filepath.Join(*out, name)
			if _, err := os.Stat(dst); err == nil {
				continue
			}
			wg.Add(1)
			sem <- struct{}{}
			go func() {
				defer wg.Done()
				defer func() { <-sem }()
				b, err := c.Edit(context.Background(), png0, f.instruction, "anim_"+f.name, 0)
				if err == nil {
					err = os.WriteFile(dst, b, 0o644)
				}
				mu.Lock()
				defer mu.Unlock()
				if err != nil {
					failed++
					fmt.Printf("FAIL %s: %v\n", name, err)
					return
				}
				fmt.Println("OK  ", name)
			}()
		}
	}
	wg.Wait()
	fmt.Printf("Failed: %d\n", failed)
	if failed > 0 {
		os.Exit(1)
	}
}

func toPNG(path string) ([]byte, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	img, _, err := image.Decode(f)
	if err != nil {
		return nil, err
	}
	var buf bytes.Buffer
	if err := png.Encode(&buf, img); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
