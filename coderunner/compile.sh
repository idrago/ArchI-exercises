#!/bin/bash

set -e

folders=$(find -name source.S)

for i in $folders; do

    if [ ! -z "$1" ] && [ $(basename $(dirname $i)) != "$1" ] ; then
        continue
    fi;

    echo "*****************************************************************"
    echo "Compiling $i"
    echo "*****************************************************************"

    EXECFILE=$(mktemp)

    echo "Compiling to: $EXECFILE"

    # riscv64-unknown-elf-gcc -I$(pwd) $1 -o $EXECFILE -nostartfiles -nostdlib
    riscv64-linux-gnu-gcc -I$(pwd) $i -o $EXECFILE -static -nostartfiles -nostdlib
    spike $(which pk) $EXECFILE

    rm $EXECFILE
done
