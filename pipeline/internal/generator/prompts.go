package generator

import (
	"bytes"
	"fmt"
	"regexp"
	"strings"
	"text/template"

	"tyrian-pipeline/internal/skin"
)

var hexCodeRe = regexp.MustCompile(`#[0-9A-Fa-f]{6}`)

// stripHexCodes removes CSS hex colour codes from s and cleans up leftover
// double-commas or extra spaces so Pony's tag parser isn't confused.
func stripHexCodes(s string) string {
	s = hexCodeRe.ReplaceAllString(s, "")
	// collapse multiple spaces
	for strings.Contains(s, "  ") {
		s = strings.ReplaceAll(s, "  ", " ")
	}
	// collapse ", ," and " ," artifacts
	for strings.Contains(s, ", ,") {
		s = strings.ReplaceAll(s, ", ,", ",")
	}
	s = strings.ReplaceAll(s, " ,", ",")
	s = strings.Trim(s, " ,")
	return s
}

var promptTemplates = map[string]string{
	"ship": `{{.ArtDirective}}
A single player spacecraft viewed from DIRECTLY OVERHEAD — strict 90-degree top-down orthographic view, zero perspective, zero tilt, zero isometric angle. The camera looks straight down at the hull; the nose points straight to the TOP edge of the image. No foreshortening, no 3D angle, no diagonal viewpoint.
ONE ship only, drawn large and highly detailed, centered, filling the frame edge-to-edge with only a few pixels of margin — never small or distant. Bright engine/thruster glow visible at the rear (bottom).
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Roughly square overall proportions. Clean silhouette, sharp readable details, no background elements, no text, no UI.
The background must be a single flat solid color, no gradient, no scene, clearly distinct from the sprite.`,

	"explosion": `Explosion animation sprite sheet, 8 frames horizontal row on a flat, uniform solid-color background.
Style: {{.StyleKeywords}}. {{.ExplosionStyle}}
Starts small bright flash, expands outward, fades to particles/smoke.
Each frame {{.SpriteSize}}px wide. No text, no UI. Single flat solid-color background, no gradient, no scene.`,

	"bullet": `Game projectile sprite on a flat, uniform solid-color background.
{{.BulletDirective}}
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Single projectile, centered, pointing STRAIGHT UP — perfectly vertical, zero diagonal, zero rotation, zero isometric angle. The projectile axis is exactly parallel to the vertical edge of the image.
No text, no UI. Single flat solid-color background, no gradient, no scene.`,

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

	"comcenter_bg": `{{.ArtDirective}}
A dramatic illustrated science fiction scene viewed from a spacecraft cockpit or space station observation deck.
Rich atmospheric composition: nebulae, distant planets, star fields, or alien landscapes in the far background.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Bold cel-shaded cartoon illustration, vibrant colors, cinematic framing.
The central area of the image must be naturally dark so that text and UI panels overlaid on top remain readable.
No text, no HUD elements, no UI widgets, no ship in foreground. Portrait aspect ratio 1:2.`,

	"ui_card_bg": `A sci-fi game inventory card panel surface texture.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Dark background panel with subtle geometric or circuit-board micro-pattern etched into the surface.
Slightly lighter beveled edges on all sides to give depth and a natural panel border.
Square format. No text, no icons, no characters. Flat opaque surface, no transparency.`,

	"ui_button": `A sci-fi game action button texture, wide horizontal format 4:1.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Dark elongated panel with a glowing accent trim along the long horizontal edges.
Subtle inner gradient from dark center to slightly lighter edges. Symmetric left-right design.
No text, no letters, no icons. Game HUD element.`,

	"ui_tab_active": `A sci-fi game navigation tab texture, wide horizontal strip 4:1.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Active selected state: a crisp glowing accent line along the top edge, panel surface slightly brighter than background.
Clean flat surface with very subtle inner highlight. No text, no icons.`,
}

var compiledTemplates = make(map[string]*template.Template)

// ponyQuality is the Pony Diffusion V6 XL conditioning prefix. Pony is a
// Danbooru/e621 tag-trained SDXL model: it responds to comma-separated tags, the
// full score ladder, and — most importantly — source_/rating_ steering tags.
// Without a source_ tag Pony falls back to its dominant prior (anime characters),
// which is why plain descriptive prompts produced character-like junk. We target
// a stylized anime/cartoon look on purpose, leaning into Pony's strength.
const ponyQuality = "score_9, score_8_up, score_7_up, score_6_up, score_5_up, source_anime, rating_safe, 2d vector art, cartoon style, cel shaded, flat shading, bold clean outlines, stylized 2d asset, vibrant colors"

// ponyPromptTemplates mirrors promptTemplates but is rewritten tag-first for Pony
// SDXL: full score ladder + source_anime/rating_safe steering, comma-separated
// tags instead of prose, so Pony actually parses the intent. The per-skin
// {{.StyleKeywords}}/{{.PaletteDescription}} values are kept as theme/color tags.
var ponyPromptTemplates = map[string]string{
	"ship": ponyQuality + `, player spaceship, vehicle,
overhead view, bird's eye view, directly above, orthographic top-down, no perspective, no isometric, no diagonal angle, solo, single ship, nose pointing straight up, fuselage vertical, glowing engine thrusters at bottom,
detailed mecha design, sharp clean lineart, large, centered, fills frame,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid color background, no text, no UI, no humans, no characters, no 3d render, no voxel`,

	"explosion": ponyQuality + `, anime style explosion effect, sprite sheet, 8 frames in one horizontal row, flat solid background,
{{.StyleKeywords}}, {{.PaletteDescription}},
classic 2d anime explosion, smoke puffs, expanding energy shockwave, cel-shaded fire fx,
bright flash expanding outward to particles and smoke, dynamic energetic, no text, no UI, no voxel, no 3d render`,

	"bullet": ponyQuality + `, anime style game projectile,
glowing energy beam, flat 2d vector pulse, core glow,
{{.StyleKeywords}}, {{.PaletteDescription}},
single projectile, centered, perfectly vertical, pointing straight up, no diagonal, no rotation, no isometric,
flat solid background, no text, no UI, no voxel, no 3d render`,

	"background": ponyQuality + `, anime style space background, vertical scrolling shooter background, seamless vertical loop,
tall composition, vertical scrolling background,
{{.LayerDesc}},
{{.StyleKeywords}}, {{.BackgroundMood}},
atmospheric, no ships, no characters, no UI`,

	"hud_icon": ponyQuality + `, anime style game HUD icon, {{.IconType}}, simple bold readable shape,
flat icon design, minimalistic vector graphic, game UI asset,
{{.StyleKeywords}}, {{.PaletteDescription}},
small icon, centered, flat solid background, no text`,

	"enemy": ponyQuality + `, enemy spaceship, vehicle, {{.EnemyDirective}},
overhead view, bird's eye view, directly above, orthographic top-down, no perspective, no isometric, no diagonal angle, nose pointing down toward bottom edge, fuselage vertical,
menacing mecha design, detailed, sharp clean lineart, large, centered, fills frame,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid background, no text, no UI, no humans, no characters, no 3d render, no voxel`,

	"structure": ponyQuality + `, anime style top-down space obstacle, {{.StructureDirective}},
irregular natural shape, no propulsion, no weapons, detailed, centered, fills frame,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat solid background, no text, no UI, no 3d render, no voxel`,

	"preview": ponyQuality + `, anime style game skin key visual, splash art,
{{.StyleKeywords}}, {{.PaletteDescription}},
spaceship, stars, projectiles, dynamic action scene, eye-catching thumbnail, no text overlay`,

	"comcenter_bg": ponyQuality + `, anime style science fiction illustration, cockpit view, space station interior,
dramatic atmospheric scene, nebulae, distant planets, alien landscape,
{{.StyleKeywords}}, {{.PaletteDescription}},
bold cel-shaded, vibrant colors, cinematic composition, dark center area for UI readability,
portrait format, no text, no HUD, no ship in foreground`,

	"ui_card_bg": ponyQuality + `, sci-fi game UI panel texture, inventory card surface,
dark background, subtle circuit board pattern, beveled edges, panel depth,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat opaque surface, square format, no text, no icons, no characters`,

	"ui_button": ponyQuality + `, sci-fi game UI button texture, wide horizontal panel 4:1,
dark elongated panel, glowing trim on edges, inner gradient,
{{.StyleKeywords}}, {{.PaletteDescription}},
symmetric design, no text, no letters, game HUD element`,

	"ui_tab_active": ponyQuality + `, sci-fi game navigation tab texture, wide horizontal strip,
active selected state, glowing top edge accent, slightly bright panel,
{{.StyleKeywords}}, {{.PaletteDescription}},
flat surface, subtle highlight, no text, no icons`,
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

	styleKeywords := s.StyleKeywords
	palette := s.PaletteDescription
	if workflow == "pony" {
		if s.PonyStyleKeywords != "" {
			styleKeywords = s.PonyStyleKeywords
		}
		if s.PonyPaletteDescription != "" {
			palette = s.PonyPaletteDescription
		} else {
			palette = stripHexCodes(palette)
		}
	}

	data := map[string]interface{}{
		"ArtDirective":       s.ArtDirective,
		"StyleKeywords":      styleKeywords,
		"PaletteDescription": palette,
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
