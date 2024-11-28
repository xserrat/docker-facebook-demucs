# Base image supports Nvidia CUDA but does not require it and can also run demucs on the CPU
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ARG gpu

USER root
ENV TORCH_HOME=/data/models
ENV OMP_NUM_THREADS=1

# Install required tools
# Notes:
#  - build-essential and python3-dev are included for platforms that may need to build some Python packages (e.g., arm64)
#  - torchaudio >= 0.12 now requires ffmpeg on Linux, see https://github.com/facebookresearch/demucs/blob/main/docs/linux.md
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    ffmpeg \
    git \
    python3 \
    python3-dev \
    python3-pip \
    nvidia-cuda-toolkit \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone Demucs (now maintained in the original author's github space)
RUN git clone --single-branch --branch main https://github.com/adefossez/demucs /lib/demucs
WORKDIR /lib/demucs
# Checkout known stable commit on main
RUN git checkout b9ab48cad45976ba42b2ff17b229c071f0df9390

# Install torch known working version on this base image
RUN pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 \
    $( [ "$gpu" = "true" ] && echo "--index-url https://download.pytorch.org/whl/cu118" )

# Install requirements
RUN pip install -r requirements.txt

# Run once to ensure demucs works and trigger the default model download
RUN python3 -m demucs -d cpu test.mp3 
# Cleanup output - we just used this to download the model
RUN rm -r separated

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]
