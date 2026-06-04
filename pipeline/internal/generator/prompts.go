package generator

import (
	"bytes"
	"fmt"
	"text/template"

	"tyrian-pipeline/internal/skin"
)

var promptTemplates = map[string]string{
	"ship": `{{.ArtDirective}}
A single player spacecraft viewed from directly above (top-down), nose pointing up.
Sprite sheet of 4 animation frames laid out in one horizontal row of equal square cells; across the frames the ship banks from a hard left tilt, through level, to a hard right tilt.
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
Top-down enemy spacecraft, {{.EnemyDirective}}.
Style: {{.StyleKeywords}}. Color palette: {{.PaletteDescription}}.
Menacing hostile design, facing downward. A single craft drawn large and highly detailed, centered and filling the frame edge-to-edge with only a few pixels of margin — never small or distant.
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

func init() {
	for name, tmplStr := range promptTemplates {
		t, err := template.New(name).Parse(tmplStr)
		if err != nil {
			panic(fmt.Sprintf("failed to parse template %q: %v", name, err))
		}
		compiledTemplates[name] = t
	}
}

// BuildPrompt renders a prompt template for the given asset type and skin.
// extra can supply additional template variables (e.g. LayerDesc, IconType).
func BuildPrompt(assetType string, s skin.SkinDef, extra map[string]string) (string, error) {
	tmpl, ok := compiledTemplates[assetType]
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
