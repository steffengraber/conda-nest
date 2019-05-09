#!/bin/bash

VERSION="2.16.0"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ${HOME}/nest . --output)
# anaconda -t $c_token upload -v $VERSION --force -u $c_user -l daily -l main
 $PKG_NAME
