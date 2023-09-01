PACKAGE=iwonamath

SAMPLES = sample.tex

PDF = $(PACKAGE).pdf ${SAMPLES:%.tex=%.pdf}

FD = \
	omliwonamath.fd \
	omliwonamathc.fd \
	omliwonamathl.fd \
	omliwonamathlc.fd \
	omsiwonamath.fd \
	omsiwonamathc.fd \
	omsiwonamathcmsy.fd \
	omsiwonamathl.fd \
	omsiwonamathlc.fd \
	omxiwonamath.fd \
	omxiwonamathc.fd \
	omxiwonamathl.fd \
	omxiwonamathlc.fd \
	ot1iwonamath.fd \
	ot1iwonamathc.fd \
	ot1iwonamathcm.fd \
	ot1iwonamathl.fd \
	ot1iwonamathlc.fd \
	ot1iwonamathlcm.fd \
	ot1iwonamathlm.fd \
	ot1iwonamathm.fd 

all:  ${PDF} $(PACKAGE).sty $(FD) 


%.pdf:  %.dtx   $(PACKAGE).sty
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


%.sty:   %.ins %.dtx  
	pdflatex $<

%.pdf:  %.tex   $(PACKAGE).sty $(FD)
	pdflatex $<
	- bibtex $*
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done

%.fd: $(PACKAGE).ins $(PACKAGE).dtx
	pdflatex $<
	./makeiwonamathfd.sh




clean:
	$(RM)  *_FAMILY_* *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi \
        *.hd sample-blx.bib \
	omsiwonamathcmsy.fd *.sty


distclean: clean
	$(RM) $(PDF) $(PACKAGE).sty $(FD) 

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1  \
	tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude LICENSE \
	--exclude '*.tgz' --exclude '*.zip'  --exclude .git $(PACKAGE)
	mv ../$(PACKAGE).tgz .

zip:  all clean
	make $(PACKAGE).sty
	$(RM) $(PACKAGE).log
	cd ..;\
	zip -r  $(PACKAGE).zip $(PACKAGE) -x "*.ins" -x "*.gitignore"

