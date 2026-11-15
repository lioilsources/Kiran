# Review screenshots for in-app purchases

App Store Connect wants a review screenshot on every in-app purchase, and the
upload rejects anything under 640×920. The skin previews the game ships are
512×512 opaque cards, so they cannot be uploaded as-is — these are composed
from that same art at 1242×2208.

Each shows what the buyer gets: the skin's own preview illustration, its name
and year, and one line on what the purchase covers. Nothing here imitates app
UI that does not exist.

Regenerate after re-rolling a skin's `ui/preview.png`; the ImageMagick call is
in the commit that added this directory.

| File | Reference Name | Product ID |
|---|---|---|
| `skin_tempest_review.png` | Neon Tube Skin | `com.ol1n.kiran.skin_tempest` |
| `skin_solar_striker_review.png` | Pocket Mono Skin | `com.ol1n.kiran.skin_solar_striker` |
| `skin_star_fox_review.png` | Flat Polygon Skin | `com.ol1n.kiran.skin_star_fox` |

Reference Name is the column to search on in App Store Connect — the file names
key on the skin id, which is what the repo uses, and the two do not always
match. `fantasy_zone` is the standing example: its product had to be recreated
as `com.ol1n.kiran.skin_candy_drift` under the reference name
`Candy Drift Skin (1986)`, because App Store Connect reserves both the product
id and the reference name permanently on first save and returns neither when
the product is deleted.

## "All skins" bundle — complete-the-set ladder

**Status: manual step, not done yet.** The code queries these five products
(`kSkinsAllLadder` in `lib/services/skin_registry.dart`), but none of them
exists in App Store Connect or Play Console yet. Until they do, the store
returns nothing for them and the app hides the bundle. Create them by hand
in both consoles. They need a new app version to ship. Product ids, prices
and the number of steps are permanent once saved, so confirm them with the
owner first.

All five are non-consumable and unlock identical content: every paid skin,
including skins added later. The app offers exactly one of them, chosen by how
many paid skins the player already owns. It shows the offered step's store
price and, on steps 1–4, step 0's store price struck through. It never computes
an amount itself. The design is `Prompts/01-COMPLETE_THE_SET_PLAN.md` in the
Pass repo.

| Step | Product ID | Price (USD price point) | Offered at owned paid skins |
|---|---|---|---|
| 0 | `com.ol1n.kiran.skins_all` | 4.99 | 0 |
| 1 | `com.ol1n.kiran.skins_all_s1` | 3.99 | 1 |
| 2 | `com.ol1n.kiran.skins_all_s2` | 2.99 | 2 |
| 3 | `com.ol1n.kiran.skins_all_s3` | 1.99 | 3 |
| 4 | `com.ol1n.kiran.skins_all_s4` | 0.99 | 4 and more |

- Prices are USD price points; let the store convert other currencies, do not
  tune local prices by hand.
- Same display name and the same paywall review screenshot on all five
  (the Reference Name has to differ, e.g. `All Skins`, `All Skins s1`, …).
- Do **not** promote steps 1–4 in the App Store: a promoted product can be
  bought from the product page, outside the app's choice of step.
- Review note, identical on all five:

  > Complete-the-set pricing: these products unlock identical content. The app
  > offers exactly one of them, chosen by how many items the customer already
  > owns, so earlier purchases are credited.
