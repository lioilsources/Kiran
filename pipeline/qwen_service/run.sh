#!/usr/bin/env bash
# Launch the Qwen-Image microservice on DGX Spark.
#
# Recommended: run inside the NVIDIA NGC PyTorch container so torch is
# already CUDA-matched for GB10 (ARM64). Example:
#
#   docker run --rm -it --gpus all --network host \
#     -v "$HOME/.cache/huggingface:/root/.cache/huggingface" \
#     -v "$PWD:/srv" -w /srv \
#     nvcr.io/nvidia/pytorch:24.12-py3 \
#     bash run.sh
#
# HF_HOME / the mounted huggingface cache persists model weights across
# container restarts (Qwen-Image is large — download once).
set -euo pipefail

cd "$(dirname "$0")"

export HF_HOME="${HF_HOME:-$HOME/.cache/huggingface}"
export QWEN_HOST="${QWEN_HOST:-0.0.0.0}"
export QWEN_PORT="${QWEN_PORT:-8080}"

# Install service deps on top of the container's torch (idempotent).
python -m pip install --no-cache-dir -r requirements.txt

exec python app.py
