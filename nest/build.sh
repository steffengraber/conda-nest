#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [[ $(uname) == Linux ]]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
	export CFLAGS="-I$PREFIX/include"
	export LDFLAGS="-L$PREFIX/lib"
fi

if [[ $(uname) == Darwin ]]; then
	LLVMPATH = $(brew --prefix llvm)
	echo 'export PATH="${LLVMPATH}/bin:$PATH"' >> ~/.bash_profile
	export CC= clang
	export CXX= $(CC)++
	export LDFLAGS="-L${LLVMPATH}/lib -Wl,-rpath,${LLVMPATH}/lib"
	export CPPFLAGS="-I${LLVMPATH}/include -I${LLVMPATH}/include/c++/v1/"
fi

mkdir build
cd build

# Linux build
if [[ $(uname) == Linux ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
		  -Dwith-mpi=OFF\
		  -Dwith-openmp=OFF \
		  -Dwith-python=3 \
		  -Dwith-gsl=$PREFIX \
		  -DREADLINE_ROOT_DIR=$PREFIX \
		  -DLTDL_ROOT_DIR=$PREFIX \
		  ..
fi

# OSX build
if [[ $(uname) == Darwin ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
		  -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} \
		  -Dwith-mpi=OFF \
		  -Dwith-openmp=OFF \
		  -Dwith-python=3 \
		  -Dwith-gsl=$PREFIX \
		  -DREADLINE_ROOT_DIR=$PREFIX \
		  -DLTDL_ROOT_DIR=$PREFIX \
		  ..
fi


make -j${CPU_COUNT}
make install

# [ -d $PREFIX/lib64] &&

cp $PREFIX/lib64/* $PREFIX/lib -r

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    sed "s#!!!SP_DIR!!!#${SP_DIR}#g" "${RECIPE_DIR}/${CHANGE}.sh" > "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done