default:	index1.html index2.html index3.html

## .gpt -> .tex + .pdf
/tmp/%.tex:	%.gpt
	(echo "set terminal cairolatex pdf; set output \"/tmp/$*.tex\"" | cat - $*.gpt) | gnuplot

## .tex + .eps -> .eps
%.pdf: /tmp/%.tex
	pdflatex << EOF \
\\documentclass{minimal} \
\\usepackage{graphicx} \
\\usepackage{amsmath} \
\\usepackage{amssymb} \
\\usepackage{color} \
\\begin{document} \
\\pagestyle{empty} \
\\thispagestyle{empty} \
\\resizebox{1.0\\textwidth}{!}{\\input{/tmp/$*}} \
\\end{document} \
EOF
	pdfcrop minimal.pdf $*.pdf
	rm minimal.log
	rm minimal.aux
	rm minimal.pdf
	rm /tmp/$*.pdf

# .pdf -> .svg
%.svg:	%.pdf
	pdf2svg $*.pdf $*.svg

klein_bottle.fig:	klein_bottle.gpt
klein_bottle.pdf:	klein_bottle.fig
klein_bottle.svg:	klein_bottle.pdf

index.pdf:	index.tex klein_bottle.pdf
		pdflatex index
		bibtex index
		pdflatex index

index1.html:	index.pdf klein_bottle.svg
		htlatex index.tex
		mv index.html index1.html

index2.html:	index.pdf klein_bottle.svg
		htlatex index.tex htlatex.cfg " -cunihtf"
		mv index.html index2.html

index3.html:	index.pdf klein_bottle.svg
		pandoc --default-image-extension=svg --self-contained --to=slidy index.tex --output=index3.html

index4.html:	index.pdf klein_bottle.svg
		pandoc --default-image-extension=svg --self-contained --to=revealjs index.tex --output=index4.html

# Be careful! This clean is specific for this project.
clean:
		rm -f *.html *.aux *.log *.4ct *.4tc *.bbl *.blg *.css *.lg *.tmp *.xref *.png *.fig *.pdf *.dvi *.idv *.bak *~



