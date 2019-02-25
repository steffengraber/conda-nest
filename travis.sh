#!/bin/bash

echo "Before script section"
apt-get update
apt-get install -y wget bzip2 git
apt-get update --fix-missing
apt-get autoremove
conda config --add channels conda-forge
conda info -a
conda install conda-build anaconda-client
conda update conda
conda update conda-build
conda clean -y --al
conda build .
env
pwd
whoami
ls -lahr
