package postprocess

import (
	"image"
	"image/color"
	"testing"
)

// makeSprite builds a w×h opaque NRGBA image filled by fill(x, y).
func makeSprite(w, h int, fill func(x, y int) color.NRGBA) *image.NRGBA {
	img := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			img.SetNRGBA(x, y, fill(x, y))
		}
	}
	return img
}

func alphaAt(img *image.NRGBA, x, y int) uint8 {
	return img.NRGBAAt(x, y).A
}

func TestFloodRemovesSolidBackground(t *testing.T) {
	blue := color.NRGBA{0, 48, 248, 255}
	red := color.NRGBA{200, 30, 30, 255}
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 10 && x < 22 && y >= 10 && y < 22 {
			return red
		}
		return blue
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 0, 0); a != 0 {
		t.Errorf("corner background alpha = %d, want 0", a)
	}
	if a := alphaAt(out, 16, 16); a != 255 {
		t.Errorf("sprite center alpha = %d, want 255", a)
	}
}

func TestFloodRemovesNoisyBackground(t *testing.T) {
	// Speckled background: two blues further apart than the old chroma-key
	// threshold could handle relative to a 4-corner average.
	blueA := color.NRGBA{0, 40, 248, 255}
	blueB := color.NRGBA{40, 90, 200, 255}
	white := color.NRGBA{255, 255, 255, 255}
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 12 && x < 20 && y >= 12 && y < 20 {
			return white
		}
		if (x+y)%2 == 0 {
			return blueA
		}
		return blueB
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	for _, p := range [][2]int{{0, 0}, {1, 0}, {31, 31}, {5, 20}} {
		if a := alphaAt(out, p[0], p[1]); a != 0 {
			t.Errorf("noisy background pixel (%d,%d) alpha = %d, want 0", p[0], p[1], a)
		}
	}
	if a := alphaAt(out, 16, 16); a != 255 {
		t.Errorf("sprite center alpha = %d, want 255", a)
	}
}

func TestFloodProtectsInteriorMatchingBackground(t *testing.T) {
	// A background-colored detail fully enclosed by sprite pixels, but further
	// than threshold/2 from the background, must survive (connectivity guard).
	bg := color.NRGBA{0, 48, 248, 255}
	nearBg := color.NRGBA{60, 90, 248, 255} // dist ~73 from bg > 60, > strict 30
	gray := color.NRGBA{120, 120, 120, 255}
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 14 && x < 18 && y >= 14 && y < 18 {
			return nearBg
		}
		if x >= 8 && x < 24 && y >= 8 && y < 24 {
			return gray
		}
		return bg
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 16, 16); a != 255 {
		t.Errorf("enclosed near-background detail alpha = %d, want 255 (protected)", a)
	}
	if a := alphaAt(out, 0, 0); a != 0 {
		t.Errorf("background alpha = %d, want 0", a)
	}
}

func TestFloodClearsEnclosedBackgroundPockets(t *testing.T) {
	// A pocket of exact background color enclosed by the sprite is cleared by
	// the strict second pass, matching chroma-key behaviour on healthy skins.
	bg := color.NRGBA{0, 48, 248, 255}
	gray := color.NRGBA{120, 120, 120, 255}
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 14 && x < 18 && y >= 14 && y < 18 {
			return bg // enclosed pocket, identical to background
		}
		if x >= 8 && x < 24 && y >= 8 && y < 24 {
			return gray
		}
		return bg
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 16, 16); a != 0 {
		t.Errorf("enclosed background pocket alpha = %d, want 0", a)
	}
	if a := alphaAt(out, 10, 10); a != 255 {
		t.Errorf("sprite body alpha = %d, want 255", a)
	}
}

func TestFloodKeepsSpriteTouchingBorder(t *testing.T) {
	// An engine flame reaching the bottom edge occupies a small share of the
	// border; its colors must not enter the background model.
	bg := color.NRGBA{0, 48, 248, 255}
	flame := color.NRGBA{255, 200, 40, 255}
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 14 && x < 18 && y >= 20 {
			return flame // touches bottom border, 4 of 124 border pixels
		}
		return bg
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 15, 31); a != 255 {
		t.Errorf("flame pixel on border alpha = %d, want 255", a)
	}
	if a := alphaAt(out, 0, 31); a != 0 {
		t.Errorf("background pixel alpha = %d, want 0", a)
	}
}

func TestFloodWalksVignetteGradient(t *testing.T) {
	// Background whose edge differs strongly from its center (dark-ochre frame
	// fading into cream paper, as in the luftrausers skin). The border model
	// only sees the frame; the band-model retry plus cluster corridors must
	// remove the cream center too.
	edge := [3]float64{208, 160, 96}
	center := [3]float64{240, 224, 208}
	ship := color.NRGBA{60, 40, 20, 255}
	img := makeSprite(64, 64, func(x, y int) color.NRGBA {
		if x >= 26 && x < 38 && y >= 26 && y < 38 {
			return ship
		}
		// Radial-ish blend: distance to nearest border, ramped over 8 px.
		d := x
		if 63-x < d {
			d = 63 - x
		}
		if y < d {
			d = y
		}
		if 63-y < d {
			d = 63 - y
		}
		t := float64(d) / 8.0
		if t > 1 {
			t = 1
		}
		return color.NRGBA{
			uint8(edge[0] + (center[0]-edge[0])*t),
			uint8(edge[1] + (center[1]-edge[1])*t),
			uint8(edge[2] + (center[2]-edge[2])*t),
			255,
		}
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 0, 0); a != 0 {
		t.Errorf("frame edge alpha = %d, want 0", a)
	}
	if a := alphaAt(out, 20, 20); a != 0 {
		t.Errorf("cream center background alpha = %d, want 0 (continuity walk)", a)
	}
	if a := alphaAt(out, 32, 32); a != 255 {
		t.Errorf("ship alpha = %d, want 255", a)
	}
}

func TestFloodDespecklesNoiseIslands(t *testing.T) {
	// Isolated flecks of near-background color that individually exceed the
	// fill threshold (bright speckle on a noisy background) must be cleared;
	// the (larger) sprite must survive.
	bg := color.NRGBA{0, 48, 248, 255}
	fleck := color.NRGBA{120, 140, 255, 255} // dist ~150 from bg: outside fill threshold
	red := color.NRGBA{200, 30, 30, 255}
	img := makeSprite(64, 64, func(x, y int) color.NRGBA {
		if x >= 24 && x < 40 && y >= 24 && y < 40 {
			return red
		}
		if (x == 10 && y == 10) || (x == 50 && y == 12) || (x == 12 && y == 52) {
			return fleck
		}
		return bg
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	for _, p := range [][2]int{{10, 10}, {50, 12}, {12, 52}} {
		if a := alphaAt(out, p[0], p[1]); a != 0 {
			t.Errorf("noise fleck (%d,%d) alpha = %d, want 0 (despeckled)", p[0], p[1], a)
		}
	}
	if a := alphaAt(out, 32, 32); a != 255 {
		t.Errorf("sprite alpha = %d, want 255", a)
	}
}

func TestFloodLeavesCleanSpriteUntouched(t *testing.T) {
	// Already-keyed sprite: transparent border, opaque center. No opaque border
	// pixels → no background model → returned unchanged.
	img := makeSprite(32, 32, func(x, y int) color.NRGBA {
		if x >= 10 && x < 22 && y >= 10 && y < 22 {
			return color.NRGBA{200, 30, 30, 255}
		}
		return color.NRGBA{0, 0, 0, 0}
	})

	out := RemoveBackgroundFlood(img, 60, 20)
	if a := alphaAt(out, 16, 16); a != 255 {
		t.Errorf("sprite alpha = %d, want 255", a)
	}
}

func TestBorderOpaqueFraction(t *testing.T) {
	opaque := makeSprite(16, 16, func(x, y int) color.NRGBA {
		return color.NRGBA{10, 10, 10, 255}
	})
	if f := BorderOpaqueFraction(opaque); f != 1.0 {
		t.Errorf("fully opaque image fraction = %f, want 1.0", f)
	}

	clean := makeSprite(16, 16, func(x, y int) color.NRGBA {
		if x >= 4 && x < 12 && y >= 4 && y < 12 {
			return color.NRGBA{10, 10, 10, 255}
		}
		return color.NRGBA{0, 0, 0, 0}
	})
	if f := BorderOpaqueFraction(clean); f != 0.0 {
		t.Errorf("clean sprite fraction = %f, want 0.0", f)
	}
}
