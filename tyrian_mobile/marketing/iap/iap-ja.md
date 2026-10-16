# In-app purchases — Japanese localization (ja)

For the **v2.9.1** release: the 11 paid skins in `skin_registry.dart` at tag
`v2.9.1`. The ten added in v3 are listed separately below, ready for later.

- **App Store Connect:** each product → App Store Localization → + 日本語 →
  Display Name (limit 30) and Description (limit 45).
- **Play Console:** each product → Translations → 日本語 → Name (limit 55)
  and Description (limit 200).

The in-game skin selector shows the **English** name (the UI is not
localized), so every description carries that English name. A buyer can then
match what they paid for to the tile on screen. The display names are katakana
or Japanese, because that is what shows on the purchase sheet and in search.

The review screenshots in this folder are language-neutral and do not need
Japanese versions.

---

## App Store (name ≤ 30, description ≤ 45)

| Product ID | Display Name | Description |
|---|---|---|
| `com.ol1n.kiran.skin_space_invaders` | モノクロ・インベーダー スキン | スキン「Monochrome Invader」(1978)を解放 |
| `com.ol1n.kiran.skin_asteroids` | ベクター・ワイヤーフレーム スキン | スキン「Vector Wireframe」(1979)を解放 |
| `com.ol1n.kiran.skin_river_raid` | 8ビット・キャニオン スキン | スキン「8-Bit Canyon」(1982)を解放 |
| `com.ol1n.kiran.skin_rtype` | バイオメカ・クルーザー スキン | スキン「Biomech Cruiser」(1987)を解放 |
| `com.ol1n.kiran.skin_blazing_lazers` | 16ビット・レーザー スキン | スキン「16-Bit Laser」(1989)を解放 |
| `com.ol1n.kiran.skin_tyrian_dos` | レトロPCドット スキン | スキン「Retro PC Pixel」(1995)を解放 |
| `com.ol1n.kiran.skin_ikaruga` | デュアル・ポラリティ スキン | スキン「Dual-Polarity」(2001)を解放 |
| `com.ol1n.kiran.skin_gradius_v` | クローム艦隊 スキン | スキン「Chrome Fleet」(2004)を解放 |
| `com.ol1n.kiran.skin_luftrausers` | セピア・ドッグファイト スキン | スキン「Sepia Dogfight」(2014)を解放 |
| `com.ol1n.kiran.skin_nuclear_throne` | 荒野ドット スキン | スキン「Wasteland Pixel」(2015)を解放 |
| `com.ol1n.kiran.skin_nex_machina` | ネオン・ボクセル スキン | スキン「Neon Voxel」(2017)を解放 |

### Added in v3 — enter when v3 ships

v2.9.1 does not sell these ten. If the products already exist in App Store
Connect, localizing them now does no harm; otherwise add them with v3.

| Product ID | Display Name | Description |
|---|---|---|
| `com.ol1n.kiran.skin_tempest` | ネオンチューブ スキン | スキン「Neon Tube」(1981)を解放 |
| `com.ol1n.kiran.skin_zaxxon` | アイソ・フォートレス スキン | スキン「Iso Fortress」(1982)を解放 |
| `com.ol1n.kiran.skin_twinbee` | ちびっこ編隊 スキン | スキン「Chibi Squadron」(1985)を解放 |
| `com.ol1n.kiran.skin_candy_drift` | キャンディ・ドリフト スキン | スキン「Candy Drift」(1986)を解放 |
| `com.ol1n.kiran.skin_abadox` | 肉の迷宮 スキン | スキン「Flesh Maze」(1989)を解放 |
| `com.ol1n.kiran.skin_solar_striker` | ポケット・モノクロ スキン | スキン「Pocket Mono」(1990)を解放 |
| `com.ol1n.kiran.skin_axelay` | モード7・スチール スキン | スキン「Mode-7 Steel」(1992)を解放 |
| `com.ol1n.kiran.skin_thunder_force` | FMサンダー スキン | スキン「FM Thunder」(1992)を解放 |
| `com.ol1n.kiran.skin_star_fox` | フラットポリゴン スキン | スキン「Flat Polygon」(1993)を解放 |
| `com.ol1n.kiran.skin_lords_of_thunder` | メタルナイト スキン | スキン「Metal Knight」(1993)を解放 |

Longest name: 17 chars; longest description: 32 chars. All within the limits
(script-verified).

`skin_candy_drift` is the Candy Drift skin (repo id `fantasy_zone`); the id
`skin_fantasy_zone` is burned, see `README.md`.

## Play Console (name ≤ 55, description ≤ 200)

Same Display Name as above. Description template, with the English name and
year filled in from the table:

```
ゲーム内では「<English name> (<year>)」と表示されるスキンを解放します。自機、敵、背景、インターフェース、サウンドまでゲーム全体の見た目が一新。買い切りで、一度購入すればずっと使えます。
```

**~105 chars** with the longest name. Example for `skin_space_invaders`:

```
ゲーム内では「Monochrome Invader (1978)」と表示されるスキンを解放します。自機、敵、背景、インターフェース、サウンドまでゲーム全体の見た目が一新。買い切りで、一度購入すればずっと使えます。
```

Free skins, for reference (no product, no translation needed): Arcade
Formation, Neon Grid, Kiran.
