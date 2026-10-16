# Google Play listing — Kirian (日本語 / ja-JP)

Play Console → Grow → Store presence → Main store listing → **Manage
translations → Add your own translations → 日本語 (ja-JP)**. Only the text
fields below are per-language; graphics are inherited from the default
listing unless you upload localized ones (use `screenshots-ja/play-*`).

Same facts as `appstore-listing-ja.md` (v3.7.0). Play's limits differ from
Apple's and there is **no keywords field**: search reads title, short and full
description, so the search terms (弾幕, シューティング, STG, ローグライク, 縦スクロール,
協力プレイ, オフライン, 買い切り) live in the prose. Do not paste Apple's comma
list — Google treats keyword stuffing as a policy violation.

---

## App name  (limit 30)

```
Kirian: 死なない弾幕シューティング
```

**21 chars.** Same as the App Store name.

## Short description  (limit 80)

```
死んでも全部持ち越し。もっと深くへ。ローグライク縦スクロールSTG、2人協力プレイ対応。
```

**44 chars.** The line under the title in search results — the hook and the
genre in one breath.

## Full description  (limit 4000)

```
孤独なガンシップを駆り、敵が果てしなく押し寄せる回廊を突き進め。ワンセクターはわずか60秒。

Kirianは、ローグライクのループを軸にした縦スクロール・アーケードシューティング(STG)だ。自機を失ってもランは終わらない――手に入れた武器も、クレジットも、スコアも、すべて持ち越してセクター1に戻り、前回よりも深く進む。進行状況は永続的。リセットされるのは船体だけだ。

■ 2つのモード
エンドレス:6つのゾーンにまたがる18の手作りセクター。それぞれが60秒の緊密な構成で、独自の編隊とリズムを持つ。その先はジェネレーターが引き継ぎ、上限なく難易度が上がり続け、5レベルごとにボスが待ち受ける。
キャンペーン:20のノード、4体のボス、独立した進行とセーブデータ。各ノードにはクリア必須の任務と、任意の挑戦――ノーダメージ、装備縛り、タイムアタック――が用意されている。ボスは同じコアに毎回新たなパーツが加わって組み上がり、最後のボスはそれまでのすべてを背負って現れる。

■ 難易度を選べる
イージー、ノーマル、ハードの3段階。敵の耐久力、攻撃力、連射速度が変わり、高難易度ほどスコアも伸びる――つまり上位武器の解放も早くなる。そして、隠された4つ目の難易度も……。

■ 弾幕を読め
敵の弾はまっすぐ落ちてくるだけではない。狙い撃ち、拡散、バースト、一斉射撃。弾道を読み、隙間を縫え。

■ 属性別の破壊演出
敵は自分を倒した武器によって死に方が変わる。バブルガンは水しぶきに、キャノンは重く冷たい氷の欠片に、スターガンは炎と漂う残り火に、レーザーは稲妻の閃光に、ブラスターはマゼンタのプラズマ爆発に。どのキルも一目で分かる。

■ ガンシップを強化せよ
セクターの合間、コムセンターは自由に使える場所だ。フロントガン、サイドガン、ジェネレーター、ハルとシールド――すべて25段階まで強化できる。出力には限りがあり、重い武器を積めばジェネレーターの供給が追いつかなくなる。どの編成にもトレードオフがある。スコアは決してリセットされず、しきい値を超えるたびに上位武器ティアが永久に解放される。

■ 2人で、同じ部屋で
協力プレイはローカルWi-Fiの自動検出で動く――アカウントも、サーバーも、インターネットも不要。1台がホストとなり、もう1台が参加して、同じセクターを一緒に飛ぶ。ソロならオフラインでいつでも遊べる。

■ 24種のルック
スキンはゲーム全体を作り替える――船、敵、背景、インターフェース、サウンドまで。3種はアプリに無料で付属し、残り21種は1つずつの買い切り。広告なし、サブスクなし、ガチャなし、消費アイテムなし。

■ 手触りへのこだわり
GPUシェーダーがブルーム、スキャンライン、ビネット、色収差を描き出す。敵は自身のスプライトから切り出された物理演算の破片となって砕け散る。タッチ、キーボード、接続したコントローラーのいずれでもプレイできる。

Google Play Gamesのリーダーボードが、合計スコアと到達した最深レベルであなたを競わせる。キル数、セクター、無傷クリアの実績も用意。

※ゲーム内の表示は英語です。
```

■ headers instead of the English ALL-CAPS: Japanese has no case, and ■ is
the conventional section marker in Japanese Play listings.

The Play Games sentence matches the English Play listing; it is only true once
the Play Games IDs from `googleplay-listing.md` §4 are wired in. Cut it until
then.

## Release notes  (limit 500, per release)

```
<ja-JP>
難易度選択:イージー/ノーマル/ハードをエンドレスとキャンペーンの両方で。高難易度ほどスコアが伸び、上位武器の解放も早い。隠された4つ目の難易度も。
敵弾パターン:狙い撃ち、拡散、バースト、一斉射撃――敵の撃ち方が5種類に。
</ja-JP>
```

Paste with the `<ja-JP>` tags into the release's notes box alongside the
`<en-US>` block.

## In-app products

Names and descriptions per product: see `iap/iap-ja.md` (Play limits: name 55,
description 200 — the Play column there uses the longer form).
