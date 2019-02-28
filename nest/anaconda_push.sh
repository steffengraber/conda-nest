#!/bin/bash

VERSION="v2.16.0"

PKG_NAME=$(conda build . --output)
anaconda -t $c_token upload -v $VERSION --force -u $c_user -l release -l main $PKG_NAME
