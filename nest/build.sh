#!/bin/sh

#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

mkdir build
mkdir install

git clone  https://github.com/nest/nest-simulator.git

ls -l

cd build

echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
export LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/c++/v1/"

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
	  ../nest-simulator
make
make install
cd ../install
