#!/bin/bash

VERSION="master"
conda install -y -c anaconda anaconda-client
PKG_NAME=$(conda build ./nest . --output)

echo $PKG_NAME
set -- $PKG_NAME
echo '\n\n########## UPLOAD ###########'
echo $2
echo '\n\n\n########## START ANACONDA CLIENT ###########'
anaconda -v -t $c_token upload --version $VERSION --force -u $c_user -l daily -l main $2
echo '\n\n\n########## END ANACONDA CLIENT ###########'