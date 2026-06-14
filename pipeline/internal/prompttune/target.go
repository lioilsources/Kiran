// Package prompttune drives the iterative prompt-tuning loop for Kiran game
// assets:
//
//	generate (ComfyUI) → validate (vision LLM) → refine (instruct LLM) → repeat
//
// Each asset is tuned independently. The loop stops when the validator score
// crosses a threshold or the iteration cap is hit. The winning prompt is saved
// to a YAML sidecar so the main orchestrator can use it instead of the
// template-rendered default.
package prompttune

import "strings"

// Target describes what a generated game sprite must depict and satisfy.
// It grounds both the validator (what to check) and the builder (what to keep
// the prompt about).
type Target struct {
	AssetType string   // "structure", "ship", "enemy", "bullet", ...
	AssetName string   // "asteroid", "falcon", "laser", ...
	Directive string   // per-asset description, e.g. "large rocky asteroid, cratered surface"
	SkinStyle string   // skin's StyleKeywords / PonyStyleKeywords
	Workflow  string   // "pony" or "" (flux)
	Avoid     []string // things to keep out of the image
}

// Describe renders the target as a compact human/LLM-readable brief.
func (t Target) Describe() string {
	var sb strings.Builder
	sb.WriteString("Asset type: ")
	sb.WriteString(t.AssetType)
	sb.WriteString("\nAsset name: ")
	sb.WriteString(t.AssetName)
	sb.WriteString("\nDirective: ")
	sb.WriteString(t.Directive)
	if t.SkinStyle != "" {
		sb.WriteString("\nVisual style: ")
		sb.WriteString(t.SkinStyle)
	}
	sb.WriteString("\nRequired constraints:\n")
	for _, c := range spriteConstraints(t.AssetType) {
		sb.WriteString("- ")
		sb.WriteString(c)
		sb.WriteString("\n")
	}
	if len(t.Avoid) > 0 {
		sb.WriteString("Must avoid: ")
		sb.WriteString(strings.Join(t.Avoid, ", "))
		sb.WriteString("\n")
	}
	return sb.String()
}

// spriteConstraints returns the game-specific requirements for an asset type.
func spriteConstraints(assetType string) []string {
	base := []string{
		"flat, uniform solid-color background (required for background removal in post-process)",
		"no text, no UI elements, no watermarks",
	}
	switch assetType {
	case "ship":
		return append(base,
			"strict 90-degree top-down orthographic view — camera looks straight down, no perspective, no tilt",
			"nose of the ship points to the TOP edge of the image",
			"single ship only, centered, filling the frame edge-to-edge",
		)
	case "enemy":
		return append(base,
			"strict 90-degree top-down orthographic view — camera looks straight down, no perspective, no tilt",
			"nose of the ship points to the BOTTOM edge of the image",
			"single craft only, centered, filling the frame edge-to-edge",
		)
	case "structure":
		return append(base,
			"top-down view, irregular natural shape",
			"centered and filling the frame edge-to-edge",
			"no propulsion or weapons visible",
		)
	case "bullet":
		return append(base,
			"single projectile, centered, pointing STRAIGHT UP — perfectly vertical, zero rotation",
		)
	case "explosion":
		return append(base,
			"8 frames in a single horizontal row on one image",
			"each frame the same width, animation progresses left to right",
		)
	case "background":
		return append(base[:1], // background: no solid-color constraint
			"seamless vertical tiling — top and bottom edges must match",
			"no ships, no UI, purely atmospheric",
		)
	default:
		return base
	}
}
