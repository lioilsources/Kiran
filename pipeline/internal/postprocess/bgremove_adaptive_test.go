package postprocess

import (
	"image"
	"image/color"
	"testing"
)

// paleOnPale reproduces the failure this file exists for: a light sprite drawn
// on a light plate, the shape solar_striker's four-shade green palette produces.
// The two colours are 26 apart in euclidean distance, so a key with the default
// tolerance of 60 claims the sprite along with the plate.
func paleOnPale() image.Image {
	const w, h = 64, 64
	bg := color.NRGBA{R: 155, G: 188, B: 15, A: 255}
	fg := color.NRGBA{R: 139, G: 172, B: 15, A: 255}
	img := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			c := bg
			if x >= 16 && x < 48 && y >= 16 && y < 48 {
				c = fg
			}
			img.SetNRGBA(x, y, c)
		}
	}
	return img
}

func TestKeySpriteBacksOffWhenTheKeyErasesTheArtwork(t *testing.T) {
	src := paleOnPale()

	if cov := opaqueCoverage(RemoveBackgroundFlood(src, 60, 20)); cov >= keyDeadCoverage {
		t.Fatalf("fixture no longer reproduces the failure: %.4f opaque at threshold 60", cov)
	}

	got := opaqueCoverage(KeySprite(src, 60, 20, "test"))
	if got < keyRescueCoverage {
		t.Errorf("backoff did not recover the sprite: %.4f opaque, want >= %.4f", got, keyRescueCoverage)
	}
	// The square is a quarter of the frame; a rescue that grabbed the plate too
	// would land far above it.
	if got > 0.35 {
		t.Errorf("backoff kept the background as well: %.4f opaque, want ~0.25", got)
	}
}

func TestKeySpriteLeavesAHealthyKeyAlone(t *testing.T) {
	const w, h = 64, 64
	img := image.NewNRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			c := color.NRGBA{A: 255}
			if x >= 16 && x < 48 && y >= 16 && y < 48 {
				c = color.NRGBA{R: 255, G: 240, B: 40, A: 255}
			}
			img.SetNRGBA(x, y, c)
		}
	}

	want := opaqueCoverage(RemoveBackgroundFlood(img, 60, 20))
	if got := opaqueCoverage(KeySprite(img, 60, 20, "test")); got != want {
		t.Errorf("KeySprite altered a key that already worked: %.4f, want %.4f", got, want)
	}
}
