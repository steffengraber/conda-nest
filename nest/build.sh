#!/bin/bash

echo "Start Script"
export CC=$(ls /usr/local/bin/gcc-* | grep '^/usr/local/bin/gcc-\d$')
export CXX=$(ls /usr/local/bin/g++-* | grep '^/usr/local/bin/g++-\d$')

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

# export MPI_FLAGS=--allow-run-as-root

#mkdir build
#mkdir install

#git clone  https://github.com/nest/nest-simulator.git

#ls -l

#cd build

#echo "BUILD FOR DARWIN"
#cmake -DCMAKE_INSTALL_PREFIX:PATH=../install \
#	  -Dwith-openmp=OFF \
#	  -Dwith-mpi=OFF \
#	  -Dwith-python=3 \
##	  -DCMAKE_C_COMPILER=gcc\
#	  -DCMAKE_CXX_COMPILER=g++\
#	  ../nest-simulator
#make
#make install
#cd ../install

