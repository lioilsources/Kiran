# Shader pipeline — 6 shaderů, 4 průchody

  Pipeline se aplikuje přes camera.postProcess a pořadí je vždy:

  1. Vignette + Color (vignette_color.frag) — vždy aktivní

  - Ztmavení okrajů obrazovky (vignette)
  - Barevný tint (R/G/B multiplikátor per skin)
  - Saturace (desaturace pro nuclear_throne skin)
  - Damage flash — červený záblesk při zásahu hráče (intensity = dmgTaken / 4.0, decay automaticky)

  2. Bloom (bloom_threshold.frag → bloom_blur.frag → bloom_composite.frag) — podmíněný

  - Threshold: extrahuje jasné pixely nad prahem (luminance > threshold)
  - Blur: 9-tap Gaussian blur, 2× průchod (horizontální + vertikální)
  - Composite: aditivní blend originálu + rozmazaného bloom
  - Zapnutý u 8 z 13 skinů (geometry_wars nejsilnější 1.5×, ikaruga/nex_machina střední, galaga/gradius_v slabý)
  - Výkonnostně nejnáročnější — 3 render passy + 2 offscreen textury

  3. CRT (crt.frag) — podmíněný

  - Barrel distortion (zakřivení obrazu jako na CRT monitoru)
  - Scanlines (vodorovné pruhy)
  - Zapnutý jen u 2 skinů: tyrian_dos (silný: 0.7 scanlines, 0.02 curvature) a space_invaders (lehký: 0.4/0.01)

  4. Chromatic Aberration (chromatic_aberration.frag) — trigger-based

  - RGB separace (rozštěpení barevných kanálů od středu)
  - Aktivuje se voláním triggerAberration() → intensity 1.0, decay na 0 za 0.3s
  - Slouží jako hit feedback efekt

  ---
  Konfigurace per skin (13 presetů v shader_config.dart):

  ┌────────────────┬───────┬──────────┬─────────────────────────────────┐
  │      Skin      │ Bloom │   CRT    │            Speciální            │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ default        │ —     │ —        │ jen vignette                    │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ geometry_wars  │ 1.5×  │ —        │ neon bloom                      │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ tyrian_dos     │ —     │ 0.7/0.02 │ retro CRT                       │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ space_invaders │ —     │ 0.4/0.01 │ lehký CRT                       │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ ikaruga        │ 0.8×  │ —        │ subtle bloom                    │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ nuclear_throne │ —     │ —        │ tight vignette, desaturace 0.85 │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ galaga         │ 0.5×  │ —        │ slabý bloom                     │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ asteroids      │ 0.6×  │ —        │ zelený tint                     │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ luftrausers    │ —     │ —        │ teplý tint (1.0, 0.9, 0.7)      │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ nex_machina    │ 1.0×  │ —        │ balanced bloom                  │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ gradius_v      │ 0.6×  │ —        │ studený tint                    │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ rtype          │ 0.7×  │ —        │ lehký bloom                     │
  ├────────────────┼───────┼──────────┼─────────────────────────────────┤
  │ blazing_lazers │ 0.8×  │ —        │ teplý tint + bloom              │
  └────────────────┴───────┴──────────┴─────────────────────────────────┘

  Toto je čistě research — nechci na tom nic měnit, takže plan mode není potřeba. Chceš něco se shadery upravit?