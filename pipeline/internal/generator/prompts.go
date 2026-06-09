package generator

import (
	"bytes"
	"fmt"
	"text/template"

	"tyrian-pipeline/internal/skin"
)

var promptTemplates = map[string]string{
	"ship": `{{.ArtDirective}}
A single player spacecraft viewed from DIRECTLY OVERHEAD — strict 90-degree top-down orthographic view, zero perspective, zero tilt, zero isometric angle. The camera looks straight down at the hull; the nose points to the top edge of the image. No foreshortening, no 3D angle, no diagonal viewpoint.
Sprite sheet of 4 animation frames laid out in one horizontal row of equal square cells; across the frames the ship banks from a hard left tilt, through level, to a hard right tilt. In all frames the fuselage axis stays vertical (nose up, engines down); only the wing roll changes.
The SAME ship in every frame, drawn large and highly detailed, filling its square cell edge-to-edge with only a few pixels of margin — never small or distant.
Roughly square overall proportions per frame.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Clean silhouette, sharp readable details, no background elements, no text, no UI.
The background must be a single flat solid color, no gradient, no scene, clearly distinct from the sprite.`,

	"explosion": `Explosion animation sprite sheet, 8 frames horizontal row on a flat, uniform solid-color background.
Style: {{.StyleKeywords}}. {{.ExplosionStyle}}
Starts small bright flash, expands outward, fades to particles/smoke.
Each frame {{.SpriteSize}}px wide. No text, no UI. Single flat solid-color background, no gradient, no scene.`,

	"bullet": `Game projectile sprite on a flat, uniform solid-color background.
{{.BulletDirective}}
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Single projectile, centered, facing upward. No text, no UI. Single flat solid-color background, no gradient, no scene.`,

	"background": `Seamless tileable space background, vertical scrolling game.
Layer: {{.LayerDesc}}.
Style: {{.StyleKeywords}}. Color mood: {{.BackgroundMood}}.
Must tile seamlessly vertically. No ships, no UI, purely atmospheric.
Wide landscape format 1024x2048px.`,

	"hud_icon": `Game HUD icon: {{.IconType}}. Style: {{.StyleKeywords}}.
Pixel art, 32x32 pixels, on a flat, uniform solid-color background.
Clear readable shape at small size. Color: {{.PaletteDescription}}.
No text, centered. Single flat solid-color background, no gradient, no scene.`,

	"enemy": `{{.ArtDirective}}
Enemy spacecraft viewed from DIRECTLY OVERHEAD — strict 90-degree top-down orthographic view, zero perspective, zero tilt, zero isometric angle. The camera looks straight down at the hull; the nose points to the BOTTOM edge of the image (descending toward the player). No foreshortening, no 3D angle, no diagonal viewpoint.
{{.EnemyDirective}}.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Menacing hostile design. A single craft drawn large and highly detailed, centered and filling the frame edge-to-edge with only a few pixels of margin — never small or distant.
Roughly square overall proportions. Sharp readable details. No text, no UI. Single flat solid-color background, no gradient, no scene.`,

	"structure": `Top-down space obstacle/debris: {{.StructureDirective}}.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Irregular natural shape, no propulsion or weapons visible.
Drawn large and detailed, centered and filling the frame edge-to-edge with only a few pixels of margin. No text, no UI, no gradient, no scene.`,

	"preview": `Game skin preview image showing the overall visual theme.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Show a representative scene: spacecraft, stars, projectiles in this art style.
Atmospheric, eye-catching thumbnail for a selection screen. No text overlay.`,
}

var compiledTemplates = make(map[string]*template.Template)

// ponyQuality is the Pony Diffusion V6 XL conditioning prefix. Pony is a
// Danbooru/e621 tag-trained SDXL model: it responds to comma-separated tags, the
// full score ladder, and — most importantly — source_/rating_ steering tags.
// Without a source_ tag Pony falls back to its dominant prior (anime characters),
// which is why plain descriptive prompts produced character-like junk. We target
// a stylized anime/cartoon look on purpose, leaning into Pony's strength.
const ponyQuality = "score_9, score_8_up, score_7_up, score_6_up, score_5_up, source_anime, rating_safe, anime style, cel shaded, vibrant"

// ponyPromptTemplates mirrors promptTemplates but is rewritten tag-first for Pony
// SDXL: full score ladder + source_anime/rating_safe steering, comma-separated
// tags instead of prose, so Pony actually parses the intent. The per-skin
// {{.StyleKeywords}}/{{.PaletteDescription}} values are kept as theme/color tags.
var ponyPromptTemplates = map[string]string{
	"ship": ponyQuality + `, {{.ArtDirective}}
overhead view, bird's eye view, directly above, orthographic top-down, no perspective, no isometric, no diagonal angle, player spaceship, vehicle, nose pointing up toward top edge, fuselage vertical, sprite sheet, 4 frames in one horizontal row, banking left to right, same ship in every frame,
detailed mecha design, sharp clean lineart, large, centered, fills each cell,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid color background, no text, no UI, no humans, no characters`,

	"explosion": ponyQuality + `, anime style explosion effect, sprite sheet, 8 frames in one horizontal row, flat solid background,
{{.StyleKeywords}}, {{.ExplosionStyle}},
bright flash expanding outward to particles and smoke, dynamic energetic, no text, no UI`,

	"bullet": ponyQuality + `, anime style game projectile, glowing energy bolt,
{{.BulletDirective}},
{{.StyleKeywords}}, {{.PaletteDescription}},
single projectile, centered, pointing up, flat solid background, no text, no UI`,

	"background": ponyQuality + `, anime style space background, vertical scrolling shooter background, seamless vertical tile,
{{.LayerDesc}},
{{.StyleKeywords}}, {{.BackgroundMood}},
atmospheric, no ships, no characters, no UI, wide landscape format`,

	"hud_icon": ponyQuality + `, anime style game HUD icon, {{.IconType}}, simple bold readable shape,
{{.StyleKeywords}}, {{.PaletteDescription}},
small icon, centered, flat solid background, no text`,

	"enemy": ponyQuality + `, {{.ArtDirective}}
overhead view, bird's eye view, directly above, orthographic top-down, no perspective, no isometric, no diagonal angle, enemy spaceship, vehicle, {{.EnemyDirective}}, nose pointing down toward bottom edge, fuselage vertical,
menacing mecha design, detailed, sharp clean lineart, large, centered, fills frame,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid background, no text, no UI, no humans, no characters`,

	"structure": ponyQuality + `, anime style top-down space obstacle, {{.StructureDirective}},
irregular natural shape, no propulsion, no weapons, detailed, centered, fills frame,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid background, no text, no UI`,

	"preview": ponyQuality + `, anime style game skin key visual, splash art,
{{.StyleKeywords}}, {{.PaletteDescription}},
spaceship, stars, projectiles, dynamic action scene, eye-catching thumbnail, no text overlay`,
}

var compiledPonyTemplates = make(map[string]*template.Template)

func init() {
	for name, tmplStr := range promptTemplates {
		t, err := template.New(name).Parse(tmplStr)
		if err != nil {
			panic(fmt.Sprintf("failed to parse template %q: %v", name, err))
		}
		compiledTemplates[name] = t
	}
	for name, tmplStr := range ponyPromptTemplates {
		t, err := template.New(name).Parse(tmplStr)
		if err != nil {
			panic(fmt.Sprintf("failed to parse pony template %q: %v", name, err))
		}
		compiledPonyTemplates[name] = t
	}
}

// BuildPromptForWorkflow renders a prompt for the given asset type, skin and workflow style.
// workflow "" or "flux" uses the standard Flux templates; "pony" uses Pony SDXL templates.
func BuildPromptForWorkflow(assetType string, s skin.SkinDef, extra map[string]string, workflow string) (string, error) {
	templates := compiledTemplates
	if workflow == "pony" {
		templates = compiledPonyTemplates
	}
	tmpl, ok := templates[assetType]
	if !ok {
		return "", fmt.Errorf("unknown asset type %q", assetType)
	}

	data := map[string]interface{}{
		"ArtDirective":       s.ArtDirective,
		"StyleKeywords":      s.StyleKeywords,
		"PaletteDescription": s.PaletteDescription,
		"BackgroundMood":     s.BackgroundMood,
		"ExplosionStyle":     s.ExplosionStyle,
		"BulletDirective":    s.BulletDirective,
		"SpriteSize":         s.SpriteSize,
		"FrameCount":         s.FrameCount,
	}
	for k, v := range extra {
		data[k] = v
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return "", fmt.Errorf("execute template %q: %w", assetType, err)
	}
	return buf.String(), nil
}

// BuildPrompt renders a prompt template for the given asset type and skin using the default (Flux) style.
// extra can supply additional template variables (e.g. LayerDesc, IconType).
func BuildPrompt(assetType string, s skin.SkinDef, extra map[string]string) (string, error) {
	return BuildPromptForWorkflow(assetType, s, extra, "")
}
