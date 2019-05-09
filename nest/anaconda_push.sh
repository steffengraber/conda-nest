#!/bin/bash

VERSION="master"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo '######### UPLOAD ###########'
echo $PKG_NAME

anaconda -t $c_token upload -v $VERSION --force -u $c_user -l daily -l main $PKG_NAME
