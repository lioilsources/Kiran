# 35 — Handoff pro MacBook: review screenshoty balíčku „Všechny skiny“

Pro session na MacBooku (Xcode + simulátor). Na M2 se screenshoty nedělají (DevConventions
`shared/stacks/flutter.md`).

## Proč

V App Store Connect je 5 nových produktů balíčku „Všechny skiny“ (PR #85, popis
`marketing/iap/README.md`). Všechny jsou ve stavu MISSING_METADATA, protože jim chybí jen review
screenshot. Bez něj nepůjdou s příští verzí do review.

| Produkt | Cena | Nabízí se, když hráč vlastní |
|---|---|---|
| `com.ol1n.kiran.skins_all` | 4,99 USD | 0 placených skinů |
| `com.ol1n.kiran.skins_all_s1` | 3,99 USD | 1 |
| `com.ol1n.kiran.skins_all_s2` | 2,99 USD | 2 |
| `com.ol1n.kiran.skins_all_s3` | 1,99 USD | 3 |
| `com.ol1n.kiran.skins_all_s4` | 0,99 USD | 4 a víc |

## Co udělat

1. `git pull` na `main`.
2. **Lokální StoreKit konfigurace, ne sandbox.** Produkty v MISSING_METADATA se v sandboxu nenačtou.
   Do `tyrian_mobile/ios/SkinStore.storekit` přidej těch 5 produktů jako non-consumable
   s cenami z tabulky a ve schématu Runner ji nech zapnutou (Run → Options → StoreKit
   Configuration).
3. Spusť appku na simulátoru **iPhone 6.9"** (např. iPhone 16 Pro Max), angličtina.
4. Vyfoť `SkinSelector` (výběr lodí) se zamčenými skiny a čipem **ALL SKINS**:
   - `skins_all.png`: čistá instalace, nic koupeno, čip ukazuje 4,99 bez přeškrtnutí.
   - `skins_all_s2.png`: nejdřív v appce kup 2 libovolné skiny (lokální StoreKit), pak vyfoť.
     Čip ukazuje 2,99, přeškrtnuté 4,99 a pod mřížkou řádek o odečtení.
5. Ulož do `tyrian_mobile/marketing/iap/review/` a pushni (soubory jmenovitě).
6. Pošli session **Store** zprávu s cestou. Store nahraje review screenshoty:
   - `skins_all.png` → `skins_all`;
   - `skins_all_s2.png` → `skins_all_s1` až `_s4`.

   Apple chce jen ukázku, kde se produkt v appce kupuje, jeden obrázek na všechny stupně stačí.

## Hotovo, když

Oba PNG jsou v `main` a Store potvrdí, že produkty přešly z MISSING_METADATA do READY_TO_SUBMIT.

Nic neodesílej k review a neměň produkty v ASC. Verze s produkty vyjde až s novým pozadím,
bossy a předměty.
