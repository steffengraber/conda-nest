#!/bin/bash

VERSION="master"

echo "CREATE ENV UPLOAD"
conda create --name upload
conda activate upload
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo 'PAKETNAME'
echo $PKG_NAME
set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'

echo $CO2USER

anaconda -t $CO2TOKEN upload --version ${VERSION} --force -u $CO2USER -l 'macos' $1

echo '########## END ANACONDA CLIENT ###########'
