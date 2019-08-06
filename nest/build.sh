#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [[ $(uname) == Linux ]]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
	export CFLAGS="-I${PREFIX}/include"
	export LDFLAGS="-L${PREFIX}/lib"
fi

if [[ $(uname) == Darwin ]]; then
	echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
	export LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
	export CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/c++/v1/"
fi

mkdir build
cd build

mpi_arg=""
if [[ "$mpi" != "nompi" ]]; then
  mpi_arg="ON"
else
	mpi_arg="OFF"
fi
echo "Der MPI-Flag lautet: ${mpi_arg}"

# Linux build
if [[ $(uname) == Linux ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
		  -Dwith-mpi=${mpi_arg} \
		  -Dwith-openmp=${mpi_arg} \
		  -Dwith-python=3 \
		  -Dwith-gsl=${PREFIX} \
		  -DREADLINE_ROOT_DIR=${PREFIX} \
		  -DLTDL_ROOT_DIR=${PREFIX} \
		  ..
fi

# OSX build
if [[ $(uname) == Darwin ]]; then
	cmake -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
		  -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT} \
		  -Dwith-mpi=${mpi_arg} \
		  -Dwith-openmp=${mpi_arg} \
		  -Dwith-python=3 \
		  -DPYTHON_EXECUTABLE=${PYTHON}\
		  -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}.dylib \
		  -Dwith-gsl=${PREFIX} \
		  -DREADLINE_ROOT_DIR=${PREFIX} \
		  -DLTDL_ROOT_DIR=${PREFIX} \
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