FROM python:3.8-alpine3.16

USER root
ENV TORCH_HOME=/data/models

# Install needed packages
RUN apk update && apk add \
    git \
    ffmpeg \
    && python3 -m pip install --upgrade pip

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone --depth 1 --branch main https://github.com/facebookresearch/demucs .

RUN sed -i 's/lameenc>=1.2/lameenc>=1.4.1/g' requirements.txt requirements_minimal.txt  \
    && cat requirements.txt \
    && cat requirements_minimal.txt
RUN python3 -m pip install -e .
RUN python3 -m demucs.separate -d cpu --mp3 test.mp3 # Trigger model download \
    && rm -r separated  # cleanup

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

