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

// --- Immersive experiment (feature branch experiment/immersive-depth) ---
// Feature 1: camera shows only ~immersiveVisibleFraction of the play field (zoom-in)
// and pans horizontally (+ gentle vertical) to follow the vessel with a dead zone.
// Feature 2: purely visual depth pulse on hostiles + vessel (never touches `size`,
// so collisions/hitboxes are unaffected). All effects are additive and toggleable.
const bool immersiveCameraEnabled = true; // Feature 1 master toggle (portrait only)
const double immersiveVisibleFraction = 0.8; // see 80% of width → zoom = 1/0.8 = 1.25
const double immersiveDeadZoneX = 0.15; // fraction of half-window with no camera move
const double immersiveDeadZoneY = 0.30; // larger vertically (follow is primarily horizontal)
const double immersiveCameraLerp = 6.0; // camera ease speed (higher = snappier)

const bool depthPulseEnabled = true; // Feature 2 master toggle
const double hostileDepthAmplitude = 0.15; // ±15% visual scale on hostiles
const double hostileDepthPeriod = 2.6; // seconds per breath (grow→shrink)
const double vesselDepthAmplitude = 0.05; // ±5% visual scale on vessel (subtle)
const double vesselDepthPeriod = 3.2; // seconds

// Collectable icon size
const double iconWidth = 70.0;
const double iconHeight = 70.0;

// Sector delay
const double delayOnComplete = 2.0; // seconds

// How long a hostile may sit stranded outside the play field before it is
// written off. Only ever armed for enemies whose path can no longer bring them
// back (parked or cycling), so this is a deadlock backstop, not a cull.
const double hostileOffFieldGrace = 3.0; // seconds

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

// --- Adaptive music ---------------------------------------------------------
// The soundtrack is N intensity tiers (theme_1..theme_N) plus a one-shot
// heroic `intro` per sector. MusicDirector computes a live "threat" score each
// tick and crossfades MusicService between tiers. All values are tunable.
const int musicTierCount = 5;            // theme_1 (calm) .. theme_5 (boss)
const double musicCrossfadeSeconds = 1.5; // tier crossfade duration
// A tier has to survive at least one musical phrase, or the score reads as
// restarting rather than responding. At 3s a busy screen walked the whole
// ladder and back inside a fleet wave.
const double musicMinDwellSeconds = 10.0; // min time on a tier before stepping (anti-flap)
const double musicDirectorInterval = 0.25; // threat re-evaluation period (~4 Hz)
// Music bed level. Lowered from 0.55 — the continuous bed was masking the
// explosion transients even though the SFX files peak higher.
const double musicMasterVolume = 0.45;

// Sidechain duck: explosions momentarily push the music down to this factor,
// recovering linearly over the given time. This is what makes an explosion
// read as loud — the files themselves are already normalised to the ceiling.
// Only large explosions (hpMax > 5000 kills) duck the music. Ducking every
// kill at a 0.35 floor made the melody pump audibly in dense combat — dips
// chained faster than the recovery, so the bed spent whole waves crawling up
// and down. A rarer, shallower dip reads as an accent instead of a wobble.
const double musicDuckFloor = 0.6;
const double musicDuckRecoverSeconds = 0.6;
const double musicMaxIntroSeconds = 20.0;  // hard cap: hand over to tiers even if intro never reports completion

// Threat formula weights (see MusicDirector._computeThreat).
const double musicWCount = 1.0;   // per active hostile on screen
// Summed hostile damage grows with sector level while the thresholds below do
// not, so at 0.15 it outweighed the headcount roughly 2:1 by mid-game and
// pinned the score near the top tier. Kept as a modifier, not the driver: what
// the player hears should track what the player sees.
const double musicWDmg = 0.05;    // per point of summed hostile collision damage
const double musicWProj = 0.4;    // per enemy projectile in flight
const double musicKOff = 1.5;     // how much player offense lowers perceived threat
const double musicKSurv = 1.0;    // how much low survivability raises perceived threat
const double musicRefOffense = 250.0; // offense value that counts as "fully armed" (0..1)

// Tier boundaries on the threat score (length = musicTierCount - 1, ascending).
// threat < t1 → tier 1; t1..t2 → tier 2; … ; >= t4 → tier 5. Boss overrides to max.
const List<double> musicThresholds = [3.0, 8.0, 16.0, 28.0];

// --- 3D immersion banking ---------------------------------------------------
// Purely visual: the vessel sprite rolls into lateral movement and world layers
// shift the opposite way with depth-scaled magnitude. No gameplay/collision
// coordinates are affected anywhere.
const double bankMaxRoll = 0.16;      // rad (~9°) vessel roll at full bank
const double bankSquashX = 0.15;      // horizontal foreshortening: scaleX = 1 - |bank|*this
const double bankResponse = 8.0;      // 1/s exponential smoothing rate toward target bank
const double bankFullSpeed = 300.0;   // px/s lateral speed that equals full bank
const double bankTeleportPx = 120.0;  // |dx| per frame above this = teleport, don't bank
const double bankWorldShift = 24.0;   // entity-plane shift px at full bank
const double bankStarShiftMax = 40.0; // nearest-star shift px at full bank
const double bankParallaxShift = 16.0; // nearest bg layer shift px at full bank
// World shift eases slower than the vessel roll so layers visibly trail the
// ship — the differential motion is what sells the 3D depth cue.
const double bankWorldResponse = 5.0; // 1/s smoothing rate of the world shift

// Entity glow halo colors — color-coded by danger tier
// Full alpha: BlurStyle.outer spreads the color outward; alpha = peak glow intensity.
const Color vesselGlowColor    = Color(0xFF00FFEE); // cyan
const Color hostileGlowL1      = Color(0xFF44FF44); // green  (collision dmg 1–2)
const Color hostileGlowL2      = Color(0xFFFFEE00); // yellow (collision dmg 3–6)
const Color hostileGlowL3      = Color(0xFFFF8800); // orange (collision dmg 7–12)
const Color hostileGlowL4      = Color(0xFFFF2200); // red    (collision dmg 13–18)
const Color hostileGlowBoss    = Color(0xFFFF00CC); // magenta (collision dmg 19+)
const Color structureGlowColor = Color(0xCCAAAAAA); // light gray
