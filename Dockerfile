FROM continuumio/miniconda3

MAINTAINER "Steffen Graber" <s.graber@fz-juelich.de>

ENV TERM=xterm \
    TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget bzip2 git cmake && \
    apt-get update --fix-missing  && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    conda update -n base -c defaults conda && \
    conda config --add channels conda-forge && \
    conda info -a && \
    conda install -y conda-build conda-verify anaconda-client && \
    conda clean -y --all && \
    mkdir /opt/conda-nest && \
    echo "\n\n## BUILD PROCESS START ##\n\n"

WORKDIR /opt/conda-nest
COPY ./build.sh /opt/conda-nest
COPY ./meta.yaml /opt/conda-nest
COPY ./anaconda_push.sh /opt/conda-nest

RUN conda build /opt/conda-nest && \
    echo "\n\n## BUILD AND ALL CHECKS ARE DONE ##\n\n" && \
    env && \
    pwd && \
    whoami && \
    ls -lahr
