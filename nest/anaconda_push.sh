#!/bin/bash

VERSION="master"

PKG_NAME=$(conda build . --output)
anaconda -t $c_token upload -v $VERSION --force -u $c_user -l daily -l main $PKG_NAME
