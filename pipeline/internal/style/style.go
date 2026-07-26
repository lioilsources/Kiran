// Package style defines paint-style presets for the flux2pony img2img restyle
// pass. A preset supplies the positive/negative prompt fragments and default
// denoise strength used when repainting an existing flux image through the Pony
// SDXL model. flux2pony is style-agnostic: watercolor is the first preset, oil
// and others can be added to Registry without touching the command or client.
package style

import "sort"

// Preset describes one paint style for the img2img restyle pass.
type Preset struct {
	ID   string // registry key, e.g. "watercolor"
	Name string // human-readable display name, e.g. "Watercolor"

	// Positive is prepended to the per-asset subject prompt so the Pony pass
	// repaints in this medium while keeping the subject from the base image.
	Positive string
	// Negative is appended to the Pony quality-negative baseline.
	Negative string
	// Denoise is the default KSampler denoise (0..1). Lower keeps more of the
	// flux base structure; higher repaints more freely. Overridable per run.
	Denoise float64

	// Game-side hints for the resulting <src>_<style> skin (used in the manifest).
	GoogleFont  string // UI font that suits the medium
	PostProcess string // shader effect id (matches skin.PostProcessEffect)
}

// Registry holds all known paint-style presets keyed by ID.
var Registry = map[string]Preset{
	"watercolor": {
		ID:   "watercolor",
		Name: "Watercolor",
		Positive: "watercolor painting, traditional watercolor illustration, soft wet-on-wet washes, " +
			"luminous translucent pigments, soft feathered edges, visible cold-press paper grain, " +
			"hand-painted brushwork, gentle color bleeds, painterly, delicate",
		Negative: "hard edges, sharp crisp outlines, 3d render, photo, photorealistic, " +
			"digital vector, flat solid fill, harsh lines, plastic shading",
		Denoise:     0.55,
		GoogleFont:  "Caveat",
		PostProcess: "bloom",
	},
	"oil": {
		ID:   "oil",
		Name: "Oil",
		Positive: "oil painting, traditional oil on canvas, thick impasto brushstrokes, " +
			"visible palette knife texture, rich saturated pigments, glossy layered paint, " +
			"chiaroscuro lighting, painterly, classical fine art, textured canvas weave",
		Negative: "thin washes, watercolor, flat solid fill, digital vector, 3d render, photo, " +
			"photorealistic, smooth gradient, plastic shading, clean lineart",
		Denoise:     0.58,
		GoogleFont:  "Playfair Display",
		PostProcess: "vignette",
	},
}

// Get returns the preset for id and whether it exists.
func Get(id string) (Preset, bool) {
	p, ok := Registry[id]
	return p, ok
}

// IDs returns the known style IDs in sorted order (for help text / errors).
func IDs() []string {
	ids := make([]string, 0, len(Registry))
	for id := range Registry {
		ids = append(ids, id)
	}
	sort.Strings(ids)
	return ids
}
