#!/bin/bash

NEST_INSTALL_DIR=${CONDA_PREFIX}
NEST_DATA_DIR="$NEST_INSTALL_DIR/share/nest"
NEST_DOC_DIR="$NEST_INSTALL_DIR/share/doc/nest"
NEST_MODULE_PATH="$NEST_INSTALL_DIR/lib/nest"
NEST_PYTHON_PREFIX="!!!SP_DIR!!!"

export NEST_INSTALL_DIR
export NEST_DATA_DIR=$NEST_DATA_DIR
export NEST_DOC_DIR=$NEST_DOC_DIR
export NEST_MODULE_PATH=$NEST_MODULE_PATH
export NEST_PYTHON_PREFIX=$NEST_PYTHON_PREFIX

