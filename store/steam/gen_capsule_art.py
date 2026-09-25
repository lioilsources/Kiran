"""Background plates for the Steam capsules, generated on the project's ComfyUI.

Steam wants capsule art in aspect ratios nothing in the game produces: the
shipped backgrounds are 512x1024 portrait tiles and the generated ones 1024x2048,
so every capsule here is new art rather than a crop. The look is pinned to the
Play/App Store feature graphic — night refinery, orange fire column, cyan rim
light on a dark hull — so the storefronts read as one game.

Text is deliberately absent from the prompt: wordmarks come from
make_capsules.py, where they stay editable and crisp at every size.

    python3 store/steam/gen_capsule_art.py               # all plates, 3 variants
    python3 store/steam/gen_capsule_art.py -only hero -n 6

Output: store/steam/art/<plate>_v<N>.png
"""
import argparse
import json
import pathlib
import random
import sys
import time
import urllib.parse
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[2]
WORKFLOW = ROOT / 'pipeline/internal/comfyuiimage/workflows/flux_sprite.json'
OUT = ROOT / 'store/steam/art'

# Three things this prompt is deliberately NOT saying, each learned from a
# bad batch:
#   "cinematic"  — flux reads it as a film still and bakes black letterbox bars
#                  into the image, which no amount of cropping recovers.
#   "cyan light" — it renders a literal light source (a lens-flare star, a blue
#                  smear) instead of ambience. The cyan belongs to the ship, and
#                  make_capsules.py composites it there, as the feature graphic
#                  already does.
#   "deep black" — a capsule is browsed at 462x174. Plates came back so dark
#                  they read as a black rectangle at that size, so the fire now
#                  has to light the scene rather than sit in the dark.
LOOK = (
    'night industrial refinery seen from a distance, silhouetted steel towers, '
    'pipework and storage tanks along the horizon, a towering column of orange '
    'fire and billowing smoke erupting behind them, the fire lighting the smoke '
    'and haze from within, warm orange glow filling the sky, rich amber '
    'midtones, glowing embers drifting, painterly game key art, high detail, '
    'full bleed illustration filling the whole frame, no letterbox, no black '
    'bars, no text, no lettering, no logos, no people, no figures'
)

# Flux is trained near one megapixel; generating far above it drifts and
# repeats. Each plate is generated close to 1MP at the target aspect and
# upscaled in make_capsules.py, which is far safer than asking for 3840px here.
PLATES = {
    # 1232x706 main capsule and 920x430 header both crop from this.
    'wide': (1344, 768, 'wide horizontal composition, the fire column on the right, '
             'the left third quieter and darker to leave room for a title'),
    # 3840x1240 hero: much wider, so it needs its own framing.
    'hero': (1536, 512, 'ultrawide panorama, the fire column offset to the right, '
             'the left half a quieter smoky horizon'),
    # 600x900 library capsule: portrait, the ship reads as the subject.
    'portrait': (832, 1216, 'vertical composition, the fire column filling the upper half, '
                 'a quieter smoky band across the lower third'),
}


def submit(base, workflow):
    req = urllib.request.Request(
        f'{base}/prompt',
        data=json.dumps({'prompt': workflow}).encode(),
        headers={'Content-Type': 'application/json'},
    )
    return json.loads(urllib.request.urlopen(req, timeout=30).read())['prompt_id']


def wait(base, prompt_id, timeout=900):
    """Poll history until the job lands. SPARK is shared with other projects,
    so a job can sit queued behind someone else's work for a long time — that
    is a wait, not a failure, and the timeout is generous for that reason."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        with urllib.request.urlopen(f'{base}/history/{prompt_id}', timeout=30) as r:
            hist = json.loads(r.read())
        if prompt_id in hist:
            return hist[prompt_id]['outputs']
        time.sleep(3)
    raise TimeoutError(f'{prompt_id} did not finish within {timeout}s')


def fetch(base, image):
    q = urllib.parse.urlencode({
        'filename': image['filename'],
        'subfolder': image.get('subfolder', ''),
        'type': image.get('type', 'output'),
    })
    with urllib.request.urlopen(f'{base}/view?{q}', timeout=120) as r:
        return r.read()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-only', choices=sorted(PLATES), help='generate one plate')
    ap.add_argument('-n', type=int, default=3, help='variants per plate')
    ap.add_argument('-url', default=None, help='ComfyUI base URL')
    ap.add_argument('-seed', type=int, default=None, help='fixed first seed')
    args = ap.parse_args()

    base = args.url
    if not base:
        env = (ROOT / 'pipeline/.env').read_text()
        for line in env.splitlines():
            if line.startswith('COMFYUI_API_URL='):
                base = line.split('=', 1)[1].strip()
    if not base:
        sys.exit('no COMFYUI_API_URL in pipeline/.env and no -url given')

    template = json.loads(WORKFLOW.read_text())
    OUT.mkdir(parents=True, exist_ok=True)
    plates = [args.only] if args.only else list(PLATES)

    for plate in plates:
        w, h, framing = PLATES[plate]
        for i in range(1, args.n + 1):
            wf = json.loads(json.dumps(template))  # deep copy per job
            wf['4']['inputs']['text'] = f'{LOOK}, {framing}'
            wf['6']['inputs']['width'] = w
            wf['6']['inputs']['height'] = h
            seed = (args.seed + i - 1) if args.seed else random.randint(1, 2**31)
            wf['8']['inputs']['seed'] = seed
            wf['10']['inputs']['filename_prefix'] = f'kirian_capsule_{plate}'

            pid = submit(base, wf)
            print(f'{plate} v{i}  {w}x{h}  seed={seed}  {pid}', flush=True)
            outputs = wait(base, pid)
            for node in outputs.values():
                for img in node.get('images', []):
                    dest = OUT / f'{plate}_v{i}.png'
                    dest.write_bytes(fetch(base, img))
                    print(f'  -> {dest.relative_to(ROOT)}', flush=True)


if __name__ == '__main__':
    main()
