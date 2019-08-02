#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

mkdir build
mkdir install

git clone  https://github.com/nest/nest-simulator.git

ls -l

cd build
export CC=clang
export CXX=clang++

  echo "BUILD FOR DARWIN"
	cmake -DCMAKE_INSTALL_PREFIX:PATH=../install \
		  -Dwith-python=3 \
		  -DCMAKE_C_COMPILER=gcc-10\
          -DCMAKE_CXX_COMPILER=g++-10 \
		  ../nest-simulator
