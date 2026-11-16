package postprocess

import (
	"image"
	"image/color"
	"math"
	"testing"
)

// sky is the failure the guard exists for: dark at the top, light at the
// bottom, with a little texture on top of the ramp.
func sky(w, h int) *image.NRGBA {
	img := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		v := 20 + 180*float64(y)/float64(h-1)
		for x := 0; x < w; x++ {
			tex := 0.0
			if (x/4+y/4)%2 == 0 {
				tex = 10
			}
			img.SetNRGBA(x, y, color.NRGBA{clamp8(v + tex), clamp8(v*0.8 + tex), clamp8(v*0.5 + tex), 255})
		}
	}
	return img
}

func TestEdgeToneGapSeesTheSweep(t *testing.T) {
	if gap := EdgeToneGap(sky(32, 400)); gap < 100 {
		t.Errorf("a dark-to-light sky has edge gap %.0f, want a large one", gap)
	}
	flat := image.NewNRGBA(image.Rect(0, 0, 32, 400))
	for i := range flat.Pix {
		flat.Pix[i] = 90
	}
	if gap := EdgeToneGap(flat); gap > 0.5 {
		t.Errorf("a flat plate has edge gap %.1f, want 0", gap)
	}
}

func TestFlattenVerticalToneClosesTheGap(t *testing.T) {
	src := sky(32, 400)
	out := FlattenVerticalTone(src)
	if gap := EdgeToneGap(out); gap > toneSweepMax {
		t.Errorf("after flattening the edge gap is %.0f, want at most %.0f", gap, toneSweepMax)
	}
	// The detail survives: neighbouring checker cells still differ.
	a := out.NRGBAAt(0, 200).R
	b := out.NRGBAAt(4, 200).R
	if d := int(a) - int(b); d < 5 && d > -5 {
		t.Errorf("texture flattened away: %d vs %d", a, b)
	}
	// The source is not touched.
	if src.NRGBAAt(0, 0) == out.NRGBAAt(0, 0) {
		t.Error("expected the top row to be lifted")
	}
}

// After the fold the last row must lead into the first as smoothly as any two
// neighbouring rows inside the image do.
func TestFoldSeamJoinsTheEdges(t *testing.T) {
	src := sky(16, 400)
	out := FoldSeam(src)
	h := out.Rect.Dy()
	if want := 400 - seamBand(400); h != want {
		t.Fatalf("folded height %d, want %d", h, want)
	}
	step := func(y0, y1 int) float64 {
		return math.Abs(float64(out.NRGBAAt(1, y0).G) - float64(out.NRGBAAt(1, y1).G))
	}
	inner := 0.0
	for y := 1; y < h; y++ {
		inner = math.Max(inner, step(y-1, y))
	}
	if wrap := step(h-1, 0); wrap > inner+1 {
		t.Errorf("step across the repeat %.0f, the largest inside is %.0f", wrap, inner)
	}
	before := math.Abs(float64(src.NRGBAAt(1, 399).G) - float64(src.NRGBAAt(1, 0).G))
	if before < 50 {
		t.Fatalf("test image should start with a hard seam, got %.0f", before)
	}
}

func TestFoldSeamLeavesTinyImagesAlone(t *testing.T) {
	src := sky(4, 10)
	if out := FoldSeam(src); out.Rect.Dy() != 10 {
		t.Errorf("a 10-row image was folded to %d rows", out.Rect.Dy())
	}
}
