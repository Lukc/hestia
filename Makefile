PACKAGE = 'lunradoc'
VERSION = '0.5.0'

PREFIX := /usr/local
BINDIR := $(PREFIX)/bin
LIBDIR := $(PREFIX)/lib
SHAREDIR := $(PREFIX)/share
INCLUDEDIR := $(PREFIX)/include
LUA_VERSION := 5.1
LUA_SHAREDIR := $(SHAREDIR)/lua/$(LUA_VERSION)

CC := cc
AR := ar
RANLIB := ranlib
CFLAGS := 
LDFLAGS := 

Q := @

all: lunradoc.moon lunradoc/doctree.moon lunradoc/document.moon lunradoc/lapis/html.moon lunradoc/lapis/util/functions.moon lunradoc/project.moon lunradoc/template.moon lunradoc/templates/bulma.moon
	@:

lunradoc.moon:

lunradoc.moon.install: lunradoc.moon
	@echo '[01;31m  IN >    [01;37m$(BINDIR)/lunradoc[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 lunradoc.moon $(DESTDIR)$(BINDIR)/lunradoc

lunradoc.moon.clean:

lunradoc.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(BINDIR)/lunradoc[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/lunradoc'

lunradoc/doctree.moon:

lunradoc/doctree.moon.install: lunradoc/doctree.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/doctree.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc'
	$(Q)install -m0755 lunradoc/doctree.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/doctree.moon

lunradoc/doctree.moon.clean:

lunradoc/doctree.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/doctree.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/doctree.moon'

lunradoc/document.moon:

lunradoc/document.moon.install: lunradoc/document.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/document.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc'
	$(Q)install -m0755 lunradoc/document.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/document.moon

lunradoc/document.moon.clean:

lunradoc/document.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/document.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/document.moon'

lunradoc/lapis/html.moon:

lunradoc/lapis/html.moon.install: lunradoc/lapis/html.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/lapis/html.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis'
	$(Q)install -m0755 lunradoc/lapis/html.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis/html.moon

lunradoc/lapis/html.moon.clean:

lunradoc/lapis/html.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/lapis/html.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis/html.moon'

lunradoc/lapis/util/functions.moon:

lunradoc/lapis/util/functions.moon.install: lunradoc/lapis/util/functions.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/lapis/util/functions.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis/util'
	$(Q)install -m0755 lunradoc/lapis/util/functions.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis/util/functions.moon

lunradoc/lapis/util/functions.moon.clean:

lunradoc/lapis/util/functions.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/lapis/util/functions.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/lapis/util/functions.moon'

lunradoc/project.moon:

lunradoc/project.moon.install: lunradoc/project.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/project.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc'
	$(Q)install -m0755 lunradoc/project.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/project.moon

lunradoc/project.moon.clean:

lunradoc/project.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/project.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/project.moon'

lunradoc/template.moon:

lunradoc/template.moon.install: lunradoc/template.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/template.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc'
	$(Q)install -m0755 lunradoc/template.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/template.moon

lunradoc/template.moon.clean:

lunradoc/template.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/template.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/template.moon'

lunradoc/templates/bulma.moon:

lunradoc/templates/bulma.moon.install: lunradoc/templates/bulma.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunradoc/templates/bulma.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/templates'
	$(Q)install -m0755 lunradoc/templates/bulma.moon $(DESTDIR)$(LUA_SHAREDIR)/lunradoc/templates/bulma.moon

lunradoc/templates/bulma.moon.clean:

lunradoc/templates/bulma.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunradoc/templates/bulma.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunradoc/templates/bulma.moon'

$(DESTDIR)$(PREFIX):
	@echo '[01;35m  DIR >   [01;37m$(PREFIX)[00m'
	$(Q)mkdir -p $(DESTDIR)$(PREFIX)
$(DESTDIR)$(BINDIR):
	@echo '[01;35m  DIR >   [01;37m$(BINDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(BINDIR)
$(DESTDIR)$(LIBDIR):
	@echo '[01;35m  DIR >   [01;37m$(LIBDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(LIBDIR)
$(DESTDIR)$(SHAREDIR):
	@echo '[01;35m  DIR >   [01;37m$(SHAREDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(SHAREDIR)
$(DESTDIR)$(INCLUDEDIR):
	@echo '[01;35m  DIR >   [01;37m$(INCLUDEDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(INCLUDEDIR)
install: subdirs.install lunradoc.moon.install lunradoc/doctree.moon.install lunradoc/document.moon.install lunradoc/lapis/html.moon.install lunradoc/lapis/util/functions.moon.install lunradoc/project.moon.install lunradoc/template.moon.install lunradoc/templates/bulma.moon.install
	@:

subdirs.install:

uninstall: subdirs.uninstall lunradoc.moon.uninstall lunradoc/doctree.moon.uninstall lunradoc/document.moon.uninstall lunradoc/lapis/html.moon.uninstall lunradoc/lapis/util/functions.moon.uninstall lunradoc/project.moon.uninstall lunradoc/template.moon.uninstall lunradoc/templates/bulma.moon.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: lunradoc.moon.clean lunradoc/doctree.moon.clean lunradoc/document.moon.clean lunradoc/lapis/html.moon.clean lunradoc/lapis/util/functions.moon.clean lunradoc/project.moon.clean lunradoc/template.moon.clean lunradoc/templates/bulma.moon.clean

distclean: clean

dist: dist-gz dist-xz dist-bz2
	$(Q)rm -- $(PACKAGE)-$(VERSION)

distdir:
	$(Q)rm -rf -- $(PACKAGE)-$(VERSION)
	$(Q)ln -s -- . $(PACKAGE)-$(VERSION)

dist-gz: $(PACKAGE)-$(VERSION).tar.gz
$(PACKAGE)-$(VERSION).tar.gz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.gz[00m'
	$(Q)tar czf $(PACKAGE)-$(VERSION).tar.gz \
		$(PACKAGE)-$(VERSION)/lunradoc/doctree.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/document.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/lunradoc.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/project.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/template.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunradoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/lunradoc/doctree.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/document.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/lunradoc.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/project.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/template.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunradoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/lunradoc/doctree.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/document.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/lunradoc.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/project.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/template.moon \
		$(PACKAGE)-$(VERSION)/lunradoc/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunradoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

help:
	@echo '[01;37m :: lunradoc-0.5.0[00m'
	@echo ''
	@echo '[01;37mGeneric targets:[00m'
	@echo '[00m    - [01;32mhelp          [37m Prints this help message.[00m'
	@echo '[00m    - [01;32mall           [37m Builds all targets.[00m'
	@echo '[00m    - [01;32mdist          [37m Creates tarballs of the files of the project.[00m'
	@echo '[00m    - [01;32minstall       [37m Installs the project.[00m'
	@echo '[00m    - [01;32mclean         [37m Removes compiled files.[00m'
	@echo '[00m    - [01;32muninstall     [37m Deinstalls the project.[00m'
	@echo ''
	@echo '[01;37mCLI-modifiable variables:[00m'
	@echo '    - [01;34mCC            [37m ${CC}[00m'
	@echo '    - [01;34mCFLAGS        [37m ${CFLAGS}[00m'
	@echo '    - [01;34mLDFLAGS       [37m ${LDFLAGS}[00m'
	@echo '    - [01;34mDESTDIR       [37m ${DESTDIR}[00m'
	@echo '    - [01;34mPREFIX        [37m ${PREFIX}[00m'
	@echo '    - [01;34mBINDIR        [37m ${BINDIR}[00m'
	@echo '    - [01;34mLIBDIR        [37m ${LIBDIR}[00m'
	@echo '    - [01;34mSHAREDIR      [37m ${SHAREDIR}[00m'
	@echo '    - [01;34mINCLUDEDIR    [37m ${INCLUDEDIR}[00m'
	@echo '    - [01;34mLUA_VERSION   [37m ${LUA_VERSION}[00m'
	@echo '    - [01;34mLUA_SHAREDIR  [37m ${LUA_SHAREDIR}[00m'
	@echo ''
	@echo '[01;37mProject targets: [00m'
	@echo '    - [01;33mlunradoc.moon [37m script[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:           false'
	@echo '    - colors:        true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

