#!/bin/bash

VERSION="master"

echo "CREATE ENV UPLOAD"
pip install anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo 'PAKETNAME'
echo $PKG_NAME
set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'


anaconda -t $CO2TOKEN upload --version ${VERSION} --force -u $CO2USER -l 'macos' $1

echo '########## END ANACONDA CLIENT ###########'
