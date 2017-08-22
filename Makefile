PACKAGE = 'hestia'
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

all: hestia.moon hestia/doctree.moon hestia/document.moon hestia/lapis/html.moon hestia/lapis/util/functions.moon hestia/project.moon hestia/template.moon hestia/templates/bulma.moon
	@:

hestia.moon:

hestia.moon.install: hestia.moon
	@echo '[01;31m  IN >    [01;37m$(BINDIR)/hestia[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 hestia.moon $(DESTDIR)$(BINDIR)/hestia

hestia.moon.clean:

hestia.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(BINDIR)/hestia[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/hestia'

hestia/doctree.moon:

hestia/doctree.moon.install: hestia/doctree.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/doctree.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia'
	$(Q)install -m0755 hestia/doctree.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/doctree.moon

hestia/doctree.moon.clean:

hestia/doctree.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/doctree.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/doctree.moon'

hestia/document.moon:

hestia/document.moon.install: hestia/document.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/document.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia'
	$(Q)install -m0755 hestia/document.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/document.moon

hestia/document.moon.clean:

hestia/document.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/document.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/document.moon'

hestia/lapis/html.moon:

hestia/lapis/html.moon.install: hestia/lapis/html.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/lapis/html.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis'
	$(Q)install -m0755 hestia/lapis/html.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis/html.moon

hestia/lapis/html.moon.clean:

hestia/lapis/html.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/lapis/html.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis/html.moon'

hestia/lapis/util/functions.moon:

hestia/lapis/util/functions.moon.install: hestia/lapis/util/functions.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/lapis/util/functions.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis/util'
	$(Q)install -m0755 hestia/lapis/util/functions.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis/util/functions.moon

hestia/lapis/util/functions.moon.clean:

hestia/lapis/util/functions.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/lapis/util/functions.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/lapis/util/functions.moon'

hestia/project.moon:

hestia/project.moon.install: hestia/project.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/project.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia'
	$(Q)install -m0755 hestia/project.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/project.moon

hestia/project.moon.clean:

hestia/project.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/project.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/project.moon'

hestia/template.moon:

hestia/template.moon.install: hestia/template.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/template.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia'
	$(Q)install -m0755 hestia/template.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/template.moon

hestia/template.moon.clean:

hestia/template.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/template.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/template.moon'

hestia/templates/bulma.moon:

hestia/templates/bulma.moon.install: hestia/templates/bulma.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/hestia/templates/bulma.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/hestia/templates'
	$(Q)install -m0755 hestia/templates/bulma.moon $(DESTDIR)$(LUA_SHAREDIR)/hestia/templates/bulma.moon

hestia/templates/bulma.moon.clean:

hestia/templates/bulma.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/hestia/templates/bulma.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/hestia/templates/bulma.moon'

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
install: subdirs.install hestia.moon.install hestia/doctree.moon.install hestia/document.moon.install hestia/lapis/html.moon.install hestia/lapis/util/functions.moon.install hestia/project.moon.install hestia/template.moon.install hestia/templates/bulma.moon.install
	@:

subdirs.install:

uninstall: subdirs.uninstall hestia.moon.uninstall hestia/doctree.moon.uninstall hestia/document.moon.uninstall hestia/lapis/html.moon.uninstall hestia/lapis/util/functions.moon.uninstall hestia/project.moon.uninstall hestia/template.moon.uninstall hestia/templates/bulma.moon.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: hestia.moon.clean hestia/doctree.moon.clean hestia/document.moon.clean hestia/lapis/html.moon.clean hestia/lapis/util/functions.moon.clean hestia/project.moon.clean hestia/template.moon.clean hestia/templates/bulma.moon.clean

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
		$(PACKAGE)-$(VERSION)/hestia/doctree.moon \
		$(PACKAGE)-$(VERSION)/hestia/document.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/hestia.moon \
		$(PACKAGE)-$(VERSION)/hestia/project.moon \
		$(PACKAGE)-$(VERSION)/hestia/template.moon \
		$(PACKAGE)-$(VERSION)/hestia/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/hestia.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/hestia/doctree.moon \
		$(PACKAGE)-$(VERSION)/hestia/document.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/hestia.moon \
		$(PACKAGE)-$(VERSION)/hestia/project.moon \
		$(PACKAGE)-$(VERSION)/hestia/template.moon \
		$(PACKAGE)-$(VERSION)/hestia/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/hestia.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/hestia/doctree.moon \
		$(PACKAGE)-$(VERSION)/hestia/document.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/hestia/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/hestia.moon \
		$(PACKAGE)-$(VERSION)/hestia/project.moon \
		$(PACKAGE)-$(VERSION)/hestia/template.moon \
		$(PACKAGE)-$(VERSION)/hestia/templates/bulma.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/hestia.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md

help:
	@echo '[01;37m :: hestia-0.5.0[00m'
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
	@echo '    - [01;33mhestia.moon   [37m script[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:           false'
	@echo '    - colors:        true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

