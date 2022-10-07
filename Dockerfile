FROM nvidia/cuda:11.8.0-base-ubuntu22.04

USER root
ENV TORCH_HOME=/data/models

# Installing FFMpeg might have a prompt, avoid it with this
ARG DEBIAN_FRONTEND=noninteractive

# Basic set
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl
RUN apt-get -y install python3
RUN apt-get -y install python3-pip

# ffmpeg was missing
RUN apt-get -y install ffmpeg

# Install Git
RUN apt -y install git

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone -b main --single-branch https://github.com/facebookresearch/demucs /lib/demucs

RUN python3 -m pip install -e .

# torch 10.2 was installed by default probably from other dependencies; force remove it
RUN python3 -m pip uninstall torch torchvision torchaudio -y

# install torch 11.6
RUN python3 -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

# Trigger model download
# TODO: parameterize model selection here?
RUN python3 -m demucs.separate test.mp3

# cleanup
RUN rm -r separated

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

