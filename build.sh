#!/bin/sh

export MPI_FLAGS=--allow-run-as-root

if [ $(uname) == Linux ]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
fi

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
      -Dwith-mpi=ON \
      -Dwith-openmp=ON \
      -Dwith-python=3 \
      -Dwith-gsl=$PREFIX \
      -DREADLINE_ROOT_DIR=$PREFIX \
      -DLTDL_ROOT_DIR=$PREFIX \
      ..
make -j2
make install
# this is needed to make the python bindings work
cp $PREFIX/lib64/* $PREFIX/lib -r

# setting variables for NEST in environment
mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d


NEST_INSTALL_DIR=$PREFIX
NEST_DATA_DIR="$NEST_INSTALL_DIR/share/nest"
NEST_DOC_DIR="$NEST_INSTALL_DIR/share/doc/nest"
NEST_MODULE_PATH="$NEST_INSTALL_DIR/lib/nest"
NEST_PYTHON_PREFIX="$NEST_INSTALL_DIR/lib/python3.5/site-packages"
PYTHONPATH="$NEST_PYTHON_PREFIX:$PYTHONPATH"
PATH="$NEST_INSTALL_DIR/bin:$PATH"

cat << EOF > $PREFIX/etc/conda/activate.d/activate-nest.sh
#!/bin/bash
export NEST_INSTALL_DIR=$PREFIX
export NEST_DATA_DIR=$NEST_DATA_DIR
export NEST_DOC_DIR=$NEST_DOC_DIR
export NEST_MODULE_PATH=$NEST_MODULE_PATH
export NEST_PYTHON_PREFIX=$NEST_PYTHON_PREFIX
export PYTHONPATH=$PYTHONPATH
export PATH=$PATH
EOF

cat << EOF > $PREFIX/etc/conda/deactivate.d/deactivate-nest.sh
#!/bin/sh
unset NEST_INSTALL_DIR
unset NEST_DATA_DIR
unset NEST_DOC_DIR
unset NEST_MODULE_PATH
unset NEST_PYTHON_PREFIX
EOF

