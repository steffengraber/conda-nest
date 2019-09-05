#!/bin/sh

#!/bin/sh


# activate the build environment
. activate "${BUILD_PREFIX}"

# "stack" the host environment on top of the build env
mkdir -p "${PREFIX}/conda-meta"
touch "${PREFIX}/conda-meta/history"
unset CONDA_PATH_BACKUP
export CONDA_MAX_SHLVL=2
source ${BUILD_PREFIX}/bin/activate "${PREFIX}"


export MPI_FLAGS=--allow-run-as-root

mkdir build
mkdir install

git clone  https://github.com/nest/nest-simulator.git

ls -l

cd build

if [[ "$(uname)" == "Darwin" ]]; then

	export CFLAGS="${CFLAGS} -i sysroot ${CONDA_BUILD_SYSROOT}"
	export CXXFLAGS="${CFLAGS}


	echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
	export LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
	export CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/c++/v1/ -fopenmp"


	echo "BUILD FOR DARWIN"
	cmake -DCMAKE_INSTALL_PREFIX:PATH=../install \
		  -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} \
		  -Dwith-openmp=OFF \
		  -Dwith-mpi=OFF \
		  -Dwith-python=3 \
		  -DPYTHON_EXECUTABLE=${PYTHON}\
		  -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}.dylib \
		  -Dwith-gsl=${PREFIX} \
		  -DREADLINE_ROOT_DIR=${PREFIX} \
		  -DLTDL_ROOT_DIR=${PREFIX} \
		  -DCMAKE_C_COMPILER=${PREFIX}/bin/clang \
		  -DCMAKE_CXX_COMPILER=${PREFIX}/bin/clang++ \
		  ../nest-simulator

else

	export CC=clang
	export CXX=clang++

	echo "BUILD FOR DARWIN"
	cmake -DCMAKE_INSTALL_PREFIX:PATH=../install \
		  -Dwith-openmp=OFF \
		  -Dwith-mpi=OFF \
		  -Dwith-python=3 \
		  -DCMAKE_C_COMPILER=gcc\
		  -DCMAKE_CXX_COMPILER=g++\
		  ../nest-simulator
fi

make
make install
cd ../install
