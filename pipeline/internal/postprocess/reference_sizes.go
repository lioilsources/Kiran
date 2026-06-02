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
var referenceSizes = map[string][2]int{
	// Player
	"vessel": {57, 42},

	// Enemies
	"falcon":   {34, 34},
	"falcon1":  {34, 34},
	"falcon2":  {34, 34},
	"falcon3":  {34, 34},
	"falcon4":  {34, 34},
	"falcon5":  {34, 34},
	"falcon6":  {34, 34},
	"falconx":  {51, 51},
	"falconx2": {51, 51},
	"falconx3": {51, 51},
	"falconxb": {61, 61},
	"falconxt": {67, 67},
	"bouncer":  {64, 71},

	// Boss
	"rododendron": {128, 128},

	// Structures / asteroids
	"asteroid":  {42, 40},
	"asteroid1": {44, 83},
	"asteroid2": {52, 75},
	"asteroid3": {37, 25},

	// Projectiles
	"vulcan":  {5, 12},
	"blaster": {42, 12},
	"laser":   {20, 20},
	"bubble":  {30, 29},

	// Background stars
	"star":  {15, 15},
	"starg": {12, 12},

	// Explosions (all four frames share the original size)
	"explosion1": {90, 90},
	"explosion2": {90, 90},
	"explosion3": {90, 90},
	"explosion4": {90, 90},
}

// ReferenceSize returns the canonical (width, height) for a game sprite name and
// whether one is defined. Sprites without a reference (UI icons, previews,
// backgrounds) should keep their plain max-dimension downscale.
func ReferenceSize(gameName string) (int, int, bool) {
	if s, ok := referenceSizes[gameName]; ok {
		return s[0], s[1], true
	}
	return 0, 0, false
}
