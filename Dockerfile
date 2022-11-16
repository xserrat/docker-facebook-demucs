#FROM python:3.8-alpine3.16 as build-lameenc
#
#RUN python3 -m venv /opt/venv  \
#    && python3 -m pip install --upgrade pip
#ENV PATH="/opt/venv/bin:$PATH"
#
#RUN git clone -b v1.3.1 --single-branch https://github.com/chrisstaite/lameenc /lib/lameenc
#
#RUN mkdir -p /lib/lameenc/build
#WORKDIR /lib/lameenc/build
#RUN cmake .. && make && pip install "lameenc-1.3.1-cp38-cp38-linux_aarch64.whl"

FROM python:3.8-alpine3.16

USER root
ENV TORCH_HOME=/data/models

# Install needed packages
RUN apk update && apk add \
    git \
    ffmpeg

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone --depth 1 --branch main https://github.com/facebookresearch/demucs .

#COPY --from=build-lameenc /opt/venv /opt/venv

RUN sed -i 's/lameenc>=1.2/lameenc>=1.4.1/g' requirements.txt requirements_minimal.txt  \
    && cat requirements.txt \
    && cat requirements_minimal.txt
RUN python3 -m pip install --platform=arm64 --no-deps -e .
RUN python3 -m demucs.separate -d cpu --mp3 test.mp3 # Trigger model download \
    && rm -r separated  # cleanup

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

