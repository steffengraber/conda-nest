#!/bin/bash

PKG_NAME=$(conda build . --output)
anaconda -t $C_TOKEN upload -u $C_USER -l daily $PKG_NAME
