package postprocess

import (
	"fmt"
	"image"
)

// keyDeadCoverage is the opaque fraction below which a key is treated as having
// erased the artwork instead of the background.
//
// The floor has to clear the thinnest legitimate sprites, which are the bullets:
// measured on real art, a laser keys to 2.1% and a blaster to 1.1% of the frame.
// A total erasure measures exactly 0. Sitting the floor an order of magnitude
// under the thinnest real asset keeps the two cases apart without a per-asset
// table that would drift out of date.
const keyDeadCoverage = 0.001

// keyRescueCoverage is what a backed-off key has to reach before the rescue
// counts. It is deliberately far above keyDeadCoverage: on a bad roll, loosening
// the threshold can hand back a few hundred rim pixels, which passes a
// death test but is still a hole in the atlas. Accepting that would replace the
// loud "pick another variation" with a quiet success and ship the hole.
const keyRescueCoverage = 0.02

// keyBackoffThresholds are tried in order after the caller's threshold fails.
// They descend because a lower threshold claims less as background: for an
// image the key already emptied, retaining more is strictly the right direction.
// The walk stops at the first threshold that clears the floor, so a rescued
// sprite keeps the tightest key that actually works rather than the loosest.
var keyBackoffThresholds = []int{45, 35, 25, 18, 12}

// KeySprite chroma-keys a sprite and backs off if the key erased the artwork.
//
// The flood key models the background from border pixels and claims everything
// within `threshold` colour distance that is 4-connected to the border. On a
// four-shade monochrome skin — solar_striker's Game Boy green — a pale asteroid
// on a pale background sits inside that distance and is consumed whole, leaving
// a fully transparent PNG that reaches the atlas as a hole in the game. Measured
// across solar_striker's 27 sprites at the default threshold of 60, asteroid3
// and one bubble variation came back at 0.0% opaque; both key correctly at 45
// or below. The same sprites on tempest's pure black backgrounds are untouched,
// which is why this only ever surfaced on the monochrome skins.
//
// name is used only for the warning, which is deliberately loud: a silent
// rescue would hide a background that is genuinely too close to the artwork and
// wants a different variation, not a looser key.
func KeySprite(src image.Image, threshold, margin int, name string) *image.NRGBA {
	out := RemoveBackgroundFlood(src, threshold, margin)
	if opaqueCoverage(out) >= keyDeadCoverage {
		return out
	}

	best, bestCov, bestThresh := out, 0.0, threshold
	for _, t := range keyBackoffThresholds {
		if t >= threshold {
			continue
		}
		retry := RemoveBackgroundFlood(src, t, margin)
		cov := opaqueCoverage(retry)
		if cov > bestCov {
			best, bestCov, bestThresh = retry, cov, t
		}
		if cov >= keyRescueCoverage {
			fmt.Printf("  [key] %s erased at threshold %d — kept threshold %d (%.1f%% opaque)\n",
				name, threshold, t, cov*100)
			return retry
		}
	}

	fmt.Printf("  [key] %s erased at threshold %d and no backoff recovered it "+
		"(best %.1f%% opaque at threshold %d) — the artwork is indistinguishable from its "+
		"background, pick another variation\n", name, threshold, bestCov*100, bestThresh)
	return best
}

// opaqueCoverage is the fraction of pixels that survived the key. Half-alpha
// edge pixels count as surviving: a sprite reduced to nothing but its
// anti-aliased rim is still a failure worth reporting, but it is not an erasure.
func opaqueCoverage(img *image.NRGBA) float64 {
	b := img.Bounds()
	total := b.Dx() * b.Dy()
	if total == 0 {
		return 0
	}
	opaque := 0
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			if img.NRGBAAt(x, y).A > 16 {
				opaque++
			}
		}
	}
	return float64(opaque) / float64(total)
}
