#!/bin/bash

VERSION="master"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'

anaconda -t $CO2TOKEN upload --version ${VERSION} --force -u $CO2USER -l 'testing, master' $1

echo '########## END ANACONDA CLIENT ###########'
