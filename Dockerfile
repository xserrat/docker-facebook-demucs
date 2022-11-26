FROM python:3.8-alpine3.16

USER root
ENV TORCH_HOME=/data/models
ENV REQUIREMENTS_FILE=requirements_minimal.txt

# Install needed packages
RUN apk update && apk add \
    git \
    ffmpeg

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone --depth 1 --branch main https://github.com/facebookresearch/demucs .

#RUN REQUIREMENTS_FILE=$([[ "${DEMUCS_VERSION}" == "minimal" ]] && echo "requirements_minimal.txt" || echo "requirements.txt")

RUN echo "Requirements file: ${REQUIREMENTS_FILE}"
RUN pip install https://github.com/chrisstaite/lameenc/archive/refs/tags/v1.4.1.zip
RUN sed -i 's/lameenc>=1.2/lameenc==1.4.1/g' ${REQUIREMENTS_FILE} # Upgrade lameenc to 1.4.1 to support arm64
RUN python3 -m pip install -r ${REQUIREMENTS_FILE}
RUN python3 -m demucs.separate -d cpu --mp3 test.mp3 # Trigger model download \
    && rm -r separated  # cleanup

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

