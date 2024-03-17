#!/bin/bash

set -e

folders=$(find -name source.S)

for i in $folders; do
    j=$(echo $i | sed 's/.*\/\(.*\)\/source.S/\1/')

    if [ ! -z "$1" ] && [ "$j" != "$1" ] ; then
        continue
    fi;

    echo "Generate question $j"
    python3 ./generate_question.py $(dirname $i) $j
done
