#!/bin/bash

echo "Before script section"
apt-get update
apt-get install -y wget bzip2 git cmake
apt-get update --fix-missing
apt-get autoremove
conda config --add channels conda-forge
conda info -a
conda install -y conda-build conda-verify anaconda-client 
conda update -y conda 
conda update -y conda-build
conda clean -y --al
conda build .
echo "Build and all checks are done."
# automatic upload by accepted pull request

env
pwd
whoami
ls -lahr
