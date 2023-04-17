#!/bin/bash

set -e

if [ "$1" == "" ]; then
    echo "Usage: ./runit.sh script.S"
    exit 1
fi;

EXECFILE=$(mktemp)

echo "Compiling to: $EXECFILE"

# riscv64-unknown-elf-gcc -I$(pwd) $1 -o $EXECFILE -nostartfiles -nostdlib
riscv64-linux-gnu-gcc -I$(pwd) $1 -o $EXECFILE -static -nostartfiles -nostdlib
spike $(which pk) $EXECFILE

rm $EXECFILE
