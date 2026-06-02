package postprocess

import (
	"image"
	"image/color"
	"math"
)

// ResizeExact scales src to exactly dstW×dstH using area-average (box filter).
func ResizeExact(src image.Image, dstW, dstH int) *image.NRGBA {
	bounds := src.Bounds()
	srcW := bounds.Dx()
	srcH := bounds.Dy()
	dst := image.NewNRGBA(image.Rect(0, 0, dstW, dstH))

	for dy := 0; dy < dstH; dy++ {
		sy0 := dy * srcH / dstH
		sy1 := (dy + 1) * srcH / dstH
		if sy1 <= sy0 {
			sy1 = sy0 + 1
		}
		for dx := 0; dx < dstW; dx++ {
			sx0 := dx * srcW / dstW
			sx1 := (dx + 1) * srcW / dstW
			if sx1 <= sx0 {
				sx1 = sx0 + 1
			}

			var rSum, gSum, bSum, aSum, count int
			for sy := sy0; sy < sy1; sy++ {
				for sx := sx0; sx < sx1; sx++ {
					r, g, b, a := src.At(sx+bounds.Min.X, sy+bounds.Min.Y).RGBA()
					rSum += int(r >> 8)
					gSum += int(g >> 8)
					bSum += int(b >> 8)
					aSum += int(a >> 8)
					count++
				}
			}
			if count == 0 {
				count = 1
			}
			dst.SetNRGBA(dx, dy, color.NRGBA{
				R: uint8(rSum / count),
				G: uint8(gSum / count),
				B: uint8(bSum / count),
				A: uint8(aSum / count),
			})
		}
	}
	return dst
}

// Trim crops src to the bounding box of its non-transparent pixels, removing any
// transparent padding around the content. This is the key step that lets a
// sprite's dimensions reflect its actual artwork rather than the (often large,
// mostly-empty) generation canvas. A fully transparent image is returned as-is.
func Trim(src *image.NRGBA) *image.NRGBA {
	b := src.Bounds()
	minX, minY := b.Max.X, b.Max.Y
	maxX, maxY := b.Min.X-1, b.Min.Y-1

	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			if src.NRGBAAt(x, y).A == 0 {
				continue
			}
			if x < minX {
				minX = x
			}
			if y < minY {
				minY = y
			}
			if x > maxX {
				maxX = x
			}
			if y > maxY {
				maxY = y
			}
		}
	}

	if maxX < minX || maxY < minY {
		return src // fully transparent — nothing to trim
	}

	w := maxX - minX + 1
	h := maxY - minY + 1
	dst := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			dst.SetNRGBA(x, y, src.NRGBAAt(minX+x, minY+y))
		}
	}
	return dst
}

// FitInside scales src to fit within refW×refH while preserving aspect ratio, so
// the constraining dimension exactly matches the reference box. The result is
// tight (no padding) with dimensions ≤ refW×refH, giving every skin the same
// in-game footprint for a given sprite.
func FitInside(src *image.NRGBA, refW, refH int) *image.NRGBA {
	b := src.Bounds()
	cw, ch := b.Dx(), b.Dy()
	if cw == 0 || ch == 0 || refW <= 0 || refH <= 0 {
		return src
	}

	scale := math.Min(float64(refW)/float64(cw), float64(refH)/float64(ch))
	dstW := int(math.Round(float64(cw) * scale))
	dstH := int(math.Round(float64(ch) * scale))
	if dstW < 1 {
		dstW = 1
	}
	if dstH < 1 {
		dstH = 1
	}
	if dstW > refW {
		dstW = refW
	}
	if dstH > refH {
		dstH = refH
	}
	return resizeNRGBAExact(src, dstW, dstH)
}

// resizeNRGBAExact scales an NRGBA image to exactly dstW×dstH using area-average,
// reading straight (non-premultiplied) components so alpha edges stay clean.
func resizeNRGBAExact(src *image.NRGBA, dstW, dstH int) *image.NRGBA {
	b := src.Bounds()
	srcW := b.Dx()
	srcH := b.Dy()
	dst := image.NewNRGBA(image.Rect(0, 0, dstW, dstH))

	for dy := 0; dy < dstH; dy++ {
		sy0 := dy * srcH / dstH
		sy1 := (dy + 1) * srcH / dstH
		if sy1 <= sy0 {
			sy1 = sy0 + 1
		}
		for dx := 0; dx < dstW; dx++ {
			sx0 := dx * srcW / dstW
			sx1 := (dx + 1) * srcW / dstW
			if sx1 <= sx0 {
				sx1 = sx0 + 1
			}

			var rSum, gSum, bSum, aSum, count int
			for sy := sy0; sy < sy1; sy++ {
				for sx := sx0; sx < sx1; sx++ {
					c := src.NRGBAAt(sx+b.Min.X, sy+b.Min.Y)
					rSum += int(c.R)
					gSum += int(c.G)
					bSum += int(c.B)
					aSum += int(c.A)
					count++
				}
			}
			if count == 0 {
				count = 1
			}
			dst.SetNRGBA(dx, dy, color.NRGBA{
				R: uint8(rSum / count),
				G: uint8(gSum / count),
				B: uint8(bSum / count),
				A: uint8(aSum / count),
			})
		}
	}
	return dst
}

// Resize downscales src to fit within targetSize×targetSize using area-average
// (box filter). Aspect ratio is preserved — the longer dimension becomes targetSize.
// If the source is already smaller than targetSize, it is returned as-is.
func Resize(src *image.NRGBA, targetSize int) *image.NRGBA {
	bounds := src.Bounds()
	srcW := bounds.Dx()
	srcH := bounds.Dy()

	if srcW <= targetSize && srcH <= targetSize {
		return src
	}

	// Determine output dimensions preserving aspect ratio.
	var dstW, dstH int
	if srcW >= srcH {
		dstW = targetSize
		dstH = srcH * targetSize / srcW
		if dstH < 1 {
			dstH = 1
		}
	} else {
		dstH = targetSize
		dstW = srcW * targetSize / srcH
		if dstW < 1 {
			dstW = 1
		}
	}

	dst := image.NewNRGBA(image.Rect(0, 0, dstW, dstH))

	for dy := 0; dy < dstH; dy++ {
		// Source row range for this destination row.
		sy0 := dy * srcH / dstH
		sy1 := (dy + 1) * srcH / dstH
		if sy1 <= sy0 {
			sy1 = sy0 + 1
		}

		for dx := 0; dx < dstW; dx++ {
			// Source column range for this destination column.
			sx0 := dx * srcW / dstW
			sx1 := (dx + 1) * srcW / dstW
			if sx1 <= sx0 {
				sx1 = sx0 + 1
			}

			var rSum, gSum, bSum, aSum, count int
			for sy := sy0; sy < sy1; sy++ {
				for sx := sx0; sx < sx1; sx++ {
					c := src.NRGBAAt(sx+bounds.Min.X, sy+bounds.Min.Y)
					rSum += int(c.R)
					gSum += int(c.G)
					bSum += int(c.B)
					aSum += int(c.A)
					count++
				}
			}

			if count == 0 {
				count = 1
			}
			dst.SetNRGBA(dx, dy, color.NRGBA{
				R: uint8(rSum / count),
				G: uint8(gSum / count),
				B: uint8(bSum / count),
				A: uint8(aSum / count),
			})
		}
	}
	return dst
}
