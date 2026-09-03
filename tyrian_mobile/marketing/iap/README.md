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
