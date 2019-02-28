#!/bin/bash

VERSION="v2.16.0"

PKG_NAME=$(conda build . --output)

anaconda -t $c_token upload -v $VERSION --force -u $c_user -l release -l main $PKG_NAME

# Convert to osx
# conda-convert -p osx-64 --dependencies clang_osx-64 --dependencies clangxx_osx-64 -f $PKG_NAME
# anaconda -t $c_token upload -v osx-64 --force -u $c_user -l release -l test $PKG_NAME
