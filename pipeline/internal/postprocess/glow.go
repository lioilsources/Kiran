package postprocess

import (
	"image"
	"math"
)

// Ship glow ramp tunables. The game plays vessel frames in a ping-pong loop
// (vessel.dart), so the synthesized frames form a MONOTONIC dim→bright ramp;
// the ping-pong itself produces the pulse. A pulse baked into the frames would
// double-pulse in game.
const (
	shipGlowMinGain  = 0.90 // frame 0: slightly dimmed
	shipGlowMaxGain  = 1.45 // frame N-1: brightest
	shipGlowLumGamma = 1.5  // luminance weighting exponent
)

// SynthesizeGlowFrames builds n animation frames from a single sprite by
// modulating brightness along a monotonic minGain→maxGain ramp. The gain is
// luminance-weighted (w = lum^lumGamma), so bright glow/engine pixels swing the
// full range while the dark hull barely moves — the ship reads as steady with
// pulsing energy. Alpha is left untouched, so every frame trims to an identical
// bounding box and the animation stays perfectly registered.
func SynthesizeGlowFrames(src *image.NRGBA, n int, minGain, maxGain, lumGamma float64) []*image.NRGBA {
	if n < 1 {
		return nil
	}
	frames := make([]*image.NRGBA, n)
	for i := 0; i < n; i++ {
		gain := minGain
		if n > 1 {
			gain = minGain + (maxGain-minGain)*float64(i)/float64(n-1)
		}
		frames[i] = applyGlowGain(src, gain, lumGamma)
	}
	return frames
}

// applyGlowGain scales each pixel's RGB by a per-pixel effective gain
// g = 1 + (gain-1)·lum^lumGamma, clamped to [0,255]. Alpha is copied verbatim.
func applyGlowGain(src *image.NRGBA, gain, lumGamma float64) *image.NRGBA {
	b := src.Bounds()
	dst := image.NewNRGBA(image.Rect(0, 0, b.Dx(), b.Dy()))
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			px := src.NRGBAAt(x, y)
			lum := (0.299*float64(px.R) + 0.587*float64(px.G) + 0.114*float64(px.B)) / 255
			g := 1 + (gain-1)*math.Pow(lum, lumGamma)
			px.R = clampByte(float64(px.R) * g)
			px.G = clampByte(float64(px.G) * g)
			px.B = clampByte(float64(px.B) * g)
			dst.SetNRGBA(x-b.Min.X, y-b.Min.Y, px)
		}
	}
	return dst
}

func clampByte(v float64) uint8 {
	if v <= 0 {
		return 0
	}
	if v >= 255 {
		return 255
	}
	return uint8(v + 0.5)
}
