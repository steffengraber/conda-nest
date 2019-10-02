#!/bin/bash

echo "Start Script"
# export CC=$(ls /usr/local/bin/gcc-* | grep '^/usr/local/bin/gcc-\d$')
# export CXX=$(ls /usr/local/bin/g++-* | grep '^/usr/local/bin/g++-\d$')

ls -l

mkdir build
cd build
echo "Now Cmake"

cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX  \
      -DCMAKE_C_COMPILER=gcc-9 \
      -DCMAKE_CXX_COMPILER=g++-9 \
	  ..
make
make install
