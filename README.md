[![Build Status](https://travis-ci.org/steffengraber/conda-nest.svg?branch=master)](https://travis-ci.org/steffengraber/conda-nest)


# NEST simulator conda build files

## Install NEST simulator

1.  Create a clean environment

    Of course you can use your own environment. But if you have problems, a new clean one is recommended.

        conad create --name nest


2.  Activate it

        source activate nest

3.  Install it

        conda install -c steffengraber -c conda-forge nest=v2.16.0

    or for master

        conda install -c steffengraber -c conda-forge nest=master


## Build the packages by hand

First choose the version you want to build by editing the first line in
'meta.yaml', eg:

    {% set version = "v2.16.0" %}

Then build the package

    conda build .

Install it

   conda install --use-local nest=v2.16.0
