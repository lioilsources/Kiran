package postprocess

import (
	"image"
	"image/draw"
	"math"
)

// bgCluster is one color mode of the background model.
type bgCluster struct {
	r, g, b float64
	count   int
}

// bgModel is a set of background color clusters plus the "corridors" (RGB line
// segments) between every cluster pair. Real backgrounds shade smoothly between
// their color modes (vignettes, soft shadows, gradients), so any color lying
// near a segment between two background modes is treated as background too —
// without having to sample every intermediate shade.
type bgModel struct {
	clusters []bgCluster
	segs     [][2]int // index pairs into clusters
}

func newBgModel(clusters []bgCluster) *bgModel {
	m := &bgModel{clusters: clusters}
	for i := 0; i < len(clusters); i++ {
		for j := i + 1; j < len(clusters); j++ {
			m.segs = append(m.segs, [2]int{i, j})
		}
	}
	return m
}

// dist returns the distance from a color to the model: the minimum over all
// cluster centers and all corridors between cluster pairs.
func (m *bgModel) dist(r, g, b uint8) float64 {
	pr, pg, pb := float64(r), float64(g), float64(b)
	min := 1e9
	for _, c := range m.clusters {
		d := euclid(pr-c.r, pg-c.g, pb-c.b)
		if d < min {
			min = d
		}
	}
	for _, s := range m.segs {
		a, bc := m.clusters[s[0]], m.clusters[s[1]]
		abr, abg, abb := bc.r-a.r, bc.g-a.g, bc.b-a.b
		denom := abr*abr + abg*abg + abb*abb
		if denom == 0 {
			continue
		}
		t := ((pr-a.r)*abr + (pg-a.g)*abg + (pb-a.b)*abb) / denom
		if t < 0 {
			t = 0
		} else if t > 1 {
			t = 1
		}
		d := euclid(pr-(a.r+t*abr), pg-(a.g+t*abg), pb-(a.b+t*abb))
		if d < min {
			min = d
		}
	}
	return min
}

func euclid(dr, dg, db float64) float64 {
	return math.Sqrt(dr*dr + dg*dg + db*db)
}

// clusterJoinDist is the max distance at which a pixel joins an existing
// cluster instead of starting a new one.
const clusterJoinDist = 48.0

// clusterMinShare drops clusters covering less than this fraction of the
// samples, so a sprite touching the edge (e.g. an engine flame) or grazed by a
// sampling ring does not poison the background model with its own colors.
const clusterMinShare = 0.05

// bandRetryOpaqueFrac triggers the band-model retry: if after the border-model
// fill more than this fraction of the image is still opaque, the background
// center likely differs too much from its border ring (framed/vignetted
// backgrounds), so the model is rebuilt from sampling rings across a band
// inset from the border and the fill is re-run.
const bandRetryOpaqueFrac = 0.55

// bandRingInsets are the ring positions (as fractions of the smaller image
// dimension) sampled for the band model retry.
var bandRingInsets = []float64{0, 0.03, 0.06, 0.09, 0.12}

// pocketMinAreaFrac is the minimum size (fraction of image area) for an
// enclosed background-colored region to be cleared. Smaller matches are kept —
// they are usually sprite highlights that merely resemble the background.
const pocketMinAreaFrac = 0.005

// speckleMaxAreaFrac and speckleColorFactor control the final despeckle pass:
// surviving islands smaller than speckleMaxAreaFrac of the image whose mean
// color sits within speckleColorFactor*threshold of the background model are
// residual background noise and get cleared.
const (
	speckleMaxAreaFrac = 0.0005
	speckleColorFactor = 3.0
)

// RemoveBackgroundFlood removes a baked-in background by flood-filling from the
// image border. Unlike RemoveBackground's global chroma key against a 4-corner
// average, it:
//
//   - models the background as multiple color clusters built from all border
//     pixels — plus the corridors between them — so noisy, textured and
//     gradient backgrounds are represented;
//   - claims only pixels 4-connected to the border, so interior artwork sharing
//     a background color is protected;
//   - retries with a model sampled from rings inset from the border when the
//     border ring alone fails to represent the background's center (framed or
//     vignetted backgrounds);
//   - clears enclosed pockets that are large, contiguous and unmistakably
//     background-colored, matching what the chroma key does where it works;
//   - despeckles small leftover background-noise islands.
//
// margin ramps alpha on surviving pixels bordering the removed region for
// anti-aliased edges.
func RemoveBackgroundFlood(src image.Image, threshold, margin int) *image.NRGBA {
	b := src.Bounds()
	w, h := b.Dx(), b.Dy()
	// draw.Src keeps straight (non-premultiplied) colors for semi-transparent
	// pixels — converting via At().RGBA() would darken them toward black and
	// poison the background model on sprites with partially-removed backgrounds.
	dst := image.NewNRGBA(image.Rect(0, 0, w, h))
	draw.Draw(dst, dst.Bounds(), src, b.Min, draw.Src)
	if w < 3 || h < 3 {
		return dst
	}

	clusters := borderClusters(dst)
	if len(clusters) == 0 {
		return dst // border already transparent — nothing baked in
	}

	thresh := float64(threshold)
	model := newBgModel(clusters)
	isBg := fillFromBorder(dst, model, thresh)

	// Framed/vignetted backgrounds: the border ring may not represent the
	// background's center at all, leaving most of the image opaque. Rebuild the
	// model from rings sampled across a band inset from the border (which see
	// the center colors) and take the retry if it removes more.
	if opaqueRemaining(dst, isBg) > bandRetryOpaqueFrac {
		if band := bandClusters(dst); len(band) > 0 {
			bandModel := newBgModel(band)
			isBg2 := fillFromBorder(dst, bandModel, thresh)
			if countTrue(isBg2) > countTrue(isBg) {
				isBg = isBg2
				model = bandModel
			}
		}
	}

	// Enrich the color model with what the fill actually claimed, for the
	// pocket and despeckle passes.
	enriched := newBgModel(enrichClusters(dst, isBg, model.clusters))

	clearPockets(dst, isBg, enriched, thresh/2, w, h)
	despeckle(dst, isBg, enriched, speckleColorFactor*thresh, w, h)

	// Write alpha: removed pixels become fully transparent; surviving pixels
	// adjacent to the removed region get a soft ramp between threshold and
	// threshold+margin so anti-aliased edges don't keep a hard background rim.
	marg := float64(margin)
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			idx := y*w + x
			px := dst.Pix[idx*4 : idx*4+4]
			if isBg[idx] {
				px[3] = 0
				continue
			}
			if marg <= 0 || !touchesBg(isBg, x, y, w, h) {
				continue
			}
			dist := enriched.dist(px[0], px[1], px[2])
			if dist < thresh+marg {
				t := (dist - thresh) / marg
				if t < 0 {
					t = 0
				}
				ramp := uint8(t * 255)
				if ramp < px[3] {
					px[3] = ramp
				}
			}
		}
	}
	return dst
}

// fillFromBorder runs the connectivity fill: pixels matching the background
// model that are 4-connected to the image border are marked as background.
func fillFromBorder(dst *image.NRGBA, model *bgModel, thresh float64) []bool {
	b := dst.Bounds()
	w, h := b.Dx(), b.Dy()
	isBg := make([]bool, w*h)
	queue := make([]int, 0, w*h/4)

	claimable := func(idx int) bool {
		px := dst.Pix[idx*4 : idx*4+4]
		if px[3] <= 16 {
			return true // already transparent — background continues through it
		}
		return model.dist(px[0], px[1], px[2]) < thresh
	}

	seed := func(idx int) {
		if !isBg[idx] && claimable(idx) {
			isBg[idx] = true
			queue = append(queue, idx)
		}
	}
	for x := 0; x < w; x++ {
		seed(x)
		seed((h-1)*w + x)
	}
	for y := 0; y < h; y++ {
		seed(y * w)
		seed(y*w + w - 1)
	}

	for len(queue) > 0 {
		idx := queue[len(queue)-1]
		queue = queue[:len(queue)-1]
		x, y := idx%w, idx/w
		for _, n := range [4][2]int{{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}} {
			nx, ny := n[0], n[1]
			if nx < 0 || ny < 0 || nx >= w || ny >= h {
				continue
			}
			nidx := ny*w + nx
			if !isBg[nidx] && claimable(nidx) {
				isBg[nidx] = true
				queue = append(queue, nidx)
			}
		}
	}
	return isBg
}

// bandClusters samples concentric rings inset from the border (bandRingInsets
// of the smaller dimension) and clusters their opaque pixels. Rings well inside
// the frame see a framed background's true center colors; the sprite itself
// covers too small a share of the rings to pass the cluster share filter.
func bandClusters(img *image.NRGBA) []bgCluster {
	b := img.Bounds()
	w, h := b.Dx(), b.Dy()
	minDim := w
	if h < minDim {
		minDim = h
	}

	var clusters []bgCluster
	total := 0
	add := func(x, y int) {
		px := img.Pix[(y*w+x)*4:]
		if px[3] <= 16 {
			return
		}
		total++
		clusters = addToClusters(clusters, px[0], px[1], px[2])
	}

	for _, frac := range bandRingInsets {
		in := int(frac * float64(minDim))
		if in*2 >= w || in*2 >= h {
			continue
		}
		for x := in; x < w-in; x++ {
			add(x, in)
			add(x, h-1-in)
		}
		for y := in + 1; y < h-1-in; y++ {
			add(in, y)
			add(w-1-in, y)
		}
	}

	kept := clusters[:0]
	for _, c := range clusters {
		if float64(c.count) >= clusterMinShare*float64(total) {
			kept = append(kept, c)
		}
	}
	return kept
}

// opaqueRemaining reports the fraction of all pixels that are opaque and not
// claimed as background.
func opaqueRemaining(img *image.NRGBA, isBg []bool) float64 {
	n := len(isBg)
	if n == 0 {
		return 0
	}
	remaining := 0
	for i := 0; i < n; i++ {
		if !isBg[i] && img.Pix[i*4+3] > 16 {
			remaining++
		}
	}
	return float64(remaining) / float64(n)
}

func countTrue(mask []bool) int {
	n := 0
	for _, v := range mask {
		if v {
			n++
		}
	}
	return n
}

// clearPockets removes enclosed regions the border fill could not reach that
// are large, contiguous and strictly background-colored (e.g. the inside of a
// line-art ship drawn on a solid background).
func clearPockets(img *image.NRGBA, isBg []bool, model *bgModel, strict float64, w, h int) {
	minArea := int(pocketMinAreaFrac * float64(w*h))
	if minArea < 4 {
		minArea = 4
	}
	seen := make([]bool, w*h)
	comp := make([]int, 0, 256)

	for start := 0; start < w*h; start++ {
		if seen[start] || isBg[start] {
			continue
		}
		px := img.Pix[start*4:]
		if px[3] <= 16 || model.dist(px[0], px[1], px[2]) >= strict {
			continue
		}
		// BFS the strictly-background-colored component.
		comp = comp[:0]
		seen[start] = true
		comp = append(comp, start)
		for head := 0; head < len(comp); head++ {
			idx := comp[head]
			x, y := idx%w, idx/w
			for _, n := range [4][2]int{{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}} {
				nx, ny := n[0], n[1]
				if nx < 0 || ny < 0 || nx >= w || ny >= h {
					continue
				}
				nidx := ny*w + nx
				if seen[nidx] || isBg[nidx] {
					continue
				}
				npx := img.Pix[nidx*4:]
				if npx[3] <= 16 || model.dist(npx[0], npx[1], npx[2]) >= strict {
					continue
				}
				seen[nidx] = true
				comp = append(comp, nidx)
			}
		}
		if len(comp) >= minArea {
			for _, idx := range comp {
				isBg[idx] = true
			}
		}
	}
}

// despeckle clears small isolated islands of surviving pixels whose mean color
// is still close to the background model — residual noise from textured
// backgrounds that individually exceeded the fill threshold.
func despeckle(img *image.NRGBA, isBg []bool, model *bgModel, maxDist float64, w, h int) {
	maxArea := int(speckleMaxAreaFrac * float64(w*h))
	if maxArea < 9 {
		maxArea = 9
	}
	seen := make([]bool, w*h)
	comp := make([]int, 0, 256)

	for start := 0; start < w*h; start++ {
		if seen[start] || isBg[start] {
			continue
		}
		if img.Pix[start*4+3] <= 16 {
			continue
		}
		comp = comp[:0]
		seen[start] = true
		comp = append(comp, start)
		var distSum float64
		tooBig := false
		for head := 0; head < len(comp); head++ {
			idx := comp[head]
			px := img.Pix[idx*4:]
			distSum += model.dist(px[0], px[1], px[2])
			x, y := idx%w, idx/w
			for _, n := range [4][2]int{{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}} {
				nx, ny := n[0], n[1]
				if nx < 0 || ny < 0 || nx >= w || ny >= h {
					continue
				}
				nidx := ny*w + nx
				if seen[nidx] || isBg[nidx] || img.Pix[nidx*4+3] <= 16 {
					continue
				}
				seen[nidx] = true
				comp = append(comp, nidx)
			}
			if len(comp) > maxArea {
				tooBig = true
				// Keep flooding to mark the whole component as seen, but it
				// can no longer qualify for removal.
			}
		}
		if !tooBig && distSum/float64(len(comp)) < maxDist {
			for _, idx := range comp {
				isBg[idx] = true
			}
		}
	}
}

// borderClusters builds the background color model from all opaque border
// pixels via greedy online clustering, keeping only dominant clusters.
func borderClusters(img *image.NRGBA) []bgCluster {
	b := img.Bounds()
	w, h := b.Dx(), b.Dy()
	var clusters []bgCluster
	total := 0

	add := func(x, y int) {
		px := img.Pix[(y*w+x)*4:]
		if px[3] <= 16 {
			return
		}
		total++
		clusters = addToClusters(clusters, px[0], px[1], px[2])
	}

	for x := 0; x < w; x++ {
		add(x, 0)
		add(x, h-1)
	}
	for y := 1; y < h-1; y++ {
		add(0, y)
		add(w-1, y)
	}

	kept := clusters[:0]
	for _, c := range clusters {
		if float64(c.count) >= clusterMinShare*float64(total) {
			kept = append(kept, c)
		}
	}
	return kept
}

// enrichClusters extends the model's clusters with everything the fill claimed,
// so later passes know about background colors the border model missed. Claimed
// pixels are subsampled for speed.
func enrichClusters(img *image.NRGBA, isBg []bool, base []bgCluster) []bgCluster {
	clusters := append([]bgCluster(nil), base...)
	for idx := 0; idx < len(isBg); idx += 3 {
		if !isBg[idx] {
			continue
		}
		px := img.Pix[idx*4:]
		if px[3] <= 16 {
			continue
		}
		clusters = addToClusters(clusters, px[0], px[1], px[2])
	}
	return clusters
}

func addToClusters(clusters []bgCluster, r, g, b uint8) []bgCluster {
	rf, gf, bf := float64(r), float64(g), float64(b)
	for i := range clusters {
		c := &clusters[i]
		if euclid(rf-c.r, gf-c.g, bf-c.b) < clusterJoinDist {
			n := float64(c.count)
			c.r = (c.r*n + rf) / (n + 1)
			c.g = (c.g*n + gf) / (n + 1)
			c.b = (c.b*n + bf) / (n + 1)
			c.count++
			return clusters
		}
	}
	return append(clusters, bgCluster{r: rf, g: gf, b: bf, count: 1})
}

func touchesBg(isBg []bool, x, y, w, h int) bool {
	for dy := -1; dy <= 1; dy++ {
		for dx := -1; dx <= 1; dx++ {
			if dx == 0 && dy == 0 {
				continue
			}
			nx, ny := x+dx, y+dy
			if nx < 0 || ny < 0 || nx >= w || ny >= h {
				continue
			}
			if isBg[ny*w+nx] {
				return true
			}
		}
	}
	return false
}

// BorderOpaqueFraction reports the fraction of border pixels with alpha > 16.
// A properly keyed sprite has a mostly transparent border; a value near 1 means
// the background is baked in.
func BorderOpaqueFraction(src image.Image) float64 {
	return RingOpaqueFraction(src, 0)
}

// RingOpaqueFraction reports the fraction of pixels with alpha > 16 on a
// rectangular ring inset from the border by insetFrac of the smaller image
// dimension. Checking a slightly inset ring in addition to the border itself
// catches sprites where an earlier chroma key cleared only a thin outer rim of
// an otherwise baked-in background.
func RingOpaqueFraction(src image.Image, insetFrac float64) float64 {
	b := src.Bounds()
	w, h := b.Dx(), b.Dy()
	if w == 0 || h == 0 {
		return 0
	}
	minDim := w
	if h < minDim {
		minDim = h
	}
	in := int(insetFrac * float64(minDim))
	if in*2 >= w || in*2 >= h {
		return 0
	}
	opaque, total := 0, 0
	check := func(x, y int) {
		total++
		_, _, _, a := src.At(b.Min.X+x, b.Min.Y+y).RGBA()
		if uint8(a>>8) > 16 {
			opaque++
		}
	}
	for x := in; x < w-in; x++ {
		check(x, in)
		check(x, h-1-in)
	}
	for y := in + 1; y < h-1-in; y++ {
		check(in, y)
		check(w-1-in, y)
	}
	return float64(opaque) / float64(total)
}
