DOCKER=docker run -v "$$(pwd):/srv" -w=/srv nowox/latex:2.0
SRC=$(wildcard assets/*.c)
EXECS=$(SRC:.c=.out)
CFLAGS=-Wall -Wextra -Werror -std=c11 -pedantic -O3 -g
TEXSRC=$(wildcard *.tex)
BUILDDIR=build
LATEXMK=TEXMFHOME=$(shell pwd)/texmf texfot latexmk

all: exam.pdf solution.pdf

$(BUILDDIR)/config.tex: config.yml | tools/config.m.tex tools/parse-yml.py
	./tools/parse-yml.py $< > $@ < tools/config.m.tex

exam.pdf: exam.tex FORCE | $(BUILDDIR)/config.tex code $(TEXSRC)
	$(LATEXMK) -jobname=$(basename $@) $<

solution.pdf: exam.tex FORCE | $(BUILDDIR)/config.tex code $(TEXSRC)
	$(LATEXMK) -jobname=$(basename $@) -pdflatex='xelatex %O "\PassOptionsToClass{answers}{exam}\input{%S}"' $<

%.out: %.c
	cc $(CFLAGS) -o $@ $<

code: $(EXECS)

clean:
	$(RM) -rf $(BUILDDIR)
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
