#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [[ $(uname) == Linux ]]; then
  export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
	export CFLAGS="-I${BUILD_PREFIX}/include"
	export LDFLAGS="-L${BUILD_PREFIX}/lib"
fi

if [[ $(uname) == Darwin ]]; then
  echo "FALGS FOR DARWIN"
	export CC=clang
	export CXX=${CC}++
	echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
	export CFLAGS="${CFLAGS} -i sysroot ${CONDA_BUILD_SYSROOT}"
	export CXXFLAGS="${CFLAGS} -i sysroot ${CONDA_BUILD_SYSROOT}"
	export LDFLAGS="-L${BUILD_PREFIX}/lib -Wl,-rpath,${BUILD_PREFIX}/lib"
	export CPPFLAGS="-I${BUILD_PREFIX}/include -I${BUILD_PREFIX}/include/c++/v1/"
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
  echo "BUILD FOR DARWIN"
	cmake -DCMAKE_INSTALL_PREFIX:PATH=${BUILD_PREFIX} \
		  -Dwith-mpi=OFF \
		  -Dwith-openmp=OFF \
		  -Dwith-python=3 \
		  -DPYTHON_EXECUTABLE=${PYTHON}\
		  -DPYTHON_LIBRARY=${BUILD_PREFIX}/lib/libpython${PY_VER}.dylib \
		  -Dwith-gsl=${BUILD_PREFIX} \
		  -DREADLINE_ROOT_DIR=${BUILD_PREFIX} \
		  -DLTDL_ROOT_DIR=${BUILD_PREFIX} \
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