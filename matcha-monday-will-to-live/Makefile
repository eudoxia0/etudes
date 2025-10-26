TEX=matcha.tex
PDF=matcha.pdf
PNG=matcha.png

all: $(PNG)

$(PDF): $(TEX)
	lualatex -interaction=nonstopmode -halt-on-error $(TEX) >/dev/null

$(PNG): $(PDF)
	# Use Ghostscript (gs) to convert PDF → PNG at 300 dpi
	gs -dSAFER -dBATCH -dNOPAUSE -r300 -sDEVICE=pngalpha \
	   -sOutputFile=$(PNG) $(PDF)

clean:
	rm -f *.aux *.log *.out *.pdf *.png

.PHONY: all clean
