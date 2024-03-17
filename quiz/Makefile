#!/bin/bash

all:
	cd it; LANG="en_US.utf8" lualatex -shell-escape 0_codifica.tex
	cd it; LANG="en_US.utf8" lualatex -shell-escape 1_introduction.tex
	cd it; LANG="en_US.utf8" lualatex -shell-escape 1.1_overflow.tex
# 	LANG="en_US.utf8" lualatex -shell-escape 2_FP.tex
# 	LANG="en_US.utf8" lualatex -shell-escape 3_circuits_comb
# 	LANG="en_US.utf8" lualatex -shell-escape 4_circuits_seq.tex
#	LANG="en_US.utf8" lualatex -shell-escape 5_openquestions.tex

clean:
	find . -type f -name '*.aux' -delete
	find . -type f -name '*.log' -delete
	find . -type f -name '*.out' -delete
	find . -type f -name '*.fls' -delete
	find . -type f -name '*.fdb_latexmk' -delete
	find . -type f -name '*.synctex.gz' -delete
	find . -type f -name '*.auxlock' -delete
	find . -type f -name '*.xml' -delete
	find . -type f -name '*.pdf' -delete
	find . -type f -name '*.png.enc' -delete
	find . -type f -name '*.png.png' -delete
	find . -type f -name '*.svg' -delete
	find . -type f -name '*.dpth' -delete
	find . -type f -name '*.md5' -delete
	find . -type f -name '*.enc' -delete

