#!/bin/bash

VERSION="master"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo $PKG_NAME
set -- $PKG_NAME

echo '########## UPLOAD ###########'
echo $1
echo '########## START ANACONDA CLIENT ###########'

anaconda -t $c_token upload --version ${VERSION} --force -u $c_user -l testing $2

echo '########## END ANACONDA CLIENT ###########'


# VERSION="v2.16.0"

# PKG_NAME=$(conda build . --output)

# anaconda -t $c_token upload -v $VERSION --force -u $c_user -l release -l
# main $PKG_NAME