package postprocess

import (
	"image"
	"image/color"
	"testing"
)

// glowTestSprite builds a sprite with a transparent border, a dark hull and a
// bright glow pixel, so the luminance weighting has both ends to work with.
func glowTestSprite() *image.NRGBA {
	img := image.NewNRGBA(image.Rect(0, 0, 8, 8))
	for y := 2; y < 6; y++ {
		for x := 2; x < 6; x++ {
			img.SetNRGBA(x, y, color.NRGBA{40, 40, 60, 255}) // dark hull
		}
	}
	img.SetNRGBA(4, 5, color.NRGBA{200, 220, 255, 255}) // bright engine glow
	return img
}

func meanLuminance(img *image.NRGBA) float64 {
	b := img.Bounds()
	var sum float64
	var n int
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			px := img.NRGBAAt(x, y)
			if px.A == 0 {
				continue
			}
			sum += 0.299*float64(px.R) + 0.587*float64(px.G) + 0.114*float64(px.B)
			n++
		}
	}
	return sum / float64(n)
}

func TestSynthesizeGlowFrames_MonotonicRamp(t *testing.T) {
	src := glowTestSprite()
	frames := SynthesizeGlowFrames(src, 6, shipGlowMinGain, shipGlowMaxGain, shipGlowLumGamma)
	if len(frames) != 6 {
		t.Fatalf("got %d frames, want 6", len(frames))
	}
	prev := -1.0
	for i, f := range frames {
		if f.Bounds() != src.Bounds() {
			t.Errorf("frame %d bounds %v, want %v", i, f.Bounds(), src.Bounds())
		}
		lum := meanLuminance(f)
		if lum <= prev {
			t.Errorf("frame %d mean luminance %.2f not greater than previous %.2f", i, lum, prev)
		}
		prev = lum
	}
}

func TestSynthesizeGlowFrames_AlphaUntouched(t *testing.T) {
	src := glowTestSprite()
	for i, f := range SynthesizeGlowFrames(src, 6, shipGlowMinGain, shipGlowMaxGain, shipGlowLumGamma) {
		b := src.Bounds()
		for y := b.Min.Y; y < b.Max.Y; y++ {
			for x := b.Min.X; x < b.Max.X; x++ {
				if f.NRGBAAt(x, y).A != src.NRGBAAt(x, y).A {
					t.Fatalf("frame %d alpha changed at (%d,%d)", i, x, y)
				}
			}
		}
	}
}

func TestSynthesizeGlowFrames_BrightPixelsSwingMore(t *testing.T) {
	src := glowTestSprite()
	frames := SynthesizeGlowFrames(src, 6, shipGlowMinGain, shipGlowMaxGain, shipGlowLumGamma)
	first, last := frames[0], frames[len(frames)-1]

	hullSwing := int(last.NRGBAAt(2, 2).R) - int(first.NRGBAAt(2, 2).R)
	glowSwing := int(last.NRGBAAt(4, 5).G) - int(first.NRGBAAt(4, 5).G)
	if glowSwing <= hullSwing {
		t.Errorf("glow pixel swing %d should exceed dark hull swing %d", glowSwing, hullSwing)
	}
}
