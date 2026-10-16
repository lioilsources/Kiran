# App Store listing — Kirian (日本語 / ja)

Locale code for App Store Connect: **ja**. Written against v3.7.0 — newer than
the English `appstore-listing.md` (v2.7.0), which still says "fourteen looks"
and has no Campaign or difficulty. Facts here are checked against the code:
24 skins / 21 paid (`skin_registry.dart`), Easy / Normal / Hard + hidden Lord
(`challenge.dart`), Campaign as described in `store/steam/store-copy.md`.

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
レトロ,宇宙船,協力プレイ,縦スクロール,ドット絵,STG,死にゲー,ボス戦,2人プレイ,高難易度,オフライン,キャンペーン,スキン,買い切り,シューター
```

**77 chars.** No spaces after commas. Avoids repeating 弾幕/シューティング/ローグライク,
already indexed via name + subtitle. STG and 死にゲー (death-loop slang) are
live search terms in the JP store; オフライン and 買い切り target players
filtering out always-online and gacha games.

## Promotional Text  (limit 170)

```
死はここで終わらない。武器・クレジット・スコアを持ち越して、セクター1から再び深みへ。新登場:イージー/ノーマル/ハードの難易度選択と、5種類の敵弾パターン。
```

**79 chars.** Updates without review — swap in whatever is newest.

## Description  (limit 4000)

```
孤独なガンシップを駆り、敵が果てしなく押し寄せる回廊を突き進め。ワンセクターはわずか60秒。

Kirianは、ローグライクのループを軸にした縦スクロール・アーケードシューティングだ。自機を失ってもランは終わらない――手に入れた武器も、クレジットも、スコアも、すべて持ち越してセクター1に戻り、前回よりも深く進む。進行状況は永続的。リセットされるのは船体だけだ。

2つのモード
エンドレス:6つのゾーンにまたがる18の手作りセクター。それぞれが60秒の緊密な構成で、独自の編隊とリズムを持つ。その先はジェネレーターが引き継ぎ、上限なく難易度が上がり続け、5レベルごとにボスが待ち受ける。
キャンペーン:20のノード、4体のボス、独立した進行とセーブデータ。各ノードにはクリア必須の任務と、任意の挑戦――ノーダメージ、装備縛り、タイムアタック――が用意されている。ボスは選ばれるのではなく組み上がる。同じコアに毎回新たなパーツが加わり、最後のボスはそれまでのすべてを背負って現れる。

難易度を選べる
イージー、ノーマル、ハードの3段階。敵の耐久力、攻撃力、連射速度が変わり、高難易度ほどスコアも伸びる――つまり上位武器の解放も早くなる。そして、隠された4つ目の難易度も……。

撃ち方を読め
敵の弾はまっすぐ落ちてくるだけではない。狙い撃ち、拡散、バースト、一斉射撃。弾道を読み、隙間を縫え。

属性別の破壊演出
敵は自分を倒した武器によって死に方が変わる。バブルガンは敵を水しぶきに弾けさせる。キャノンは敵を凍らせ、重く冷たい氷の欠片へと砕く。スターガンは敵を燃え上がらせ、炎と漂う残り火を残す。レーザーは稲妻のような閃光を放って消える。ブラスターは敵をマゼンタのプラズマ爆発へと内破させる。どのキルも一目で分かる。

ガンシップを強化せよ
セクターの合間、コムセンターは自由に使える場所だ。フロントガン、サイドガン、ジェネレーター、ハルとシールド――すべて25段階まで強化できる。出力には限りがあり、重い武器を積めばジェネレーターの供給が追いつかなくなる。だからこそ、どの編成にもトレードオフがある。スコアは決してリセットされず、一定のしきい値を超えるたびに上位武器ティアが永久に解放される。

2人で、同じ部屋で
協力プレイはローカルWi-Fiの自動検出で動く――アカウントも、サーバーも、インターネットも不要。1台がホストとなり、もう1台が参加して、同じセクターを一緒に飛ぶ。

24種のルック
スキンはゲーム全体を作り替える――船、敵、背景、インターフェース、サウンドまで。モノクロのインベーダー、ベクターのワイヤーフレーム、ネオングリッド、クロームの艦隊、セピアのドッグファイト。3種はアプリに無料で付属し、残り21種は1つずつの買い切り。広告もサブスクリプションも消費アイテムも、ゲーム内には一切存在しない。

手触りへのこだわり
GPUシェーダーがブルーム、スキャンライン、ビネット、色収差を描き出す。敵は自身のスプライトから切り出された物理演算の破片となって砕け散る。タッチ、キーボード、接続したコントローラーのいずれでもプレイできる。

2つのGame Centerリーダーボードが、合計スコアと到達した最深レベルであなたを競わせる。キル数、セクター、無傷クリアの実績も用意。

※ゲーム内の表示は英語です。
```

The closing ※ line tells Japanese buyers up front that the UI is English —
cheaper than a 1-star review saying so. Drop it once the UI is localized.

## What's New  (version 3.7.0)

```
難易度選択
イージー/ノーマル/ハードの3段階を、エンドレスとキャンペーンの両方で選べるようになった。難易度は敵の耐久力・攻撃力・連射速度を変え、スコア倍率も変わる。高難易度なら上位武器の解放も早い。隠された4つ目の難易度もある。

敵弾パターン
敵はもう弾をまっすぐ落とすだけではない。狙い撃ち、拡散、バースト、一斉射撃――5種類の撃ち方で襲ってくる。
```
