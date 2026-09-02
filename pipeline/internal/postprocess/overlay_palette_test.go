package postprocess

import (
	"image"
	"image/color"
	"testing"
)

// greySpecks is what the generator hands back when it reads "bright glowing
// speck" as white: luminous dots with no hue at all, on black.
func greySpecks() *image.NRGBA {
	img := image.NewNRGBA(image.Rect(0, 0, 32, 32))
	for y := 0; y < 32; y++ {
		for x := 0; x < 32; x++ {
			img.SetNRGBA(x, y, color.NRGBA{A: 0})
		}
	}
	for i, v := range []uint8{60, 140, 255} {
		img.SetNRGBA(4+i*8, 10, color.NRGBA{R: v, G: v, B: v, A: 255})
	}
	return img
}

func TestPaletteFromDescriptionSortsDarkToLight(t *testing.T) {
	pal := PaletteFromDescription("darkest #0F380F, dark #306230, light #8BAC0F, lightest #9BBC0F")
	if len(pal) != 4 {
		t.Fatalf("got %d colours, want 4", len(pal))
	}
	for i := 1; i < len(pal); i++ {
		if lumaOf(pal[i-1]) > lumaOf(pal[i]) {
			t.Errorf("palette not sorted dark to light at %d: %v then %v", i, pal[i-1], pal[i])
		}
	}
	if len(PaletteFromDescription("four shades of greenish gray, no hex here")) != 0 {
		t.Error("a worded palette should yield nothing rather than a guess")
	}
}

func TestRecolourOverlayPutsTheSkinPaletteOnGreySpecks(t *testing.T) {
	src := greySpecks()
	if sat := meanSaturationOpaque(src); sat >= overlayGreyMax {
		t.Fatalf("fixture is not grey: saturation %.2f", sat)
	}

	pal := PaletteFromDescription("darkest #0F380F, dark #306230, light #8BAC0F, lightest #9BBC0F")
	out := RecolourOverlay(src, pal)

	if sat := meanSaturationOpaque(out); sat < 0.4 {
		t.Errorf("specks are still washed out: saturation %.2f", sat)
	}
	// Alpha is the layer's whole contribution to the parallax and must survive
	// untouched — a recolour that also moved alpha would change the composite.
	b := src.Bounds()
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			if src.NRGBAAt(x, y).A != out.NRGBAAt(x, y).A {
				t.Fatalf("alpha changed at %d,%d", x, y)
			}
		}
	}
	// Brightness order has to survive too, or the specks stop reading as lit.
	dark := lumaOf(out.NRGBAAt(4, 10))
	mid := lumaOf(out.NRGBAAt(12, 10))
	bright := lumaOf(out.NRGBAAt(20, 10))
	if !(dark < mid && mid < bright) {
		t.Errorf("ramp does not preserve brightness order: %.0f %.0f %.0f", dark, mid, bright)
	}
}

func TestRecolourOverlayLeavesAColouredLayerAlone(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 16, 16))
	for y := 0; y < 16; y++ {
		for x := 0; x < 16; x++ {
			img.SetNRGBA(x, y, color.NRGBA{R: 66, G: 249, B: 26, A: 255})
		}
	}
	if sat := meanSaturationOpaque(img); sat < overlayGreyMax {
		t.Errorf("a saturated green layer must sit above the gate, got %.2f", sat)
	}
}
