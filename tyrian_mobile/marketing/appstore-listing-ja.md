# App Store listing — Kirian (日本語 / ja)

Translated from `appstore-listing.md` (English source, v2.7.0). Locale code for
App Store Connect: **ja**. Character counts below use Apple's method (one
Unicode character = one count), verified with a script.

**Note:** the game's in-app UI is English-only (no Flutter l10n/intl setup).
This listing localizes "Sector" → セクター and "Com Center" → コムセンター for
readability, even though those exact labels will appear in English on screen.
That's standard ASO practice, but worth knowing before you publish.

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
レトロ,宇宙船,協力プレイ,縦スクロール,ドット絵,STG,死にゲー,ボス戦,2人プレイ,高難易度
```

**49 chars.** Avoids repeating 弾幕/シューティング/ローグライク, already indexed via
name + subtitle. STG (シューティングゲーム) and 死にゲー (death-loop slang) are both
live search terms in the JP store.

## Promotional Text  (limit 170)

```
死はここで終わらない。手に入れた武器・クレジット・スコアはそのまま、セクター1に戻ってさらに深く挑もう。ローカルWi-Fiで2人協力プレイ。新要素:属性キル演出。
```

**81 chars.**

## Description  (limit 4000)

```
孤独なガンシップを駆り、敵が果てしなく押し寄せる回廊を進め。ワンセクターはわずか60秒。

Kirianはローグライクのループで作られた縦スクロール・アーケードシューティングだ。自機を失ってもランは終わらない――手に入れた武器も、クレジットも、スコアも、すべてそのまま持ち越してセクター1に戻り、前回よりも深く進む。進行状況は永続的。リセットされるのは船体だけだ。

属性別の破壊演出
敵は自分を倒した武器によって死に方が変わる。バブルガンは敵を水しぶきに弾けさせる。キャノンは敵を凍らせ、重く冷たい氷の欠片へと砕く。スターガンは敵を燃え上がらせ、炎と漂う残り火を残す。レーザーは稲妻のような閃光を放って消える。ブラスターは敵をマゼンタのプラズマ爆発へと内破させる。どのキルも一目で分かる。

ガンシップを強化せよ
セクターの合間、コムセンターは自由に使える場所だ。フロントガン、サイドガン、ジェネレーター、ハルとシールド――すべて25段階まで強化できる。出力には限りがあり、重い武器を積めばジェネレーターの供給が追いつかなくなる。だからこそ、どの編成にもトレードオフがある。スコアは決してリセットされず、一定のしきい値を超えるたびに上位武器ティアが永久に解放される。

手作りの戦場、その先は無限に
6つのゾーンにまたがる18の手作りセクターが用意され、それぞれが60秒の緊密な構成で、独自の編隊とリズムを持つ。そこを抜けると、あとはジェネレーターが引き継ぎ、上限のない難易度上昇が続き、5レベルごとにボスが待ち受ける。

2人で、同じ部屋で
協力プレイはローカルWi-Fiの自動検出で動く――アカウントも、サーバーも、インターネットも不要。1台がホストとなり、もう1台が参加して、同じセクターを一緒に飛ぶ。

14種のルック
スキンはゲーム全体を作り替える――船、敵、背景、インターフェース、サウンドまで。3種のスキンはアプリに無料で付属。残り11種は買い切りで、広告もサブスクリプションも消費アイテムもゲーム内には一切存在しない。

手触りへのこだわり
GPUシェーダーがブルーム、スキャンライン、ビネット、色収差を描き出す。敵は自身のスプライトから切り出された物理演算の破片となって砕け散る。タッチ、キーボード、接続したコントローラーのいずれでもプレイできる。

2つのGame Centerリーダーボードが、合計スコアと到達した最深レベルであなたを競わせる。キル数、セクター、無傷クリアの実績も用意。
```

## What's New  (version 2.7.0)

```
ローグライク・ラン
自機を失ってもゲームオーバーにはならない。武器、クレジット、アップグレード、スコアはすべて引き継がれ、セクター1に巻き戻ってまた挑める。スコアは今や累積式になり、上位武器ティアを永久に解放する。

リーダーボード
Game Centerの2つのボード:合計スコアと到達最深レベル。スコアは使わなかったクレジットではなく、実際のスコアで順位が決まるようになったので、武器を買ってもランクを落とさなくなった。

その他
コムセンターに現在のスコアと次の武器ティアまでの残りポイントを表示。スキンの名称を刷新。macOSリリースビルドから協力プレイをホストする際の不具合を修正。
```
