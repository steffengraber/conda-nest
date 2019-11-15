#!/bin/bash

VERSION="master"

echo "CREATE ENV UPLOAD"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo 'ANACONDA INSTALLATION'

if [[ $(uname) == Darwin ]]; then
  CONDA_BIN=$(which anaconda)
  echo "Linux"
  echo $CONDA_BIN
fi

if [[ $(uname) == Linux ]]; then
  CONDA_BIN=/usr/share/miniconda/bin/anaconda
  echo "MaOsx"
  echo $CONDA_BIN
fi

echo 'PAKETNAME'
echo $PKG_NAME
set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'


$CONDA_BIN -t $CO2TOKEN upload --version ${VERSION} --force -u steffengraber -l 'testing' $1

echo '########## END ANACONDA CLIENT ###########'
