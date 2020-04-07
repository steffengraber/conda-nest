![conda nest steffengraber](https://github.com/steffengraber/conda-nest/workflows/conda%20nest%20steffengraber/badge.svg)


# NEST simulator - conda build files

This is for testing the conda-forge packages <https://anaconda.org/conda-forge/nest-simulator>

Easy install different versions NEST simulator in conda environments.
The 'master'-branch of NEST is daily build.  
Until now tested with:

-   Ubuntu 18.04
-   SUSE Leap 15.0

## Install NEST simulator

1.  Create a clean environment

    Of course you can use your own environment. But if you have problems, a new clean one is recommended.

        conda create --name nest

2.  Activate the environment

        conda activate nest

3.  Install NEST

    For NEST simulator v2.16.0:

        conda install -c steffengraber -c conda-forge nest=v2.16.0

    For NEST simulator master

        conda install -c steffengraber -c conda-forge nest=master

## Build and install the packages by hand

1.  Choose the version you want to build by editing the first line in
    'meta.yaml', eg:

        {% set version = "v2.16.0" %}

2.  Build the package

        conda build .

3.  Install it

        conda install --use-local nest=v2.16.0
