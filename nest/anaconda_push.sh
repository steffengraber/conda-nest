#!/bin/bash

VERSION="master"

echo "CREATE ENV UPLOAD"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo 'ANACONDA INSTALLATION'
CONDA_BIN=$(which anaconda)
echo $CONDA_BIN

echo 'PAKETNAME'
echo $PKG_NAME
set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'


$CONDA_BIN -t $CO2TOKEN upload --version ${VERSION} --force -u $CO2USER -l 'macos' $1

echo '########## END ANACONDA CLIENT ###########'
