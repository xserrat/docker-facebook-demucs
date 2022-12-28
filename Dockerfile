FROM python:3.11-alpine3.15 as lameenc-build

ENV PATH="/opt/venv/bin:$PATH"

RUN apk update && apk add git cmake build-base gcc py3-setuptools

RUN python3 -m pip install --user wheel

RUN mkdir -p /lib/lameenc
WORKDIR /lib/lameenc

RUN git clone --branch v1.3.1 --single-branch https://github.com/chrisstaite/lameenc /lib/lameenc

RUN mkdir -p /lib/lameenc/build
WORKDIR /lib/lameenc/build
RUN cmake ..
RUN make

RUN python3 -m venv /opt/venv
RUN python3 -m pip install /lib/lameenc/build/lameenc-1.3.1-cp38-cp38-linux_x86_64.whl

# syntax=docker/dockerfile:1
FROM python:3.11-alpine3.15
USER root
ENV PATH="/opt/venv/bin:$PATH"
ENV TORCH_HOME=/data/models
ENV REQUIREMENTS_FILE=requirements_minimal.txt

COPY --from=lameenc-build /opt/venv /opt/venv

# Install needed packages
RUN apk update && apk add \
    git \
    ffmpeg
RUN python3 -m pip install --upgrade pip

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone --depth 1 --branch main https://github.com/facebookresearch/demucs .

RUN python3 -m venv /opt/venv

RUN sed -i '/lameenc>=1.2/d' ${REQUIREMENTS_FILE}
RUN python3 -m pip install -r ${REQUIREMENTS_FILE}
RUN python3 -m demucs.separate -d cpu --mp3 test.mp3 # Trigger model download \
    && rm -r separated  # cleanup

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

