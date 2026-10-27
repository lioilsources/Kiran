# Natáčení podkladů pro Steam

Provozní návod k `trailer-script.md` — co konkrétně udělat ve hře. Scénář
říká, jak to bude vypadat; tenhle soubor říká, co odehrát.

Screenshoty se z toho vytáhnou, natáčej jen video.

---

## Příprava

- **Fullscreen** (F11), desktopový build, **1920×1080, 60 fps**.
- Nahrávej **OBS** nebo `Cmd+Shift+5`. OBS je lepší: drží konstantní fps.
- **Nahrávej dlouho.** Ke každému záběru potřebuju 20–30 s, i když ve filmu
  poběží čtyři. Čtyřsekundový střih z pětisekundového klipu vždycky vypadá
  utaženě a trochu špatně.
- Soubory pojmenuj **číslem záběru**: `1.mov`, `2.mov`, … Pak stačí
  `python3 store/steam/build_trailer.py -clips <složka>`.
- HUD nech zapnutý, je součástí toho, jak hra vypadá.

## Cheaty (jinak to trvá věčnost)

V Com Centeru **dlouze stiskni nápis `COMMAND CENTER`**. Vyklopí se fialový
pruh:

- **MAX CREDITS** — 999 999 999 kreditů a odemčené všechny tiery zbraní
- **◀ ▶** — skok o sektor zpátky/dopředu

Tím si naskočíš na bosse a koupíš libovolnou zbraň bez hraní.

---

## Záběry

### 1 — Studený start *(30 s)*
Hustá vlna, kličkuješ mezi střelami. **Musí skončit zásahem z Cannonu**, aby
se nepřítel roztříštil na led. Natoč víc pokusů za sebou, vyberu nejlepší.

### 2 — Eskalace *(3× 20 s, různé zóny)*
Tři kusy boje z různých zón, ať se liší pozadí. Klidně `2a.mov`, `2b.mov`,
`2c.mov`.

### 3 — Smrt a návrat *(40 s, v jednom kuse)*
Nejdůležitější záběr celého traileru, protože prodává tu hlavní myšlenku.
**Nesmí se stříhat** — musí být vidět, že je to jedna souvislá věc:

1. nech se zabít (ať je výbuch trupu pořádně vidět)
2. hra tě vrátí do Sektoru 1
3. **jdi do Com Centeru a pomalu projeď LOADOUT** — zbraně jsou pořád
   vylepšené

Bez toho třetího kroku záběr netvrdí nic.

### 4 — Elementální montáž *(5× 15 s)*
Jádro traileru. Dej MAX CREDITS a postupně nasaď každou zbraň:

| Zbraň | Smrt vypadá jako |
|---|---|
| Bubble Gun | roztříštění na vodu |
| Cannon | led, padá těžce |
| Star Gun | hoření, stoupající plamen a jiskry |
| Laser | záblesk elektřiny |
| Blaster | purpurová plazmová nova |

Ke každé natoč pár zabití **uprostřed obrazovky** — nesmí to být v rohu.
Pojmenuj `4a.mov` … `4e.mov`.

### 5 — Com Center *(30 s)*
Pomalu, ať se to dá číst. Najeď na zbraň, **vylepši ji o tier** a nech
chvíli vidět, jak klesne ukazatel generátoru. Ta výměna síly za palebnou
sílu je pointa záběru.

### 6 — Kampaň *(40 s)*
Mapa trasy s uzly, otevření úkolu na uzlu, a boss. Ideálně **první a čtvrtý
boss za sebou**, ať je vidět, že čtvrtý má navíc díly — jestli je na čtvrtého
daleko, dej vědět a záběr přepíšu na to, co půjde.

### 7 — Skinový riff *(24× 15 s)* ⚠ vyžaduje kázeň
Nosný nápad traileru: jeden zadržený okamžik hry, pod kterým se mění styl.

**Natoč stejné otevření sektoru jednou za každý skin, vždy ze stejného
startu.** Skin přepneš přes pauzu → SKINS.

Na tomhle to stojí nebo padá: když se vlny rozejdou, přestane to číst jako
jeden okamžik v převlecích a bude z toho jen blikání. Když je 24 moc, udělej
**8–10 nejrozdílnějších** — monochrome, vektor, neon, chrom, sépie, pixel.

Pojmenuj podle skinu: `7_galaga.mov`, `7_ikaruga.mov` …

### 8 — Co-op *(20 s)*
Dvě lodě na jedné obrazovce. Natáčí se z hostitele.

---

## Screenshoty

Nic navíc nenatáčej — vytáhnu je z těchhle klipů. Steam chce aspoň pět a
první dva vidí skoro každý, takže půjdou v tomhle pořadí:

1. boj s elementálním zabitím (ze záběru 4)
2. Com Center s loadoutem (ze záběru 5)
3. mapa kampaně (ze záběru 6)
4. mřížka skinů (ze záběru 7)
5. co-op (ze záběru 8)

## Až to budeš mít

Řekni cestu ke složce. Sestříhám trailer, vytáhnu screenshoty, nahraju
obojí do Steamworks.
