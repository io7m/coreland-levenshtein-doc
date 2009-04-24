all: html-split html-single css pdf dvi ps txt nroff local

html-split: build/_html-split.done
html-single: build/_html-single.done
css: build/_css.done
pdf: build/_pdf.done
dvi: build/_dvi.done
ps: build/_ps.done
txt: build/_txt.done
nroff: build/_nroff.done
meta: release/meta
local: build/_local.done

generated_sources = \
src/m_docid.ud src/m_docid.txt \
src/m_pkg.ud   src/m_supp.ud \
src/m_title.ud src/m_title.txt

#----------------------------------------------------------------------
# meta

src/m_docid.txt: src/m_docid.sh
	(cd src && ./m_docid.sh > m_docid.txt.tmp && mv m_docid.txt.tmp m_docid.txt)
src/m_docid.ud: src/m_docid_ud.sh src/m_docid.txt
	(cd src && ./m_docid_ud.sh > m_docid.ud.tmp && mv m_docid.ud.tmp m_docid.ud)
src/m_pkg.ud: src/m_pkg_ud.sh src/m_pkg.txt
	(cd src && ./m_pkg_ud.sh > m_pkg.ud.tmp && mv m_pkg.ud.tmp m_pkg.ud)
src/m_supp.ud: src/m_supp.sh
	(cd src && ./m_supp.sh m_supp.txt > m_supp.ud.tmp && mv m_supp.ud.tmp m_supp.ud)
src/m_title.txt: src/m_title.sh src/m_pkg.txt
	(cd src && ./m_title.sh > m_title.txt.tmp && mv m_title.txt.tmp m_title.txt)
src/m_title.ud: src/m_title_ud.sh src/m_title.txt
	(cd src && ./m_title_ud.sh > m_title.ud.tmp && mv m_title.ud.tmp m_title.ud)

#----------------------------------------------------------------------

build/_html-split.done:\
src/m_docid.txt src/main.ud release build $(generated_sources)
	(cd src && udoc-render -s 2 -r xhtml main.ud ../build)
	cp build/*.html release
	touch build/_html-split.done

build/_html-single.done:\
src/m_docid.txt src/main.ud release build $(generated_sources)
	(cd src && udoc-render -s 0 -r xhtml main.ud ../build)
	cp build/0.html release/single.html
	touch build/_html-single.done

build/_css.done: src/main.css
	cp src/main.css build
	cp build/main.css release
	touch build/_css.done

build/_txt.done:\
src/m_docid.txt src/m_pkg.txt src/main.ud pkg-name release build \
$(generated_sources)
	(cd src && udoc-render -r plain main.ud ../build)
	cp build/0.txt release/`./pkg-name src/m_pkg.txt`.txt
	touch build/_txt.done

build/_nroff.done:\
src/m_docid.txt src/m_pkg.txt src/main.ud pkg-name release build \
$(generated_sources)
	(cd src && udoc-render -r nroff main.ud ../build)
	cp build/0.nrf release/`./pkg-name src/m_pkg.txt`.nrf
	touch build/_nroff.done

build/0.tex:\
src/m_docid.txt src/m_pkg.txt src/main.ud release build $(generated_sources)
	(cd src && udoc-render -s 3 -r context main.ud ../build)

build/_dvi.done:\
src/m_docid.txt src/m_pkg.txt src/main.ud build/0.tex pkg-name release build \
$(generated_sources)
	(cd build && texexec --dvi 0.tex)
	cp build/0.dvi release/`./pkg-name src/m_pkg.txt`.dvi
	touch build/_dvi.done

build/_pdf.done:\
src/m_docid.txt src/m_pkg.txt src/main.ud build/0.tex pkg-name release build \
$(generated_sources)
	(cd build && texexec --pdf 0.tex)
	cp build/0.pdf release/`./pkg-name src/m_pkg.txt`.pdf
	touch build/_pdf.done

build/_ps.done:\
src/m_docid.txt src/m_pkg.txt src/main.ud build/0.pdf pkg-name release build \
$(generated_sources)
	(cd build && pdf2ps 0.pdf)
	cp build/0.ps release/`./pkg-name src/m_pkg.txt`.ps
	touch build/_ps.done

build/_local.done:\
local.sh
	./local.sh

release:
	mkdir release

build:
	mkdir build

release/meta: src/m_docid.txt src/m_title.txt src/m_pkg.txt pkg-meta pkg-name
	./pkg-meta

package: meta pkg-make pkg-name src/m_pkg.txt
	./pkg-make

#----------------------------------------------------------------------

clean:
	rm -f $(generated_sources)
	rm -rf build
	rm -rf release

clean-all: clean
