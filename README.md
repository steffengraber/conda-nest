# NEST simulator conda build files

## Build the packages

First choose the version you want to build by editing the first line in 
'meta.yaml', eg:

    {% set version = "v2.16.0" %}
    
Then build the package

    conda build .

Install it

   conda install --use-local nest=v2.16.0


## Using prebuild packages

### Create a clean environment

    conad create --name nest

### Activate it

    source activate nest

### Install NEST simulator

    conda install -c steffengraber -c conda-forge nest=v2.16.0
    
    or for master
     
    conda install -c steffengraber -c conda-forge nest=master
