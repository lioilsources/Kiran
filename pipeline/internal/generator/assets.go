package generator

import (
	"fmt"

	"tyrian-pipeline/internal/skin"
)

// AssetSpec describes a single image asset to generate.
type AssetSpec struct {
	Name        string
	AssetType   string // ship, explosion, bullet, background, hud_icon, preview, enemy, structure
	OutputDir   string // relative subdirectory (sprites/, backgrounds/, ui/)
	AspectRatio string // "1:1" or "1:2"
	Resolution  string // "1k" or "2k"
	ExtraVars   map[string]string
}

var bulletSpecs = []struct{ name, directive string }{
	{"laser", "Laser beam projectile, thin vertical line with intense glow core"},
	{"bubble", "Energy bubble projectile, round glowing orb with translucent shell"},
	{"vulcan", "Rapid-fire vulcan bullet, small dense round pellet with motion trail"},
	{"blaster", "Blaster bolt, elongated energy pulse with bright leading edge"},
	{"starg", "Star-shaped projectile, spinning multi-pointed star with energy glow"},
}

// enemySpecs describe each enemy by silhouette and theme only. Absolute size and
// proportion words (small, narrow, wide, bulky, large, oversized) are deliberately
// avoided: every enemy is normalized to a uniform square reference footprint in
// postprocess, so non-square art would just get letterboxed and render small.
var enemySpecs = []struct{ name, directive string }{
	{"falcon", "standard fighter, angular wings"},
	{"falcon1", "scout fighter, swept-back wings"},
	{"falcon2", "armored interceptor, reinforced hull plates"},
	{"falcon3", "bomber variant, visible weapon pods"},
	{"falcon4", "stealth fighter, dark angular paneling"},
	{"falcon5", "assault craft, twin engine pods"},
	{"falcon6", "elite fighter, ornate markings, advanced design"},
	{"falconx", "experimental prototype, unusual geometry, glowing accents"},
	{"falconx2", "experimental mark III, tri-wing layout, plasma conduits"},
	{"falconx3", "experimental mark IV, heavily armed, prominent cannons"},
	{"falconxb", "experimental command vessel, ornate heavy detailing"},
	{"falconxt", "experimental turret carrier, rotating weapon platform"},
	{"bouncer", "agile drone, spherical body, unpredictable movement design"},
	{"rododendron", "boss dreadnought, layered armor plating, dominating silhouette, ornate command superstructure"},
}

var structureSpecs = []struct{ name, directive string }{
	{"asteroid", "large rocky asteroid, cratered surface, irregular shape"},
	{"asteroid1", "medium asteroid fragment, jagged edges, mineral veins"},
	{"asteroid2", "small asteroid chunk, rough texture, tumbling debris"},
	{"asteroid3", "tiny asteroid shard, sharp angular fragment"},
}

// backgroundLayers describe the four parallax planes. The layerDesc for
// layers 1-3 asks for a flat black backdrop because postprocess derives their
// alpha with a corner-sampled chroma key (postprocess/bgremove.go) — the
// cleaner the separation from black, the cleaner the alpha and the smaller the
// encoded alpha plane.
//
// perZone layers are generated once per entry in backgroundZones; the rest are
// generated once per skin and reused across every zone. layer_0 and layer_1
// carry the colour, so they are the two worth varying.
var backgroundLayers = []struct {
	name      string
	layerDesc string
	perZone   bool
}{
	{"layer_0", "the sky/void itself — the opaque base plate, fills the entire frame edge to edge with no gaps, furthest away, low detail, soft and unfocused", true},
	{"layer_1", "mid-distance atmosphere — translucent cloud banks, gas and haze forms isolated on a flat pure black background, soft feathered edges, clear separation between the forms and the black", true},
	{"layer_2", "mid-detail particulate — scattered small motes, dust and specks isolated on a flat pure black background, moderate even density", false},
	{"layer_3", "foreground pass — larger near objects, debris chunks and fragments isolated on a flat pure black background, sparse, high contrast against the black", false},
}

// backgroundZones mirror the seven hand-scripted sectors in
// tyrian_mobile/lib/systems/sector.dart (System Perimeter .. Unknown Space).
// The zone index is the game's currentSectorIndex; sectors past the last zone
// clamp to it and keep escalating through a runtime tint instead. The count
// must stay in sync with BgZones.count in tyrian_mobile/lib/rendering/bg_zones.dart.
//
// zoneDesc is deliberately domain-neutral ("territory", "large body",
// "surface" rather than "space", "planet", "orbit") so one table serves skins
// that are not set in space at all — river_raid's river valley, luftrausers'
// wartime sky. The domain word comes from the skin's SceneNoun instead.
//
// dangerMood is a *shift* of the skin's own BackgroundMood, never a replacement
// palette: that is what lets the danger ramp escalate without erasing the skin's
// identity. It climbs on three axes at once — temperature (indigo -> teal ->
// amber -> orange -> red -> crimson), saturation and density.
var backgroundZones = []struct {
	zoneDesc   string
	dangerMood string
}{
	{
		"the outermost frontier of the territory, far from everything, almost empty — a vast open expanse, a few tiny distant landmarks, nothing threatening in sight",
		"hold the base palette at its coldest and calmest — desaturated, dim, low contrast, large areas of empty darkness, nothing glowing",
	},
	{
		"further inside the territory, lightly travelled — scattered mining debris and drifting rubble, the first signs the place is used",
		"the base palette barely shifted — still cool, a first faint highlight, density and contrast one notch up",
	},
	{
		"the outer boundary of a huge body — its curved edge entering the frame, a boundary ring or shoreline crossing the scene, a thin haze layer where the open expanse meets the body",
		"cool the base palette toward green-teal, with the first warm accent on the boundary line, moderate contrast, distance softened by haze",
	},
	{
		"a contested patrol corridor above the surface — a defence grid, marker beacons, sweeping searchlight cones from below, geometric perimeter markings on the ground",
		"shift the base palette warmer — alert amber and gold cutting into the cold shadows, hard-edged pools of light, contrast clearly raised",
	},
	{
		"skimming low and fast over the body — the surface fills the frame, defence platforms and the terminator line between lit and unlit ground, upper atmosphere burning past",
		"push the base palette hot — strong orange rim light against deep shadow, high saturation, dramatic directional light, a sense of speed",
	},
	{
		"a heavy industrial region — refinery stacks, molten channels, slag heaps and pipe runs, thick pollution haze, drifting embers and smoke",
		"push the base palette into burning red-orange and toxic yellow-green through black smoke, heavy saturation, harsh contrast, glowing hot spots, dirty and oppressive",
	},
	{
		"unmapped hostile territory — nothing here matches the charts, wrong geometry, torn voids and structures that should not exist, an anomaly bleeding light",
		"push the base palette to its most aggressive — malignant crimson and violet-magenta against near-black, extreme saturation and contrast, colours that read as wrong and hostile, dense, almost no calm space left",
	},
}

// Fillers for the shared layers, which are reused under every zone and so must
// commit to none of them.
const (
	sharedZoneDesc   = "generic mid-territory, no distinctive landmarks — ambient detail that must sit believably over any sector of this setting"
	sharedDangerMood = "the base palette held neutral, mid-tone, no strong colour cast — must read over both cold and hot backdrops"
)

// AssetsForSkin returns all asset specs needed for a given skin.
func AssetsForSkin(s skin.SkinDef) []AssetSpec {
	specs := make([]AssetSpec, 0, 48)

	// Ship: ONE craft on a square canvas. The N animation frames are synthesized
	// in postprocess by glow modulation — generating multi-frame strips in one
	// image is unreliable (models can't count cells or keep silhouettes identical).
	specs = append(specs, AssetSpec{
		Name:        "ship_frames",
		AssetType:   "ship",
		OutputDir:   "sprites",
		AspectRatio: "1:1",
		Resolution:  "1k",
	})

	// Explosion
	specs = append(specs, AssetSpec{
		Name:        "explosion",
		AssetType:   "explosion",
		OutputDir:   "sprites",
		AspectRatio: "1:1",
		Resolution:  "1k",
	})

	// Projectiles (match game imgNames)
	for _, b := range bulletSpecs {
		specs = append(specs, AssetSpec{
			Name:        b.name,
			AssetType:   "bullet",
			OutputDir:   "sprites",
			AspectRatio: "1:1",
			Resolution:  "1k",
			ExtraVars:   map[string]string{"BulletDirective": b.directive},
		})
	}

	// Enemies
	for _, e := range enemySpecs {
		specs = append(specs, AssetSpec{
			Name:        e.name,
			AssetType:   "enemy",
			OutputDir:   "sprites",
			AspectRatio: "1:1",
			Resolution:  "1k",
			ExtraVars:   map[string]string{"EnemyDirective": e.directive},
		})
	}

	// Structures
	for _, st := range structureSpecs {
		specs = append(specs, AssetSpec{
			Name:        st.name,
			AssetType:   "structure",
			OutputDir:   "sprites",
			AspectRatio: "1:1",
			Resolution:  "1k",
			ExtraVars:   map[string]string{"StructureDirective": st.directive},
		})
	}

	// Background layers. Per-zone layers get a "_z<N>" suffix on the asset name;
	// that name is what the orchestrator, the manifest and postprocess all key
	// on, so the zone dimension propagates end to end without a new field.
	for _, layer := range backgroundLayers {
		bg := func(name, zoneDesc, dangerMood string) AssetSpec {
			return AssetSpec{
				Name:        name,
				AssetType:   "background",
				OutputDir:   "backgrounds",
				AspectRatio: "1:2",
				Resolution:  "2k",
				ExtraVars: map[string]string{
					"LayerDesc":  layer.layerDesc,
					"ZoneDesc":   zoneDesc,
					"DangerMood": dangerMood,
				},
			}
		}
		if !layer.perZone {
			specs = append(specs, bg(layer.name, sharedZoneDesc, sharedDangerMood))
			continue
		}
		for z, zone := range backgroundZones {
			specs = append(specs, bg(
				fmt.Sprintf("%s_z%d", layer.name, z), zone.zoneDesc, zone.dangerMood))
		}
	}

	// HUD icons
	for _, icon := range []struct{ name, desc string }{
		{"icon_life", "extra life heart or ship silhouette"},
		{"icon_bomb", "bomb or special weapon explosive"},
		{"icon_shield", "shield or protective barrier"},
		{"icon_credit", "coin or credit currency symbol, money bonus"},
		{"icon_gen", "energy generator or power core, lightning bolt or reactor symbol"},
	} {
		specs = append(specs, AssetSpec{
			Name:        icon.name,
			AssetType:   "hud_icon",
			OutputDir:   "ui",
			AspectRatio: "1:1",
			Resolution:  "1k",
			ExtraVars:   map[string]string{"IconType": icon.desc},
		})
	}

	// Preview
	specs = append(specs, AssetSpec{
		Name:        "preview",
		AssetType:   "preview",
		OutputDir:   "ui",
		AspectRatio: "1:1",
		Resolution:  "1k",
	})

	// ComCenter UI assets — skin-themed background and interactive panel sprites
	specs = append(specs, AssetSpec{
		Name:        "comcenter_bg",
		AssetType:   "comcenter_bg",
		OutputDir:   "ui",
		AspectRatio: "1:2",
		Resolution:  "2k",
	})
	for _, uiSpec := range []struct{ name, assetType, aspect string }{
		{"ui_card_bg",    "ui_card_bg",    "1:1"},
		{"ui_button",     "ui_button",     "4:1"},
		{"ui_tab_active", "ui_tab_active", "4:1"},
	} {
		specs = append(specs, AssetSpec{
			Name:        uiSpec.name,
			AssetType:   uiSpec.assetType,
			OutputDir:   "ui",
			AspectRatio: uiSpec.aspect,
			Resolution:  "1k",
		})
	}

	return specs
}
