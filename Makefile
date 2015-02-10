default:	index1.html index2.html index3.html index4.html

# .gpt -> .fig
%.fig:  %.gpt
	gnuplot $*.gpt

# .fig -> .pdf
%.pdf:	%.fig
	fig2dev -L pdftex $*.fig > $*_.pdf
	fig2dev -L pdftex_t -p $*_.pdf $< > $*_.tex
	pdflatex -jobname $* << EOF \
\\documentclass{minimal} \
\\usepackage{graphicx} \
\\usepackage{color} \
\\begin{document} \
\\resizebox{\\textwidth}{!}{\\input{$*_}} \
\\end{document} \
EOF
	pdfcrop $*.pdf /tmp/figure.pdf
	mv /tmp/figure.pdf $*.pdf
	rm $*_.pdf
	rm $*_.tex
	rm $*.aux
	rm $*.log

# .pdf -> .svg
%.svg:	%.pdf
	pdf2svg $*.pdf $*.svg

klein_bottle.fig:	klein_bottle.gpt
klein_bottle.pdf:	klein_bottle.fig
klein_bottle.svg:	klein_bottle.pdf

index.pdf:	index.tex klein_bottle.pdf
		pdflatex index # Inputs: .pdf, .jpg or .png.
		bibtex index
		pdflatex index

index1.html:	index.pdf klein_bottle.svg
		htlatex index.tex # Inputs: .svg, .jpg or .png.
		mv index.html index1.html

index2.html:	index.pdf klein_bottle.svg
		#htlatex index.tex math.cfg, slides.cfg
		#htlatex index.tex "slides.cfg, math.cfg, charset=utf-8, charset=utf-8 -cunihtf -utf-8"
		htlatex index.tex htlatex.cfg " -cunihtf"
		mv index.html index2.html

index3.html:	index.pdf klein_bottle.svg
		pandoc --default-image-extension=svg --self-contained --to=slidy index.tex --output=index3.html

index4.html:	index.pdf klein_bottle.svg
		pandoc --default-image-extension=svg --self-contained --to=revealjs index.tex --output=index4.html

# Be carefully! This clean is specific for this project.
clean:
		rm -f *.html *.aux *.log *.4ct *.4tc *.bbl *.blg *.css *.lg *.tmp *.xref *.png *.fig *.pdf *.dvi *.idv *.bak *~



