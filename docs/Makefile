all: ../ABOUT ../ANNOUNCE VODoc.info VODoc.dvi

../ABOUT:
	makeinfo --no-split --no-headers Description.texi >../ABOUT

../ANNOUNCE:
	makeinfo --no-split --no-headers Announce.texi >../ANNOUNCE

VODoc.info:
	makeinfo --no-split VODoc.texi

VODoc.dvi:
	texi2dvi VODoc.texi
VODoc:
	makeinfo --html VODoc.texi

clean:
	rm -rf VODoc *.info *.dvi *.aux *.cp *.cps *.fn *.ky *.log *.mo *.pg *.toc *.tp *.tps *.vr
