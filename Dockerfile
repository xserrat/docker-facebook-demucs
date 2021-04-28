FROM continuumio/anaconda3:2020.11

USER root

# Install Git
RUN apt install git

# Install Facebook Demucs
RUN mkdir -p /lib/demucs

WORKDIR /lib/demucs

RUN git clone -b master --single-branch https://github.com/facebookresearch/demucs /lib/demucs

RUN conda env update -f environment-cpu.yml
RUN conda init bash
RUN echo "conda activate demucs" >> ~/.bashrc
RUN apt install -y libsndfile1

VOLUME /data/input
VOLUME /data/output
VOLUME /data/models

ENTRYPOINT ["/bin/bash", "--login", "-c"]

