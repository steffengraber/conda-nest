#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [[ $(uname) == Linux ]]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
	export CFLAGS="-I${PREFIX}/include"
	export LDFLAGS="-L${PREFIX}/lib"
fi

if [[ ${target_platform} == osx-64 ]]; then
  CC=$(basename "${CC}")
else
  CC=$(basename "${GCC}")
fi

if [[ $(uname) == Darwin ]] && [[ -n ${CONDA_BUILD_SYSROOT} ]]; then
	echo 'export ${PREFIX}/bin:$PATH"' >> ~/.bash_profile
	CFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${CFLAGS}
    LDFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${LDFLAGS}
    CPPFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${CPPFLAGS}
	# export LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
	# export CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/c++/v1/"
	# Using Travis standard gcc and g++
	# export CC=$(ls /usr/local/bin/gcc-* | grep '^/usr/local/bin/gcc-\d$')
    # export CXX=$(ls /usr/local/bin/g++-* | grep '^/usr/local/bin/g++-\d$')
fi

CPPFLAGS=${CPPFLAGS}" -I${PREFIX}/include"

export CPPFLAGS CFLAGS CXXFLAGS LDFLAGS

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