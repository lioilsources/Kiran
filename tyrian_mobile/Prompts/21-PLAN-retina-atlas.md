# Plan: Retina Atlas (2×)

## Cíl

Na Retina/high-DPI zařízeních načíst `atlas@2x.png` (sprity 2× větší než stávající
1x atlas = 4× vs. původní VB6 pixel rozměry), na normálních zařízeních stávající
`atlas.png`. Herní logika (spriteScale, kolize, paths) zůstane beze změny.

## Kontext / stav před implementací

Po Variantě 2 (2× referenční velikosti, spriteScale 0.74 → 0.37):
- 1× atlas: 1024×1024, sprity 2× vs. VB6 (falcon 68×68, vessel 114×84, …)
- Retina atlas přidá další 2× vrstvu → falcon 136×136, vessel 228×168
- spriteScale pro 2× atlas: 0.37 / 2 = 0.185

## Struktura souborů

```
assets/skins/<id>/
  atlas.png       ← 1x (1024×1024, stávající)
  atlas.json      ← souřadnice v 1× pixelech
  atlas@2x.png    ← 2x (2048×2048, nové)
  atlas@2x.json   ← souřadnice v 2× pixelech
```

## Kroky implementace

### 1. pipeline — generovat 4× sprity pro Retina

`pipeline/internal/postprocess/reference_sizes.go` — duplikovat mapu jako
`referenceSizes2x` s 4× hodnotami (nebo parametrizovat scale faktor v `Config`).

`cmd/postprocess/main.go` — přidat flag `--retina` (nebo `--scale 2`), který přepne
na `referenceSizes2x` a zapíše do `sprites@2x/` subadresáře.

### 2. pack_atlas.dart — přidat `--retina` flag

```dart
// Nový flag: dart run tool/pack_atlas.dart --retina
// Čte sprites@2x/, kMaxSize=4096, výstup atlas@2x.png + atlas@2x.json
```

Konkrétně:
- `kMinSize` a `kMaxSize` zdvojit (2048 / 4096) v retina módu
- Vstupní adresář: `sprites@2x/` místo `sprites/`
- Výstupní soubory: `atlas@2x.png` + `atlas@2x.json`

### 3. pubspec.yaml — zaregistrovat nové assety

```yaml
flutter:
  assets:
    - assets/skins/  # pokud je wildcard, automaticky zahrne atlas@2x.*
```

Ověřit, že Flutter asset bundler zahrne soubory se `@2x` v názvu (není to iOS
automatika — Flutter to zpracuje jako běžný soubor).

### 4. AssetLibrary — detekce DPR a výběr atlasu

```dart
// lib/services/asset_library.dart

Future<void> loadSkin(String skinId) async {
  final dpr = PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 1.0;
  final useRetina = dpr >= 2.0;
  final atlasName = useRetina ? 'atlas@2x' : 'atlas';
  final atlasScale = useRetina ? 0.5 : 1.0; // kompenzace pro spriteScale

  final png = await rootBundle.load('assets/skins/$skinId/$atlasName.png');
  final json = await rootBundle.loadString('assets/skins/$skinId/$atlasName.json');
  // ... uložit atlasScale jako field, použít v SpriteResolver
}
```

### 5. SpriteResolver / Hostile / Vessel — aplikovat atlasScale

`size = sprite.srcSize * config.spriteScale * assetLibrary.atlasScale`

Takto herní logika (rychlosti, kolize, paths) neví nic o DPI. Alternativně:
uložit efektivní `resolvedSpriteScale` do `AssetLibrary` jako
`spriteScale * atlasScale` a číst ho místo `config.spriteScale` při resize.

### 6. Voronoi fragmenty

Fragmenty v `atlas@2x` budou také 2× větší — jejich offsety (`seedX`, `seedY`
v `atlas@2x.json`) musí být v 2× souřadnicích. `pack_atlas.dart` toto řeší
automaticky protože pracuje přímo s pixely vstupních PNG.

Destrukce code (`Shard`, `Explosion`) používá seed souřadnice relativně ke sprite
rozměru — ověřit že výpočet není absolutní v pixelech.

## Rizika a otevřené otázky

| Riziko | Dopad | Mitigace |
|--------|-------|----------|
| 2048×2048 atlas = 4–16 MB PNG per skin | Paměť na starších zařízeních | Načítat Retina pouze na zařízeních s ≥ 3 GB RAM nebo explicitním high-DPI flagem |
| Flame `Image` objekt — nelze za runtime přepnout | Musí se rozhodnout při startu | Rozhodnutí v `loadSkin()` před prvním renderem, restart skin = reload |
| iOS/macOS `@2x` naming — Flutter to ignoruje | Žádný automatický fallback | Explicitní logika v AssetLibrary (viz krok 4) |
| `atlas@2x.json` souřadnice v 2× pixelech | Špatné UV koordináty pokud se splete scale | Testovat na emulátoru s `devicePixelRatio = 2.0` |
| Voronoi seed koordináty v absolutních pixelech | Šrapnely létají na špatná místa | Audit `Shard` — seedX/seedY by měly být normalizovány na [0,1] nebo relativní k srcSize |

## Testovací postup

1. `flutter run -d macos` — macOS Retina displej (DPR = 2.0)
2. Ověřit že `atlasName = 'atlas@2x'` se volí správně (debug log)
3. Porovnat vizuální velikost vessel/falcon mezi 1× a 2× — musí být identická
4. Spustit sektor s nepřáteli, ověřit destrukci (Voronoi fragmenty)
5. `flutter run -d android` na non-Retina zařízení — musí fallback na `atlas.png`
