# Qwen-Image microservice

Self-hosted image backend for the Tyrian asset pipeline, replacing the
external xAI Grok Image API. A small FastAPI service wraps a quantized
Qwen-Image diffusion pipeline; the Go `qwenimage.Client`
(`internal/qwenimage`) talks to it over the same request/response shape
the rest of the pipeline already uses, so post-process, atlas packing,
and manifests are unchanged.

> This Python subdirectory is intentionally outside the Go module's
> zero-dependency constraint. Versions are pinned in `requirements.txt`
> for reproducibility.

## Why a microservice (not ComfyUI)

The pipeline already has a clean synchronous `imagegen.Generate` contract.
FastAPI maps to it 1:1; ComfyUI is a stateful async queue that would only
add a polling shim. The hard problem here is prompt adherence across 13
precise art directions — Qwen-Image's strength — not node graphs. Optional
matting (e.g. BiRefNet) can later be added as a separate microservice
behind the same interface without coupling the pipeline to ComfyUI.

## Hardware target: NVIDIA DGX Spark (GB10)

- 128 GB unified LPDDR5X, ARM64, CUDA.
- FP8 weight-only quantization keeps the ~20B DiT + Qwen2.5-VL text
  encoder + VAE around ~25–30 GB — everything stays resident on CUDA.
  No CPU offload (unified-memory bandwidth makes offload slow).
- 8-step lightning LoRA + `true_cfg_scale=1.0` → a few seconds/image at
  1024², so a full ~1.5k-image run finishes well under an hour with `n`
  batched per call.

## Setup

Run inside the NVIDIA NGC PyTorch container (torch is already
CUDA-matched for GB10/ARM64):

```bash
cd pipeline/qwen_service
docker run --rm -it --gpus all --network host \
  -v "$HOME/.cache/huggingface:/root/.cache/huggingface" \
  -v "$PWD:/srv" -w /srv \
  nvcr.io/nvidia/pytorch:24.12-py3 \
  bash run.sh
```

`run.sh` pip-installs `requirements.txt` on top of the container's torch
and starts the service on `:8080`. The mounted Hugging Face cache
persists the (large) Qwen-Image weights across restarts.

Smoke test:

```bash
curl -s localhost:8080/healthz
curl -s -X POST localhost:8080/v1/images/generations \
  -H 'Content-Type: application/json' \
  -d '{"prompt":"a red triangle on a flat solid grey background","n":1,"width":1024,"height":1024,"steps":8}' \
  | python -c 'import sys,json,base64;open("out.jpg","wb").write(base64.b64decode(json.load(sys.stdin)["data"][0]["b64_json"]))'
```

## Service environment variables

| Var | Default | Purpose |
|-----|---------|---------|
| `QWEN_MODEL` | `Qwen/Qwen-Image` | Base model repo |
| `QWEN_USE_LIGHTNING` | `1` | Load+fuse the 8-step lightning LoRA |
| `QWEN_LIGHTNING_LORA` | `lightx2v/Qwen-Image-Lightning` | LoRA repo |
| `QWEN_LIGHTNING_LORA_WEIGHT` | `Qwen-Image-Lightning-8steps-V1.0.safetensors` | LoRA weight file |
| `QWEN_QUANTIZE` | `fp8` | `fp8` = optimum-quanto FP8; anything else = off |
| `QWEN_STEPS_DEFAULT` | `8` | Default steps if request omits it |
| `QWEN_TRUE_CFG` | `1.0` | `true_cfg_scale` (lightning recipe) |
| `QWEN_JPEG_QUALITY` | `95` | Output JPEG quality |
| `QWEN_NEGATIVE_PROMPT` | (clean-bg biasing) | Negative prompt |
| `QWEN_API_TOKEN` | (unset) | If set, require `Authorization: Bearer <token>` |
| `QWEN_HOST` / `QWEN_PORT` | `0.0.0.0` / `8080` | Bind address |

## Pointing the Go pipeline at it

The `generate` command selects the backend with `-backend` and reads the
service URL/token from the environment (also loadable via a `.env` file
in the pipeline working dir):

```bash
# .env or shell env
QWEN_API_URL=http://<spark-host>:8080
QWEN_API_TOKEN=        # optional; must match the service's QWEN_API_TOKEN
```

```bash
cd pipeline

# Prompt preview only (no service needed):
go run ./cmd/generate -backend=qwen -skin=space_invaders -dry-run

# Single asset end-to-end:
QWEN_API_URL=http://<spark-host>:8080 \
  go run ./cmd/generate -backend=qwen -skin=space_invaders -asset-type=bullet -n=2

# A/B against Grok into a separate dir for visual comparison:
go run ./cmd/generate -backend=grok -skin=tyrian_dos -out=output/grok
go run ./cmd/generate -backend=qwen -skin=tyrian_dos -out=output/qwen
```

Extra flags: `-steps` (diffusion steps, default 8) applies to the qwen
backend. The `-model` flag is Grok-only; with `-backend=qwen` the
manifest records `qwen-image`.

Aspect/resolution map to pixels: `1:1`+`1k` → 1024², `1:1`+`2k` → 2048²,
`1:2`+`2k` → 1024×2048 (backgrounds), `1:2`+`1k` → 512×1024.

Post-process is unchanged — the service returns flat-background JPEG that
the existing corner-key + resize step turns into transparent PNGs:

```bash
go run ./cmd/postprocess -skin=space_invaders
dart run tool/pack_atlas.dart   # from tyrian_mobile/
```
