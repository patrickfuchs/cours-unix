.PHONY: all clean

MD=$(wildcard *.md)
OUTDIR=html
HTML=$(patsubst %.md, $(OUTDIR)/%.html, $(MD))


all : $(HTML)


clean :
	rm -rf $(OUTDIR)


$(OUTDIR) :
	mkdir -p $(OUTDIR)


# | -> see order-only-prerequisites
# https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
$(OUTDIR)/%.html : %.md template.html5 | $(OUTDIR)
	pandoc -o $@ \
		-S \
		--standalone \
		--self-contained \
		--mathjax \
		--variable date=`date +"%d/%m/%Y"` \
		--template="template.html5" \
		$<
		# --self-contained : pour un document standalone 
		# où tous les fichiers (css, images) sont embarqués dans le fichier html.

