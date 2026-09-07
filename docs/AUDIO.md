# Audio — generování hudby a SFX

Hudba i zvukové efekty jsou generované AI. Od září 2026 lokálně na SPARKu
open-source modely; ElevenLabs zůstává v kódu jako fallback, ale klíč se
v produkci nepoužívá.

## Co kde je

```
pipeline/assets/audio/manifest.yaml   zdroj pravdy: co má hra mít, jak to vzniklo
pipeline/cmd/audiogen/                generátor
pipeline/internal/audio/              provider abstrakce, manifest, prompty, QA
tyrian_mobile/assets/skins/<id>/music/ *.ogg — intro + theme_1..theme_5
tyrian_mobile/assets/skins/<id>/sfx/   *.ogg — 10 efektů
```

24 skinů × (6 stop + 10 efektů) = **384 assetů**.

## Manifest

`manifest.yaml` drží pro každý asset:

| pole | k čemu |
|---|---|
| `duration_s`, `loop`, `variations` | zadání |
| `prompt_el` | volný text pro ElevenLabs (šablona, přegeneruje se) |
| `prompt_oss` | tagový prompt pro ACE-Step / MOSS (šablona, přegeneruje se) |
| `prompt_el_override`, `prompt_oss_override` | **ruční** přepis; vyhrává a `-init` ho nepřepíše |
| `seed`, `model`, `provider`, `sha256` | čím a jak asset vznikl → deterministická regenerace |
| `lufs`, `measured_s`, `qa_flags` | výsledek kontroly |

Ruční ladění promptu patří **vždy** do `*_override`. Do `prompt_oss` ne —
`audiogen -init` ho přepíše ze šablony, a to je záměr: změna šablony se má
propsat do všeho, co nikdo ručně neladil.

## Regenerace

```bash
cd pipeline

# 1. Manifest podle aktuálních skin definic (bezpečné, merguje)
go run ./cmd/audiogen -init

# 2. Co ještě neexistuje
go run ./cmd/audiogen

# 3. Cílené přegenerování
go run ./cmd/audiogen -only all -skin galaga            # celý skin
go run ./cmd/audiogen -regen music -skin galaga         # jen hudba skinu
go run ./cmd/audiogen -regen sfx -ids fire_bullet       # jeden efekt napříč skiny
go run ./cmd/audiogen -only flagged                     # co propadlo v QA

# 4. Kontrola bez generování
go run ./cmd/audiogen -qa -only all
```

`-dry-run` vypíše prompty a nic nezavolá. Manifest se ukládá **po každém
assetu**, takže přerušený běh se dá jen znovu spustit.

## Providery

`AUDIO_PROVIDER` (default `aistack`):

```bash
# lokální modely na SPARKu — výchozí
export AUDIO_PROVIDER=aistack
export AISTACK_URL=http://spark:8093        # nebo https://llm.ol1n.com
export AISTACK_API_KEY=...                  # jen když je služba za autentizací

# fallback do cloudu
export AUDIO_PROVIDER=elevenlabs
export ELEVENLABS_API_KEY=...
```

ElevenLabs neumí vrátit seed, takže z něj vzniklé assety **nejsou
reprodukovatelné** — manifest u nich zůstane bez `seed`. To je hlavní důvod,
proč je výchozí `aistack`.

`pipeline` vyžaduje modul `github.com/ol1n/AiStack/pkg/audioclient`, který
`go.mod` bere `replace` direktivou z `../../AiStack/pkg/audioclient`. Oba repa
tedy musí ležet vedle sebe. CI to netrápí — staví se jen Flutter.

## Post-processing

Dělá ho služba, ne pipeline. Každý výstup projde:

- ořez ticha na krajích (jen SFX)
- **loopify** u smyček: ocas se prolne přes hlavu, výstup je o prolnutí (2 s)
  kratší a konec navazuje na začátek
- normalizace na **−16 LUFS** (hudba) / **−18 LUFS** (SFX), true peak −1 dBTP
- OGG Vorbis `-q 6`, SFX mono, 44,1 kHz

Assety z ElevenLabs tímhle neprošly a je to na nich vidět — naměřeno na
shipnuté sadě: hlasitost SFX se pohybuje od −27 do −14 LUFS a hudební smyčky
končí fade-outem do ticha, takže při zacyklení mají slyšitelný šev. Obojí QA
označí (`-qa`).

## Naměřený stav (7. 9. 2026)

`audiogen -qa -only all` nad celou sadou. `galaga` je jediný skin přegenerovaný
novým stackem, zbytek jsou ještě assety z ElevenLabs:

| | assetů | označeno QA |
|---|---:|---:|
| galaga po přegenerování | 16 | **1** |
| zbylých 23 skinů (ElevenLabs) | 331 | 232 |
| chybí soubor | 37 | — |

Nejčastější vady původní sady: 118× hlasitost mimo cíl (rozptyl −27 až −14 LUFS),
97× useknutý úsek, 46× smyčka, jejíž jeden konec je prakticky ticho (doběh do
fade-outu), 39× ticho na konci.

Jediný příznak, který zůstává na přegenerované sadě, je délka `intro`: ACE-Step
dodá na dvanáctisekundovou fanfáru zhruba sedm sekund hudby a zbytek dopadá
tichem, které ořez odstraní. Když to bude vadit, patří to řešit v manifestu
(`duration_s` u `intro`), ne v prahu QA.

Šest skinů nemá hudbu vůbec (`abadox`, `axelay`, `fantasy_zone`,
`lords_of_thunder`, `thunder_force`, `twinbee`), `zaxxon` postrádá jeden efekt.
Tyhle chybějící assety vezme `audiogen` bez parametrů jako první.

## Kolik to trvá

Naměřeno na SPARKu (GB10):

| | čas |
|---|---|
| hudební stopa (30 s zadání) | 12–15 s |
| efekt (MOSS, 100 kroků) | ~24 s včetně post-processingu |
| první efekt po startu kontejneru | +60 s (překlad torch.compile) |
| celý skin (6 stop + 10 efektů) | ~6 min |
| **všech 24 skinů** | **~2,5 h** |

Počet kroků u SFX se dá stáhnout (`AUDIO_SFX_STEPS`): 100 kroků = 22,5 s,
50 = 11,2 s, 30 = 6,7 s na efekt. Sto je doporučení autorů modelu.

## Dopad na hru

Žádný kód ve Flutteru se měnit nemusí:

- jména souborů zůstávají (`SoundService` i `MusicService` skládají cestu jako
  `assets/skins/<id>/<sfx|music>/<name>.ogg`)
- formát zůstává OGG
- smyčky vyjdou o prolnutí (2 s) kratší, než říká `duration_s` — `MusicService`
  čte `p.duration` za běhu a nikde délku nemá zadrátovanou, takže ho to nezajímá
- vrstvy jednoho skinu si drží stejný vzájemný poměr délek jako dosud
  (`theme_1`–`theme_4` stejně dlouhé, `theme_5` o něco delší)

Varianty navíc (`-variations > 1`) se ukládají jako `<id>_v2.ogg` atd. Hra je
nenačítá — `SoundService` bere přesně `<id>.ogg`. Slouží k ručnímu výběru.

## Ruční poslech

Před uzavřením regenerace projet dev build a poslechnout každý skin aspoň
jeden level — QA chytí měřitelné vady, ne to, jestli hudba sedí k éře skinu.

## Licence pro Steam

Assety generuje model s komerční licencí (ACE-Step 1.5 — MIT, MOSS-SoundEffect
v2.0 — Apache-2.0). Do `THIRD_PARTY_LICENSES` patří licence toho modelu, který
je v manifestu v poli `model`. Aktuální seznam a licence:
`GET /v1/audio/models` na AiStacku, shrnutí v `AiStack/services/audio/LICENSES.md`.

Modely s nekomerční licencí vah (MusicGen, AudioGen, AudioLDM2, TangoFlux,
MMAudio) se pro Kirian **nesmí použít**.
