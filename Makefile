PACKAGE=iwonamath

SAMPLES = 

PDF = $(PACKAGE).pdf 

all:  ${PDF}



%.pdf:  %.dtx   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done

%.pdf: %.Rmd $(PACKAGE).cls amnestytemplate.tex
	Rscript -e "rmarkdown::render('$<', output_file='$@',  output_format='pdf_document')"

%.cls:   %.ins %.dtx  
	pdflatex $<

%.pdf:  %.tex   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done

.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).cls


clean:
	$(RM)  $(PACKAGE).cls *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi sample.tex \
        *.hd sample-blx.bib
	$(RM) -r sample_files

distclean: clean
	$(RM) $(PDF) 

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1  \
	tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' \
	--exclude '*.tgz' --exclude '*.zip'  --exclude CVS $(PACKAGE)
	mv ../$(PACKAGE).tgz .

zip:  all clean
	make $(PACKAGE).cls
	$(RM) $(PACKAGE).log
	cd ..;\
	zip -r  $(PACKAGE).zip $(PACKAGE) -x "*.ins" -x "*.gitignore"

