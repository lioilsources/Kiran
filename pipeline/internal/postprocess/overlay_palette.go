package postprocess

import (
	"fmt"
	"image"
	"image/color"
	"math"
	"regexp"
	"sort"
)

// overlayGreyMax is the mean saturation below which an overlay layer counts as
// having lost its palette. Measured on real art: the layers that came out right
// sit at 0.75 (space_invaders' green motes) and 0.30 (luftrausers' sepia dust),
// the ones that failed at 0.00 (a four-shade green skin rendered pure white)
// and 0.02. Nothing observed lands between 0.15 and 0.30, so the gate has room
// on both sides and a deliberately monochrome skin is never dragged into colour
// it did not ask for — it has no palette hues to be recoloured with either.
const overlayGreyMax = 0.15

var hexColor = regexp.MustCompile(`#[0-9A-Fa-f]{6}`)

// RecolourOverlay maps an overlay layer's luminance onto the skin's own palette.
//
// The parallax overlays are luminous specks and debris on black, and their
// alpha already comes from luminance rather than a chroma key, so the generator
// only ever supplies two useful things: where the elements are and how bright.
// Their hue is not an artistic variable at all — it is stated in the skin
// definition. Three rounds of prompt work could not make the model honour it on
// a narrow palette (naming the colours, reordering them ahead of the layer
// description, and replacing negations with positive specification each moved
// it and none fixed it; diffusion reads "bright glowing speck" as white), so
// the hue is imposed here instead of negotiated there.
//
// This is deliberately not done to sprites. A sprite's colour carries modelling
// and material, and remapping it would flatten the art. An overlay speck has no
// material — it is a coloured dot — so nothing is lost by stating its colour.
//
// palette must be sorted dark to light. Alpha is untouched.
func RecolourOverlay(src *image.NRGBA, palette []color.NRGBA) *image.NRGBA {
	if len(palette) == 0 {
		return src
	}
	b := src.Bounds()
	dst := image.NewNRGBA(b)
	last := float64(len(palette) - 1)
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			p := src.NRGBAAt(x, y)
			if p.A == 0 {
				dst.SetNRGBA(x, y, p)
				continue
			}
			lum := (0.299*float64(p.R) + 0.587*float64(p.G) + 0.114*float64(p.B)) / 255
			// Interpolate along the ramp so the speck keeps its internal
			// falloff — snapping to the nearest entry would posterise every
			// soft edge into a hard ring.
			pos := lum * last
			i := int(pos)
			if i >= len(palette)-1 {
				i = len(palette) - 2
				if i < 0 {
					dst.SetNRGBA(x, y, color.NRGBA{R: palette[0].R, G: palette[0].G, B: palette[0].B, A: p.A})
					continue
				}
			}
			t := pos - float64(i)
			mix := func(a, bb uint8) uint8 { return uint8(float64(a) + (float64(bb)-float64(a))*t + 0.5) }
			dst.SetNRGBA(x, y, color.NRGBA{
				R: mix(palette[i].R, palette[i+1].R),
				G: mix(palette[i].G, palette[i+1].G),
				B: mix(palette[i].B, palette[i+1].B),
				A: p.A,
			})
		}
	}
	return dst
}

// PaletteFromDescription pulls the hex codes out of a skin's PaletteDescription
// and returns them sorted dark to light, which is the order RecolourOverlay
// ramps through. Skins that describe their palette in words rather than hex
// yield nothing and are left alone.
func PaletteFromDescription(desc string) []color.NRGBA {
	var out []color.NRGBA
	for _, h := range hexColor.FindAllString(desc, -1) {
		var r, g, b uint8
		if _, err := fmt.Sscanf(h[1:], "%02x%02x%02x", &r, &g, &b); err != nil {
			continue
		}
		out = append(out, color.NRGBA{R: r, G: g, B: b, A: 255})
	}
	sort.SliceStable(out, func(i, j int) bool { return lumaOf(out[i]) < lumaOf(out[j]) })
	return out
}

func lumaOf(c color.NRGBA) float64 {
	return 0.299*float64(c.R) + 0.587*float64(c.G) + 0.114*float64(c.B)
}

// meanSaturationOpaque is the average HSV saturation over the pixels that
// survived the luminance key. Fully transparent pixels carry whatever RGB the
// encoder left behind and would drag the average toward that, so they are
// excluded rather than weighted down.
func meanSaturationOpaque(img *image.NRGBA) float64 {
	b := img.Bounds()
	var sum float64
	var n int
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			p := img.NRGBAAt(x, y)
			if p.A < 32 {
				continue
			}
			mx := math.Max(float64(p.R), math.Max(float64(p.G), float64(p.B)))
			mn := math.Min(float64(p.R), math.Min(float64(p.G), float64(p.B)))
			if mx > 0 {
				sum += (mx - mn) / mx
			}
			n++
		}
	}
	if n == 0 {
		return 0
	}
	return sum / float64(n)
}
