#!/bin/bash

set -e

folders=$(find -name source.S)

for i in $folders; do

    # if the first argument is given, only compile the tests in that folder
    if [ ! -z "$1" ] && [ $(basename $(dirname $i)) != "$1" ] ; then
        continue
    fi;

    folder=$(dirname $i)

    echo "Create handout $folder"
    
    # TODO: Manage multi-language in a proper way

    # pdf files to be merged
    pdftext_en=$(mktemp --suffix=.pdf)
    pdftext_it=$(mktemp --suffix=.pdf)
    pdfsolution=$(mktemp --suffix=.pdf)
    pdftests=$(mktemp --suffix=.pdf)

    # create the text pdf - IT
    pandoc --pdf-engine=lualatex -V geometry:margin=.8in -V pagestyle=empty $folder/text_it.html -o $pdftext_it

    # create the text pdf - EN
    pandoc --pdf-engine=lualatex -V geometry:margin=.8in -V pagestyle=empty $folder/text_en.html -o $pdftext_en

    # create the solution pdf
    tmpfile=$(mktemp --suffix=.html)
    pygmentize -l asm -f html $folder/source.S > $tmpfile
    pandoc --pdf-engine=lualatex -V geometry:margin=.8in -V pagestyle=empty $tmpfile -o $pdfsolution

    # create the tests pdf
    pygmentize -l yaml -f html $folder/tests.yaml > $tmpfile
    pandoc --pdf-engine=lualatex -V geometry:margin=.8in -V pagestyle=empty $tmpfile -o $pdftests
    rm $tmpfile

    # merge the pdfs - italian
    pdftk $pdftext_it $pdfsolution $pdftests cat output $folder/$(basename $folder)_it.pdf

    # merge the pdfs - english
    pdftk $pdftext_en $pdfsolution $pdftests cat output $folder/$(basename $folder)_en.pdf

    rm $pdftext_en $pdftext_it $pdfsolution $pdftests
done
