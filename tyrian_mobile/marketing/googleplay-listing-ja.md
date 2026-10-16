# Google Play listing — Kirian (日本語 / ja-JP)

Play Console → Grow → Store presence → Main store listing → **Manage
translations → Add your own translations → 日本語 (ja-JP)**. Only the text
fields below are per-language; graphics are inherited from the default
listing unless you upload localized ones (use `screenshots-ja/play-*`).

Same facts as `appstore-listing-ja.md` — written for **v2.9.1** (14 skins / 11
paid, no Campaign, no difficulty selection; the v3.7.0 version is in commit
`a4245b3`). Play's limits differ from
Apple's and there is **no keywords field**: search reads title, short and full
description, so the search terms (弾幕, シューティング, STG, ローグライク, 縦スクロール,
協力プレイ, オフライン, 買い切り) live in the prose. Do not paste Apple's comma
list — Google treats keyword stuffing as a policy violation.

---

## App name  (limit 30)

<!-- check: name_ja 30 -->
```
Kirian: 死なない弾幕シューティング
```

**21 chars.** Same as the App Store name.

## Short description  (limit 80)

<!-- check: short_ja 80 -->
```
死んでも全部持ち越し。もっと深くへ。ローグライク縦スクロールSTG、2人協力プレイ対応。
```

**44 chars.** The line under the title in search results — the hook and the
genre in one breath.

## Full description  (limit 4000)

<!-- check: full_ja 4000 -->
```
孤独なガンシップを駆り、敵が果てしなく押し寄せる回廊を突き進め。ワンセクターはわずか60秒。

Kirianは、ローグライクのループを軸にした縦スクロール・アーケードシューティング(STG)だ。自機を失ってもランは終わらない――手に入れた武器も、クレジットも、スコアも、すべて持ち越してセクター1に戻り、前回よりも深く進む。進行状況は永続的。リセットされるのは船体だけだ。

■ 属性別の破壊演出
敵は自分を倒した武器によって死に方が変わる。バブルガンは水しぶきに、キャノンは重く冷たい氷の欠片に、スターガンは炎と漂う残り火に、レーザーは稲妻の閃光に、ブラスターはマゼンタのプラズマ爆発に。どのキルも一目で分かる。

■ ガンシップを強化せよ
セクターの合間、コムセンターは自由に使える場所だ。フロントガン、サイドガン、ジェネレーター、ハルとシールド――すべて25段階まで強化できる。出力には限りがあり、重い武器を積めばジェネレーターの供給が追いつかなくなる。どの編成にもトレードオフがある。スコアは決してリセットされず、しきい値を超えるたびに上位武器ティアが永久に解放される。

■ 手作りの戦場、その先は無限に
6つのゾーンにまたがる18の手作りセクター。それぞれが60秒の緊密な構成で、独自の編隊とリズムを持つ。奥へ進むにつれて空の色も冷たい青からティール、琥珀、深紅へと移り変わる。そこを抜けるとジェネレーターが引き継ぎ、上限なく難易度が上がり続け、5レベルごとにボスが待ち受ける。

■ 2人で、同じ部屋で
協力プレイはローカルWi-Fiの自動検出で動く――アカウントも、サーバーも、インターネットも不要。1台がホストとなり、もう1台が参加して、同じセクターを一緒に飛ぶ。ソロならオフラインでいつでも遊べる。

■ 14種のルック
スキンはゲーム全体を作り替える――船、敵、背景、インターフェース、サウンドまで。3種はアプリに無料で付属し、残り11種は1つずつの買い切り。広告なし、サブスクなし、ガチャなし、消費アイテムなし。

■ 手触りへのこだわり
GPUシェーダーがブルーム、スキャンライン、ビネット、色収差を描き出す。敵は自身のスプライトから切り出された物理演算の破片となって砕け散る。タッチ、キーボード、接続したコントローラーのいずれでもプレイできる。

Google Play Gamesのリーダーボードが、合計スコアと到達した最深レベルであなたを競わせる。キル数、セクター、無傷クリアの実績も用意。

※ゲーム内の表示は英語です。
```

■ headers instead of the English ALL-CAPS: Japanese has no case, and ■ is
the conventional section marker in Japanese Play listings.

The Play Games sentence matches the English Play listing; it becomes true with
2.9.2, the Production build that carries the Play Games IDs (see
`googleplay-listing.md` → Play Games Services).

## Release notes  (limit 500, per release)

First production release (2.9.2), same facts as the en-US notes:

<!-- check: notes_ja 500 -->
```
Google Playで配信開始。14種のスキン(3種は無料)。Google Play Gamesのリーダーボードと実績に対応。
```

Paste inside `<ja-JP>…</ja-JP>` tags with the `<ja-JP>` tags into the release's notes box alongside the
`<en-US>` block.

## In-app products

Names and descriptions per product: see `iap/iap-ja.md` (Play limits: name 55,
description 200 — the Play column there uses the longer form).
