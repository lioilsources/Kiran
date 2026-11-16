package postprocess

import (
	"image"
	"math"
)

// The parallax layers repeat vertically: parallax_bg.dart draws two copies of
// each one stacked, so the bottom row of a layer sits directly above its top
// row. Two things show there as a hard line. A tone that sweeps across the
// height (the model's default "sky": dark at the top, light at the bottom)
// puts a light-to-dark step at every repeat, and shapes that do not continue
// across the edge leave a cut. The prompt asks for neither, but a prompt is a
// request, so postprocess makes sure:
//
//   - FlattenVerticalTone removes the slow top-to-bottom sweep from the opaque
//     base plate, keeping the local detail.
//   - FoldSeam makes every layer continuous across its own edge by crossfading
//     its last rows into its first ones.
const (
	// seamBandFrac is the share of the height measured at each edge, and
	// the height of the crossfade FoldSeam spends.
	seamBandFrac = 0.06
	// toneSweepMax is the largest colour distance (0..441) between the top and
	// bottom bands that is left alone. Above it the sweep is a gradient, not
	// texture, and FlattenVerticalTone takes it out.
	toneSweepMax = 12.0
	// toneSmoothFrac is the window, as a share of the height, of the moving
	// average that separates the sweep from the detail. Wide enough that
	// clouds and craters count as detail, narrow enough to follow a sky that
	// bends rather than ramps.
	toneSmoothFrac = 0.25
)

// EdgeToneGap is the colour distance between the mean of the top band and the
// mean of the bottom band of img, counting only opaque pixels. It is what a
// player sees as the step at the repeat.
func EdgeToneGap(img image.Image) float64 {
	b := img.Bounds()
	band := seamBand(b.Dy())
	top := bandMean(img, b.Min.Y, b.Min.Y+band)
	bot := bandMean(img, b.Max.Y-band, b.Max.Y)
	return math.Sqrt(sq(top[0]-bot[0]) + sq(top[1]-bot[1]) + sq(top[2]-bot[2]))
}

// FlattenVerticalTone shifts each row by the difference between the image's
// mean colour and the smoothed mean of the rows around it, which removes a
// top-to-bottom gradient and leaves everything finer than toneSmoothFrac.
func FlattenVerticalTone(src image.Image) *image.NRGBA {
	img := toNRGBA(src)
	w, h := img.Rect.Dx(), img.Rect.Dy()
	if w == 0 || h == 0 {
		return img
	}
	rows := make([][3]float64, h)
	var global [3]float64
	for y := 0; y < h; y++ {
		rows[y] = bandMean(img, y, y+1)
		for c := 0; c < 3; c++ {
			global[c] += rows[y][c] / float64(h)
		}
	}
	half := int(float64(h)*toneSmoothFrac/2 + 0.5)
	if half < 1 {
		half = 1
	}
	if half > h-1 {
		half = h - 1
	}
	// Moving average over the rows extended past both ends by point
	// reflection (row -k = 2·row 0 − row k). A window clamped at the ends
	// would average a ramp's edge rows toward the middle and leave exactly the
	// edge step this exists to remove; the odd reflection keeps the ramp
	// straight through the end.
	ext := make([][3]float64, h+2*half)
	for i := range ext {
		y := i - half
		for c := 0; c < 3; c++ {
			switch {
			case y < 0:
				ext[i][c] = 2*rows[0][c] - rows[-y][c]
			case y >= h:
				ext[i][c] = 2*rows[h-1][c] - rows[2*(h-1)-y][c]
			default:
				ext[i][c] = rows[y][c]
			}
		}
	}
	prefix := make([][3]float64, len(ext)+1)
	for i := range ext {
		for c := 0; c < 3; c++ {
			prefix[i+1][c] = prefix[i][c] + ext[i][c]
		}
	}
	n := float64(2*half + 1)
	for y := 0; y < h; y++ {
		var shift [3]float64
		for c := 0; c < 3; c++ {
			// ext index y..y+2·half is the window centred on row y.
			shift[c] = global[c] - (prefix[y+2*half+1][c]-prefix[y][c])/n
		}
		off := y * img.Stride
		for x := 0; x < w; x++ {
			p := img.Pix[off+x*4 : off+x*4+4]
			for c := 0; c < 3; c++ {
				p[c] = clamp8(float64(p[c]) + shift[c])
			}
		}
	}
	return img
}

// FoldSeam returns img shortened by one band, its first band replaced by a
// crossfade from the original last band into the original first band. Row 0
// is then the old row h-band, so the bottom of the result (old row h-band-1)
// runs straight into it, and the crossfade ends on the old row band-1, which
// the old row band follows. Both joins are continuous; the band's worth of
// height lost is restored by the resize that follows.
func FoldSeam(src image.Image) *image.NRGBA {
	img := toNRGBA(src)
	w, h := img.Rect.Dx(), img.Rect.Dy()
	band := seamBand(h)
	if band < 2 || h < 4*band {
		return img
	}
	outH := h - band
	out := image.NewNRGBA(image.Rect(0, 0, w, outH))
	for y := 0; y < outH; y++ {
		dst := out.Pix[y*out.Stride : y*out.Stride+w*4]
		cur := img.Pix[y*img.Stride : y*img.Stride+w*4]
		if y >= band {
			copy(dst, cur)
			continue
		}
		tail := img.Pix[(outH+y)*img.Stride : (outH+y)*img.Stride+w*4]
		t := float64(y) / float64(band-1)
		t = t * t * (3 - 2*t) // smoothstep: no kink where the fade starts or ends
		for i := range dst {
			dst[i] = clamp8(float64(tail[i])*(1-t) + float64(cur[i])*t)
		}
	}
	return out
}

func seamBand(h int) int {
	return int(float64(h)*seamBandFrac + 0.5)
}

// bandMean is the mean colour of rows [y0, y1), weighted by alpha so a mostly
// transparent overlay is judged by what is drawn, not by its empty black.
func bandMean(img image.Image, y0, y1 int) [3]float64 {
	b := img.Bounds()
	var sum [3]float64
	var weight float64
	for y := y0; y < y1; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			r, g, bl, a := img.At(x, y).RGBA()
			if a == 0 {
				continue
			}
			wgt := float64(a) / 0xffff
			// RGBA() is alpha-premultiplied; undo it to compare colours.
			sum[0] += float64(r) / float64(a) * 255 * wgt
			sum[1] += float64(g) / float64(a) * 255 * wgt
			sum[2] += float64(bl) / float64(a) * 255 * wgt
			weight += wgt
		}
	}
	if weight == 0 {
		return sum
	}
	return [3]float64{sum[0] / weight, sum[1] / weight, sum[2] / weight}
}

func toNRGBA(src image.Image) *image.NRGBA {
	b := src.Bounds()
	if n, ok := src.(*image.NRGBA); ok && b.Min == (image.Point{}) {
		cp := image.NewNRGBA(n.Rect)
		copy(cp.Pix, n.Pix)
		return cp
	}
	out := image.NewNRGBA(image.Rect(0, 0, b.Dx(), b.Dy()))
	for y := 0; y < b.Dy(); y++ {
		for x := 0; x < b.Dx(); x++ {
			out.Set(x, y, src.At(b.Min.X+x, b.Min.Y+y))
		}
	}
	return out
}

func clamp8(v float64) uint8 {
	switch {
	case v <= 0:
		return 0
	case v >= 255:
		return 255
	}
	return uint8(v + 0.5)
}

func sq(v float64) float64 { return v * v }
