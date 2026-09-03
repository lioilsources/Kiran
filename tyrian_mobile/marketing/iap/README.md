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

| File | Product ID |
|---|---|
| `skin_tempest_review.png` | `com.ol1n.kiran.skin_tempest` |
| `skin_solar_striker_review.png` | `com.ol1n.kiran.skin_solar_striker` |
| `skin_star_fox_review.png` | `com.ol1n.kiran.skin_star_fox` |
