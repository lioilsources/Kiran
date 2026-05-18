"""Qwen-Image generation microservice for the Tyrian asset pipeline.

Exposes a single endpoint that mirrors the request/response shape the Go
`qwenimage.Client` expects:

    POST /v1/images/generations
    {"prompt": str, "n": 1, "width": 1024, "height": 1024,
     "steps": 8, "seed": -1}
    -> {"data": [{"b64_json": "<base64 JPEG bytes>"}]}

Images are returned as base64-encoded JPEG (RGB, no alpha) on the flat
solid background the prompt asks for. The existing Go post-process
(corner-key + resize) consumes these directly — no alpha is expected.

Tuned for NVIDIA DGX Spark (GB10, 128 GB unified, ARM64):
  * FP8 weight-only quantization (optimum-quanto) keeps the ~20B DiT +
    Qwen2.5-VL text encoder + VAE around ~25-30 GB, well inside 128 GB,
    so everything stays resident on CUDA (no CPU offload — LPDDR5X
    bandwidth makes offload slow).
  * 8-step lightning LoRA + true_cfg_scale=1.0 for fast inference.

Configuration is via environment variables (see README.md). Defaults are
chosen to "just work" on a fresh Spark; pin versions via requirements.txt.
"""

from __future__ import annotations

import base64
import io
import os
import threading
from typing import Optional

import torch
import uvicorn
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel, Field

# ---------------------------------------------------------------------------
# Configuration (env-driven)
# ---------------------------------------------------------------------------

MODEL_ID = os.getenv("QWEN_MODEL", "Qwen/Qwen-Image")
# Qwen-Image 8-step lightning LoRA. Override the repo/weight if you mirror
# the weights locally or a newer revision ships.
LIGHTNING_LORA_REPO = os.getenv("QWEN_LIGHTNING_LORA", "lightx2v/Qwen-Image-Lightning")
LIGHTNING_LORA_WEIGHT = os.getenv(
    "QWEN_LIGHTNING_LORA_WEIGHT", "Qwen-Image-Lightning-8steps-V1.0.safetensors"
)
USE_LIGHTNING = os.getenv("QWEN_USE_LIGHTNING", "1") != "0"
QUANTIZE_FP8 = os.getenv("QWEN_QUANTIZE", "fp8").lower() == "fp8"
DEFAULT_STEPS = int(os.getenv("QWEN_STEPS_DEFAULT", "8"))
TRUE_CFG_SCALE = float(os.getenv("QWEN_TRUE_CFG", "1.0"))
JPEG_QUALITY = int(os.getenv("QWEN_JPEG_QUALITY", "95"))
# Optional shared-secret. When set, requests must send
# `Authorization: Bearer <token>`.
API_TOKEN = os.getenv("QWEN_API_TOKEN", "")
HOST = os.getenv("QWEN_HOST", "0.0.0.0")
PORT = int(os.getenv("QWEN_PORT", "8080"))

# Negative prompt biasing toward the clean flat-background sprites the
# pipeline keys against.
NEGATIVE_PROMPT = os.getenv(
    "QWEN_NEGATIVE_PROMPT",
    "busy background, scene, gradient background, watermark, text, "
    "signature, blurry, low quality, jpeg artifacts",
)

# A single shared pipeline; generation is serialized with a lock because
# one GB10 serves one diffusion job at a time anyway.
_pipe = None
_pipe_lock = threading.Lock()


def _load_pipeline():
    """Load Qwen-Image once: FP8 quantize, fuse lightning LoRA, move to CUDA."""
    from diffusers import DiffusionPipeline

    dtype = torch.bfloat16
    pipe = DiffusionPipeline.from_pretrained(MODEL_ID, torch_dtype=dtype)

    if USE_LIGHTNING:
        # Lightning LoRA: load + fuse so we can drop guidance and use ~8 steps.
        pipe.load_lora_weights(LIGHTNING_LORA_REPO, weight_name=LIGHTNING_LORA_WEIGHT)
        pipe.fuse_lora()
        pipe.unload_lora_weights()

    if QUANTIZE_FP8:
        # Weight-only FP8 via optimum-quanto. Quantize the heavy modules
        # (DiT transformer + text encoder); VAE stays bf16 (cheap, quality).
        from optimum.quanto import freeze, qfloat8, quantize

        for module in (getattr(pipe, "transformer", None), getattr(pipe, "text_encoder", None)):
            if module is not None:
                quantize(module, weights=qfloat8)
                freeze(module)

    pipe.to("cuda")
    pipe.set_progress_bar_config(disable=True)
    return pipe


def _get_pipeline():
    global _pipe
    if _pipe is None:
        with _pipe_lock:
            if _pipe is None:
                _pipe = _load_pipeline()
    return _pipe


# ---------------------------------------------------------------------------
# HTTP API
# ---------------------------------------------------------------------------

app = FastAPI(title="qwen-image-service", version="1.0")


class GenerateRequest(BaseModel):
    prompt: str
    n: int = Field(default=1, ge=1, le=8)
    width: int = Field(default=1024, ge=64, le=2048)
    height: int = Field(default=1024, ge=64, le=2048)
    steps: int = Field(default=DEFAULT_STEPS, ge=1, le=50)
    seed: int = -1


class ImageData(BaseModel):
    b64_json: str


class GenerateResponse(BaseModel):
    data: list[ImageData]


def _check_auth(authorization: Optional[str]) -> None:
    if not API_TOKEN:
        return
    if authorization != f"Bearer {API_TOKEN}":
        raise HTTPException(status_code=401, detail="invalid or missing token")


def _encode_jpeg(image) -> str:
    buf = io.BytesIO()
    image.convert("RGB").save(buf, format="JPEG", quality=JPEG_QUALITY)
    return base64.b64encode(buf.getvalue()).decode("ascii")


@app.get("/healthz")
def healthz():
    return {"status": "ok", "model": MODEL_ID, "loaded": _pipe is not None}


@app.post("/v1/images/generations", response_model=GenerateResponse)
def generate(req: GenerateRequest, authorization: Optional[str] = Header(default=None)):
    _check_auth(authorization)

    pipe = _get_pipeline()

    if req.seed is not None and req.seed >= 0:
        generator = [
            torch.Generator(device="cuda").manual_seed(req.seed + i)
            for i in range(req.n)
        ]
    else:
        generator = None

    # Serialize: a single GB10 handles one diffusion batch at a time.
    with _pipe_lock:
        try:
            result = pipe(
                prompt=req.prompt,
                negative_prompt=NEGATIVE_PROMPT,
                width=req.width,
                height=req.height,
                num_inference_steps=req.steps,
                true_cfg_scale=TRUE_CFG_SCALE,
                num_images_per_prompt=req.n,
                generator=generator,
            )
        except TypeError:
            # Older/newer diffusers may not expose `true_cfg_scale`; retry
            # with the classic `guidance_scale` knob instead.
            result = pipe(
                prompt=req.prompt,
                negative_prompt=NEGATIVE_PROMPT,
                width=req.width,
                height=req.height,
                num_inference_steps=req.steps,
                guidance_scale=TRUE_CFG_SCALE,
                num_images_per_prompt=req.n,
                generator=generator,
            )

    return GenerateResponse(data=[ImageData(b64_json=_encode_jpeg(img)) for img in result.images])


if __name__ == "__main__":
    uvicorn.run(app, host=HOST, port=PORT)
