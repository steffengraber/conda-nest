#!/bin/bash

PKG_NAME=$(conda build . --output)
anaconda -t $c_token upload --force -u $c_user -l daily $PKG_NAME
