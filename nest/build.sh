#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [[ $(uname) == Linux ]]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
	export CFLAGS="-I${CONDA_PREFIX}/include"
	export LDFLAGS="-L${CONDA_PREFIX}/lib"
fi

if [[ $(uname) == Darwin ]]; then
	echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
	export CC=clang
	export CXX=${CC}++
	echo "HIER"
	echo ${CONDA_PREFIX}
	export LDFLAGS="-L${CONDA_PREFIX}/lib -Wl,-rpath,$${CONDA_PREFIX}/lib"
	export CPPFLAGS="-I${CONDA_PREFIX}/include -I${CONDA_PREFIX}/include/c++/v1/"
fi

mkdir build
cd build

# Linux build
if [[ $(uname) == Linux ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
		  -Dwith-mpi=OFF\
		  -Dwith-openmp=OFF \
		  -Dwith-python=3 \
		  -Dwith-gsl=${PREFIX} \
		  -DREADLINE_ROOT_DIR=${PREFIX} \
		  -DLTDL_ROOT_DIR=${PREFIX} \
		  ..
fi

# OSX build
if [[ $(uname) == Darwin ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=${CONDA_PREFIX}\
		  -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} \
		  -Dwith-mpi=OFF \
		  -Dwith-openmp=OFF \
		  -Dwith-python=3 \
		  -DPYTHON_EXECUTABLE=${PYTHON}\
		  -DPYTHON_LIBRARY=${CONDA_PREFIX}${PY_VER}.dylib \
		  -Dwith-gsl=${CONDA_PREFIX} \
		  -DREADLINE_ROOT_DIR=${CONDA_PREFIX} \
		  -DLTDL_ROOT_DIR=${CONDA_PREFIX} \
		  ..
fi


make -j${CPU_COUNT}
make install

if [[ -d ${PREFIX}/lib64 ]]
then
    cp -R ${PREFIX}/lib64/* ${PREFIX}/lib
fi


for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    sed "s#!!!SP_DIR!!!#${SP_DIR}#g" "${RECIPE_DIR}/${CHANGE}.sh" > "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done