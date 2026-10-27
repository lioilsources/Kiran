# App Store listing — Kirian (日本語 / ja)

Locale code for App Store Connect: **ja**. Written for **v2.9.2** (= v2.9.1, the build live on the App Store):
14 skins / 11 paid, no Campaign, no difficulty selection — those arrive in
v3. Checked against `skin_registry.dart` at tag `v2.9.1`. The v3.7.0 version
of this file (24 skins, Campaign, difficulty) is in commit `a4245b3`; switch
back to it when v3 goes to the store.

Character counts use Apple's method (one Unicode character = one count),
verified with a script.

**Note:** the game's in-app UI is English-only (no Flutter l10n/intl setup).
This listing localizes "Sector" → セクター and "Com Center" → コムセンター for
readability, even though those exact labels appear in English on screen.
Standard ASO practice; the screenshots in `screenshots-ja/` carry Japanese
captions over English UI for the same reason.

Tone: plain だ/である narrative style, which is normal for game copy on the
Japanese store. Not keigo — that reads like a utility app.

Support URL (required per localization): `https://lioilsources.github.io/Kiran/support.html`

---

## App Name  (limit 30)

```
Kirian: 死なない弾幕シューティング
```

**21 chars.** "死なない" (doesn't die) carries the roguelike hook directly in the
name; "弾幕シューティング" (bullet-curtain shooting) is the term Japanese shmup
fans actually search.

## Subtitle  (limit 30)

```
ローグライク・アーケードシューティング
```

**19 chars.**

## Keywords  (limit 100)

```
レトロ,宇宙船,協力プレイ,縦スクロール,ドット絵,STG,死にゲー,ボス戦,2人プレイ,高難易度,オフライン,スキン,買い切り,シューター
```

**70 chars.** No spaces after commas. Avoids repeating 弾幕/シューティング/ローグライク,
already indexed via name + subtitle. STG and 死にゲー (death-loop slang) are
live search terms in the JP store; オフライン and 買い切り target players
filtering out always-online and gacha games.

## Promotional Text  (limit 170)

```
死はここで終わらない。手に入れた武器・クレジット・スコアはそのまま、セクター1に戻ってさらに深く挑もう。ローカルWi-Fiで2人協力プレイ。広告なし、買い切りのみ。
```

**82 chars.** Updates without review — swap in whatever is newest.

## Description  (limit 4000)

```
孤独なガンシップを駆り、敵が果てしなく押し寄せる回廊を突き進め。ワンセクターはわずか60秒。

Kirianは、ローグライクのループを軸にした縦スクロール・アーケードシューティングだ。自機を失ってもランは終わらない――手に入れた武器も、クレジットも、スコアも、すべて持ち越してセクター1に戻り、前回よりも深く進む。進行状況は永続的。リセットされるのは船体だけだ。

属性別の破壊演出
敵は自分を倒した武器によって死に方が変わる。バブルガンは敵を水しぶきに弾けさせる。キャノンは敵を凍らせ、重く冷たい氷の欠片へと砕く。スターガンは敵を燃え上がらせ、炎と漂う残り火を残す。レーザーは稲妻のような閃光を放って消える。ブラスターは敵をマゼンタのプラズマ爆発へと内破させる。どのキルも一目で分かる。

ガンシップを強化せよ
セクターの合間、コムセンターは自由に使える場所だ。フロントガン、サイドガン、ジェネレーター、ハルとシールド――すべて25段階まで強化できる。出力には限りがあり、重い武器を積めばジェネレーターの供給が追いつかなくなる。だからこそ、どの編成にもトレードオフがある。スコアは決してリセットされず、一定のしきい値を超えるたびに上位武器ティアが永久に解放される。

手作りの戦場、その先は無限に
6つのゾーンにまたがる18の手作りセクター。それぞれが60秒の緊密な構成で、独自の編隊とリズムを持つ。空もそれに合わせて移り変わる――辺境では冷たく静かに、奥へ進むにつれてティール、琥珀、そして深紅へ。そこを抜けると、あとはジェネレーターが引き継ぎ、上限なく難易度が上がり続け、5レベルごとにボスが待ち受ける。

2人で、同じ部屋で
協力プレイはローカルWi-Fiの自動検出で動く――アカウントも、サーバーも、インターネットも不要。1台がホストとなり、もう1台が参加して、同じセクターを一緒に飛ぶ。

14種のルック
スキンはゲーム全体を作り替える――船、敵、背景、インターフェース、サウンドまで。3種はアプリに無料で付属し、残り11種は1つずつの買い切り。広告もサブスクリプションも消費アイテムも、ゲーム内には一切存在しない。

手触りへのこだわり
GPUシェーダーがブルーム、スキャンライン、ビネット、色収差を描き出す。敵は自身のスプライトから切り出された物理演算の破片となって砕け散る――ボスも例外ではない。タッチ、キーボード、接続したコントローラーのいずれでもプレイできる。

2つのGame Centerリーダーボードが、合計スコアと到達した最深レベルであなたを競わせる。キル数、セクター、無傷クリアの実績も用意。

※ゲーム内の表示は英語です。
```

The closing ※ line tells Japanese buyers up front that the UI is English —
cheaper than a 1-star review saying so. Drop it once the UI is localized.

## What's New  (version 2.9.2)

2.9.1 is live on the App Store (since 2026-09-03, Japan included), and a
live version's name, subtitle, keywords, description and screenshots cannot
be edited — only Promotional Text can. The Japanese listing therefore ships
with **2.9.2**: the same game as 2.9.1, rebuilt from a tag on the v2 line.
Nothing in the game changed, so the note says exactly that.

```
日本語のストアページを公開しました。ゲーム内容はバージョン2.9.1と同じです。
```
