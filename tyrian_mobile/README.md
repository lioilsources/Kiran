# Kirian — app development notes

The full pipeline reference lives in `../pipeline/SKILL.md`; the project-wide
overview in `../README.md`. This file is the short skin-authoring loop.

## Process: a new skin from A to Z

1. **Generate AI assets (ComfyUI / Flux)** — ~30 specs × N variations.

```bash
cd ../pipeline
go run ./cmd/generate -skin geometry_wars -n 4
```

2. **Postprocess** — JPG → PNG with alpha, resize, background removal.

```bash
go run ./cmd/postprocess -skin geometry_wars
```

Chosen variations are recorded in `../pipeline/selections/geometry_wars.json`;
re-pick a single asset with `-only <name> -variation <n>`.

3. **Verify**

```bash
ls assets/skins/geometry_wars/sprites/
ls assets/skins/geometry_wars/ui/preview.png
```

4. **Rebuild the atlas and run**

```bash
dart run tool/pack_atlas.dart
flutter run
```

## Audio postprocess (MP3 → OGG)

```bash
cd ../pipeline
go run ./cmd/postprocess -skin geometry_wars
# sfx/music conversion runs as part of the same pass
```

## Skins

14 originals, one per era of the genre — display names in
`lib/services/skin_registry.dart`, themes in `../SKINS.md`.
