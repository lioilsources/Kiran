"""Animates the approved capsule plate into the trailer's closing sting.

    python3 store/steam/gen_sting.py            # 5 s from wide_v2
    python3 store/steam/gen_sting.py -plate hero_v2 -length 121 -n 2

Output: store/steam/video/sting_v<N>.webm

Image-to-video, not text-to-video, and that is the whole point. The sting has
to be the same refinery the store page already shows, so it starts from the
capsule plate that was approved and adds motion to it. A t2v prompt would
invent a different refinery and the trailer would stop matching the page.

Scope, deliberately: this is the only generated footage in the film, it sits
behind the logo at 1:06, and it must not read as gameplay. See
trailer-script.md.

Runs on the project's remote ComfyUI (Wan 2.2 TI2V 5B), which sits behind
Cloudflare Access — credentials come from pipeline/.env, never the command
line.
"""
import argparse
import json
import mimetypes
import pathlib
import random
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid

from PIL import Image

ROOT = pathlib.Path(__file__).resolve().parents[2]
ART = ROOT / 'store/steam/art'
OUT = ROOT / 'store/steam/video'
ENV = ROOT / 'pipeline/.env'

BASE = 'https://comfyui.ol1n.com'

# Cloudflare's Browser Integrity Check answers a default urllib user-agent with
# HTTP 403 and "error code: 1010", which looks exactly like a rejected Access
# token and is not one. A browser UA is what makes the service token usable.
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/140.0 Safari/537.36')

# Wan 2.2 TI2V 5B is native at 1280x704 / 24 fps. Generating at its own
# resolution and upscaling to 1080p in the edit beats asking it for 1080p.
WIDTH, HEIGHT, FPS = 1280, 704, 24

MODEL = 'wan2.2_ti2v_5B_fp16.safetensors'
CLIP = 'umt5_xxl_fp8_e4m3fn_scaled.safetensors'
VAE = 'wan2.2_vae.safetensors'

POSITIVE = (
    'slow cinematic push in on a burning night refinery, the column of fire '
    'billowing and curling upward, thick smoke drifting across the frame, '
    'embers rising and floating, heat haze shimmering over the silhouetted '
    'towers, subtle flicker of orange light on the structures'
)
# The camera must stay calm and the scene must stay empty: anything that moves
# like a player would makes the sting read as gameplay, which is the one thing
# this shot must not do.
NEGATIVE = (
    'spacecraft, ship, aircraft, flying vehicle, people, figures, text, '
    'letters, logo, watermark, ui, hud, fast camera movement, shaking, '
    'zooming out, cuts, flashing, cartoon, low quality, blurry'
)


def env():
    out = {}
    for line in ENV.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith('#') and '=' in line:
            k, v = line.split('=', 1)
            out[k.strip()] = v.strip()
    return out


def headers(e, extra=None):
    h = {'User-Agent': UA}
    if e.get('CF_ACCESS_CLIENT_ID'):
        h['CF-Access-Client-Id'] = e['CF_ACCESS_CLIENT_ID']
        h['CF-Access-Client-Secret'] = e['CF_ACCESS_CLIENT_SECRET']
    h.update(extra or {})
    return h


def upload(e, path):
    """POST the start frame to ComfyUI's input folder, multipart by hand."""
    boundary = uuid.uuid4().hex
    ctype = mimetypes.guess_type(path.name)[0] or 'application/octet-stream'
    body = b''.join([
        f'--{boundary}\r\n'.encode(),
        f'Content-Disposition: form-data; name="image"; filename="{path.name}"\r\n'.encode(),
        f'Content-Type: {ctype}\r\n\r\n'.encode(),
        path.read_bytes(),
        f'\r\n--{boundary}\r\n'.encode(),
        b'Content-Disposition: form-data; name="overwrite"\r\n\r\ntrue\r\n',
        f'--{boundary}--\r\n'.encode(),
    ])
    req = urllib.request.Request(
        f'{BASE}/upload/image', data=body,
        headers=headers(e, {'Content-Type': f'multipart/form-data; boundary={boundary}'}))
    return json.loads(urllib.request.urlopen(req, timeout=120).read())['name']


def graph(image_name, length, seed, prefix):
    return {
        '1': {'class_type': 'UNETLoader',
              'inputs': {'unet_name': MODEL, 'weight_dtype': 'default'}},
        '2': {'class_type': 'CLIPLoader',
              'inputs': {'clip_name': CLIP, 'type': 'wan', 'device': 'default'}},
        '3': {'class_type': 'VAELoader', 'inputs': {'vae_name': VAE}},
        '4': {'class_type': 'LoadImage', 'inputs': {'image': image_name}},
        # shift 8.0 rather than the node default 3.0: Wan 2.2 video is trained
        # for the higher shift and drifts badly at the default.
        '5': {'class_type': 'ModelSamplingSD3',
              'inputs': {'model': ['1', 0], 'shift': 8.0}},
        '6': {'class_type': 'CLIPTextEncode',
              'inputs': {'clip': ['2', 0], 'text': POSITIVE}},
        '7': {'class_type': 'CLIPTextEncode',
              'inputs': {'clip': ['2', 0], 'text': NEGATIVE}},
        '8': {'class_type': 'WanImageToVideo',
              'inputs': {'positive': ['6', 0], 'negative': ['7', 0],
                         'vae': ['3', 0], 'width': WIDTH, 'height': HEIGHT,
                         'length': length, 'batch_size': 1,
                         'start_image': ['4', 0]}},
        '9': {'class_type': 'KSampler',
              'inputs': {'model': ['5', 0], 'positive': ['8', 0],
                         'negative': ['8', 1], 'latent_image': ['8', 2],
                         'seed': seed, 'steps': 30, 'cfg': 5.0,
                         'sampler_name': 'uni_pc', 'scheduler': 'simple',
                         'denoise': 1.0}},
        '10': {'class_type': 'VAEDecode',
               'inputs': {'samples': ['9', 0], 'vae': ['3', 0]}},
        '11': {'class_type': 'SaveWEBM',
               'inputs': {'images': ['10', 0], 'filename_prefix': prefix,
                          'codec': 'vp9', 'fps': float(FPS), 'crf': 20.0}},
    }


def submit(e, wf):
    req = urllib.request.Request(
        f'{BASE}/prompt', data=json.dumps({'prompt': wf}).encode(),
        headers=headers(e, {'Content-Type': 'application/json'}))
    try:
        return json.loads(urllib.request.urlopen(req, timeout=60).read())['prompt_id']
    except urllib.error.HTTPError as err:
        sys.exit(f'submit rejected: HTTP {err.code}\n{err.read().decode()[:1500]}')


def get_json(e, path, tries=6):
    """GET with retries. The box is behind a Cloudflare tunnel that returns
    502/503 while ComfyUI is loading a 5B model or restarting — a poll must
    ride that out rather than kill a job that is still sampling."""
    for i in range(tries):
        try:
            r = urllib.request.urlopen(
                urllib.request.Request(BASE + path, headers=headers(e)), timeout=60)
            return json.loads(r.read())
        except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError) as err:
            code = getattr(err, 'code', None)
            if code is not None and code not in (502, 503, 504):
                raise
            if i == tries - 1:
                raise
            time.sleep(5 * (i + 1))
    return None


def wait(e, pid, timeout=3600):
    """Video sampling is slow and the box is shared, so the ceiling is an hour."""
    start = time.time()
    while time.time() - start < timeout:
        hist = get_json(e, f'/history/{pid}')
        if pid in hist:
            entry = hist[pid]
            status = entry.get('status', {})
            if status.get('status_str') == 'error':
                sys.exit('job failed:\n' + json.dumps(status, indent=2)[:2000])
            return entry['outputs']
        # An empty queue with the job absent from history means ComfyUI
        # restarted under us and dropped it; waiting the full hour for a job
        # that no longer exists helps nobody.
        q = get_json(e, '/queue')
        if not q['queue_running'] and not q['queue_pending']:
            hist = get_json(e, f'/history/{pid}')
            if pid not in hist:
                sys.exit(f'{pid} vanished — queue empty and no history. '
                         'ComfyUI most likely restarted; resubmit.')
        time.sleep(10)
    raise TimeoutError(f'{pid} still running after {timeout}s')


def fetch(e, item):
    q = urllib.parse.urlencode({'filename': item['filename'],
                                'subfolder': item.get('subfolder', ''),
                                'type': item.get('type', 'output')})
    r = urllib.request.urlopen(
        urllib.request.Request(f'{BASE}/view?{q}', headers=headers(e)), timeout=600)
    return r.read()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-plate', default='wide_v2', help='plate stem in store/steam/art')
    ap.add_argument('-length', type=int, default=121,
                    help='frames; 121 @ 24fps = ~5 s (must be 4n+1)')
    ap.add_argument('-n', type=int, default=1, help='variants')
    ap.add_argument('-seed', type=int, default=None)
    args = ap.parse_args()

    e = env()
    if not e.get('CF_ACCESS_CLIENT_ID'):
        sys.exit('CF_ACCESS_CLIENT_ID missing from pipeline/.env')

    src = ART / f'{args.plate}.png'
    if not src.exists():
        sys.exit(f'{src} not found — run gen_capsule_art.py first')

    OUT.mkdir(parents=True, exist_ok=True)
    staged = OUT / f'_start_{args.plate}.png'
    im = Image.open(src).convert('RGB')
    scale = max(WIDTH / im.width, HEIGHT / im.height)
    im = im.resize((round(im.width * scale), round(im.height * scale)), Image.LANCZOS)
    left, top = (im.width - WIDTH) // 2, (im.height - HEIGHT) // 2
    im.crop((left, top, left + WIDTH, top + HEIGHT)).save(staged)
    name = upload(e, staged)
    print(f'start frame: {name}  {WIDTH}x{HEIGHT}')

    for i in range(1, args.n + 1):
        seed = (args.seed + i - 1) if args.seed else random.randint(1, 2**31)
        pid = submit(e, graph(name, args.length, seed, f'kirian_sting_v{i}'))
        print(f'v{i}  {args.length}f @ {FPS}fps (~{args.length / FPS:.1f}s)  '
              f'seed={seed}  {pid}', flush=True)
        for node in wait(e, pid).values():
            for key in ('images', 'videos', 'gifs'):
                for item in node.get(key, []):
                    dest = OUT / f'sting_v{i}.webm'
                    dest.write_bytes(fetch(e, item))
                    print(f'  -> {dest.relative_to(ROOT)}', flush=True)


if __name__ == '__main__':
    main()
