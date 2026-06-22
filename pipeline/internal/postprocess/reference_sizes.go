package postprocess

// referenceSizes holds the canonical sprite dimensions (width, height in px)
// taken from the original Tyrian/VB6 sprites in tyrian_vba_64bit/img, which the
// "default" skin reproduces 1:1. Every generated skin is normalized to these
// sizes so all skins render at the same in-game scale.
//
// This matters because the game derives a sprite's on-screen size from its atlas
// frame dimensions (size = srcSize * spriteScale; see game_config.dart, where
// spriteScale is the single source of truth for sizing). Without normalization,
// AI-generated sprites end up at a uniform large canvas size and every object —
// projectile, star, enemy, boss — renders at the same huge size.
//
// falcon1-6 share the base falcon size; falconx2/3 share the falconx size.

// SupersampleFactor multiplies every reference size so generated atlases retain
// more of the detail from the 1024² source images instead of being crushed to
// the tiny original sizes. It MUST equal spriteSupersample in
// tyrian_mobile/lib/game/game_config.dart: the game divides spriteScale by the
// same factor, so the on-screen size is identical while the texture carries
// factor² more texels. 1 reproduces the original (committed-atlas) behaviour.
const SupersampleFactor = 4

var referenceSizes = map[string][2]int{
	// Player
	"vessel": {114, 84},

	// Enemies
	"falcon":   {68, 68},
	"falcon1":  {68, 68},
	"falcon2":  {68, 68},
	"falcon3":  {68, 68},
	"falcon4":  {68, 68},
	"falcon5":  {68, 68},
	"falcon6":  {68, 68},
	"falconx":  {102, 102},
	"falconx2": {102, 102},
	"falconx3": {102, 102},
	"falconxb": {122, 122},
	"falconxt": {134, 134},
	"bouncer":  {128, 142},

	// Boss
	"rododendron": {256, 256},

	// Structures / asteroids
	"asteroid":  {84, 80},
	"asteroid1": {88, 166},
	"asteroid2": {104, 150},
	"asteroid3": {74, 50},

	// Projectiles
	"vulcan":  {10, 24},
	"blaster": {84, 24},
	"laser":   {40, 40},
	"bubble":  {60, 58},

	// Background stars
	"star":  {30, 30},
	"starg": {24, 24},

	// Explosions (all four frames share the original size)
	"explosion1": {180, 180},
	"explosion2": {180, 180},
	"explosion3": {180, 180},
	"explosion4": {180, 180},
}

// ReferenceSize returns the canonical (width, height) for a game sprite name and
// whether one is defined. Sprites without a reference (UI icons, previews,
// backgrounds) should keep their plain max-dimension downscale.
func ReferenceSize(gameName string) (int, int, bool) {
	if s, ok := referenceSizes[gameName]; ok {
		return s[0] * SupersampleFactor, s[1] * SupersampleFactor, true
	}
	return 0, 0, false
}

// uiSizes holds exact output dimensions for ComCenter UI sprites.
// These are NOT multiplied by SupersampleFactor — they are Flutter widget
// assets rendered at UI resolution, not game-world sprites.
var uiSizes = map[string][2]int{
	"comcenter_bg":  {512, 1024},
	"ui_card_bg":    {192, 192},
	"ui_button":     {512, 128},
	"ui_tab_active": {256, 64},
}

// UiSize returns the exact (width, height) for a ComCenter UI sprite.
func UiSize(name string) (int, int, bool) {
	if s, ok := uiSizes[name]; ok {
		return s[0], s[1], true
	}
	return 0, 0, false
}
