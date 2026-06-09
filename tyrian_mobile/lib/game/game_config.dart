/// All game constants ported from Module.bas lines 4-36 and other sources.
/// Frame-based values are converted to time-based where needed.
library;

import 'dart:ui' show Color, FilterQuality;

const double frameDelay = 25.0; // ms per frame at original 40fps
const double originalFps = 1000.0 / frameDelay; // 40 fps
const int starCount = 1000;
const int ccColorCount = 12;
const double pi = 3.14159265359;
const int maxWeapLevel = 25;
const int explosionSteps = 15;
const int explosionVariants = 4;

// Original VBA screen dimensions
const double scrWidth = 600.0;
const double scrHeight = 832.0;
const double osdWidth = 280.0;

// Logical game resolution (play area only)
const double gameWidth = scrWidth;
double gameHeight = scrHeight; // mutable, set at runtime for device aspect ratio

// Font style flags (from VBA)
const int fontBold = 1;
const int fontUnderlined = 2;
const int fontItalic = 4;
const int fontStrikeout = 8;

// Mouse button flags
const int mbLeft = 1;
const int mbMiddle = 2;
const int mbRight = 4;

// File names
const String stateFileName = 'state.json';

// Sprite supersampling factor. Atlas sprites are generated at this multiple of
// their original (VB6) reference resolution; spriteScale is divided by the same
// factor so the on-screen size is unchanged but the texture carries N× detail.
// 1.0 reproduces the original behaviour exactly (and matches the atlases
// currently committed). To run the detail experiment, set this to e.g. 3.0 AND
// set SupersampleFactor in pipeline/internal/postprocess/reference_sizes.go to
// the SAME value, then regenerate:
//   cd pipeline && go run ./cmd/postprocess
//   cd tyrian_mobile && dart run tool/pack_atlas.dart
// See SUPERSAMPLE_EXPERIMENT.md at the repo root.
const double spriteSupersample = 4.0;

// Sprite scale factor to match original VBA proportions (VBA SIZE_UNIT ~0.0378).
// Divided by spriteSupersample so supersampled atlases keep the same in-game size.
const double spriteScale = 0.74 / spriteSupersample;

// Texture filtering for gameplay sprite batches. Set per-skin at load time
// (AssetLibrary): smooth (medium) filtering only helps when sprites are
// supersampled and the skin is not pixel-art; otherwise nearest-neighbour is
// kept so retro skins stay crisp and factor-1.0 behaviour is unchanged.
FilterQuality spriteFilterQuality = FilterQuality.none;

// Collectable icon size
const double iconWidth = 70.0;
const double iconHeight = 70.0;

// Sector delay
const double delayOnComplete = 2.0; // seconds

// Structure fall speed (original: 0.05 per frame)
const double structureFallSpeed = 0.05 * originalFps; // per second

// Vessel defaults
const double vesselDefaultSpeed = 0.2;

// Weapon upgrade formulas
const double upgDamageMultiplier = 1.1;
const double upgPwrNeedMultiplier = 1.2;
const double upgCooldownDivisor = 1.02;
const double upgPwrGenMultiplier = 1.255;
const double upgGenMaxMultiplier = 1.2;

// Entity glow halo colors — color-coded by danger tier
// Full alpha: BlurStyle.outer spreads the color outward; alpha = peak glow intensity.
const Color vesselGlowColor    = Color(0xFF00FFEE); // cyan
const Color hostileGlowL1      = Color(0xFF44FF44); // green  (collision dmg 1–2)
const Color hostileGlowL2      = Color(0xFFFFEE00); // yellow (collision dmg 3–6)
const Color hostileGlowL3      = Color(0xFFFF8800); // orange (collision dmg 7–12)
const Color hostileGlowL4      = Color(0xFFFF2200); // red    (collision dmg 13–18)
const Color hostileGlowBoss    = Color(0xFFFF00CC); // magenta (collision dmg 19+)
const Color structureGlowColor = Color(0xCCAAAAAA); // light gray
