DOCKER=docker run -v "$$(pwd):/srv" -w=/srv nowox/latex:2.0
SRC=$(wildcard assets/*.c)
EXECS=$(SRC:.c=.out)
CFLAGS=-Wall -Wextra -Werror -std=c11 -pedantic -O3 -g
TEXSRC=$(wildcard *.tex)

all: dist

config.tex: config.m.tex | config.yml ./tools/parse-yml.py
	./tools/parse-yml.py config.yml > $@ < $<

exam.pdf: exam.tex FORCE | config.tex code $(TEXSRC)
	latexmk --shell-escape -pdf -jobname=$(basename $@) $<

solution.pdf: exam.tex FORCE | config.tex code $(TEXSRC)
	latexmk --shell-escape -pdf -jobname=$(basename $@) -pdflatex='xelatex %O "\PassOptionsToClass{answers}{exam}\input{%S}"' $<

%.out: %.c
	cc $(CFLAGS) -o $@ $<

code: $(EXECS)

dist: exam.pdf solution.pdf
	mkdir -p $@
	cp exam.pdf solution.pdf $@

clean:
	$(RM) config.tex
	latexmk -C
	$(RM) *.aux *.fdb_latexmk *.fls *.log
	$(RM) solution.pdf
	$(RM) *.pdf
	$(RM) *.pgf *.stderr *.stdout *.sh
	$(RM) *.dpth *.md5 *.auxlock
	$(RM) -rf release
FORCE:

.PHONY: clean all
