#!/bin/bash

if [[ -f $1 ]]
then
    for version in $(cat $1)
    do
        echo $version
        git checkout tags/$version
        mkdir analyze/$version
        cccc --outdir=analyze/$version src/*.cc src/*.h
    done
    # count the number of lines in a file
    #wc -l $1
fi
