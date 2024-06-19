DOCKER=docker run -v "$$(pwd):/srv" -w=/srv nowox/latex:2.0
SRC=$(wildcard assets/*.c)
EXECS=$(SRC:.c=.out)
CFLAGS=-Wall -Wextra -Werror -std=c11 -pedantic -O3 -g
TEXSRC=$(wildcard *.tex)

all: release

config.tex: config.m.tex | config.yml ./tools/parse-yml.py
	./tools/parse-yml.py config.yml > $@ < $<

exam.pdf: exam.tex FORCE | config.tex code $(TEXSRC)
	latexmk --shell-escape -pdf -jobname=$(basename $@) $<

solution.pdf: exam.tex FORCE | config.tex code $(TEXSRC)
	latexmk --shell-escape -pdf -jobname=$(basename $@) -pdflatex='xelatex %O "\PassOptionsToClass{answers}{exam}\input{%S}"' $<

assembly: exam.pdf | refcard.pdf
	qpdf --empty --pages $< 1-2,r2-r1 -- cover.pdf
	qpdf --empty --pages $< 3-4 -- p1.pdf
	qpdf --empty --pages $< 5-8 -- p2.pdf
	qpdf --empty --pages $< 9-10 -- p3.pdf
	qpdf --empty --pages $< 11-r3 -- p4.pdf

%.out: %.c
	cc $(CFLAGS) -o $@ $<

code: $(EXECS)

refcard.pdf:
	wget https://github.com/heig-tin-info/refcard/releases/download/2.6.6/refcard.pdf

release: assembly refcard.pdf exam.pdf solution.pdf
	mkdir -p release
	cp refcard.pdf $@
	cp p*.pdf $@
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

.PHONY: clean all assembly
