PACKAGE = 'lunadoc'
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

all: lunadoc modules/lunadoc/doc_moon.moon modules/lunadoc/document.moon modules/lunadoc/gsplit.moon modules/lunadoc/indent.moon modules/lunadoc/init.moon modules/lunadoc/lapis/html.moon modules/lunadoc/lapis/util/functions.moon modules/lunadoc/project.moon modules/lunadoc/template.moon
	@:

lunadoc:

lunadoc.install: lunadoc
	@echo '[01;31m  IN >    [01;37m$(BINDIR)/lunadoc[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 lunadoc $(DESTDIR)$(BINDIR)/lunadoc

lunadoc.clean:

lunadoc.uninstall:
	@echo '[01;37m  RM >    [01;37m$(BINDIR)/lunadoc[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/lunadoc'

modules/lunadoc/doc_moon.moon:

modules/lunadoc/doc_moon.moon.install: modules/lunadoc/doc_moon.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/doc_moon.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/doc_moon.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/doc_moon.moon

modules/lunadoc/doc_moon.moon.clean:

modules/lunadoc/doc_moon.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/doc_moon.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/doc_moon.moon'

modules/lunadoc/document.moon:

modules/lunadoc/document.moon.install: modules/lunadoc/document.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/document.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/document.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/document.moon

modules/lunadoc/document.moon.clean:

modules/lunadoc/document.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/document.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/document.moon'

modules/lunadoc/gsplit.moon:

modules/lunadoc/gsplit.moon.install: modules/lunadoc/gsplit.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/gsplit.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/gsplit.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/gsplit.moon

modules/lunadoc/gsplit.moon.clean:

modules/lunadoc/gsplit.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/gsplit.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/gsplit.moon'

modules/lunadoc/indent.moon:

modules/lunadoc/indent.moon.install: modules/lunadoc/indent.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/indent.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/indent.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/indent.moon

modules/lunadoc/indent.moon.clean:

modules/lunadoc/indent.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/indent.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/indent.moon'

modules/lunadoc/init.moon:

modules/lunadoc/init.moon.install: modules/lunadoc/init.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/init.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/init.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/init.moon

modules/lunadoc/init.moon.clean:

modules/lunadoc/init.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/init.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/init.moon'

modules/lunadoc/lapis/html.moon:

modules/lunadoc/lapis/html.moon.install: modules/lunadoc/lapis/html.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/lapis/html.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis'
	$(Q)install -m0755 modules/lunadoc/lapis/html.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis/html.moon

modules/lunadoc/lapis/html.moon.clean:

modules/lunadoc/lapis/html.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/lapis/html.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis/html.moon'

modules/lunadoc/lapis/util/functions.moon:

modules/lunadoc/lapis/util/functions.moon.install: modules/lunadoc/lapis/util/functions.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/lapis/util/functions.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis/util'
	$(Q)install -m0755 modules/lunadoc/lapis/util/functions.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis/util/functions.moon

modules/lunadoc/lapis/util/functions.moon.clean:

modules/lunadoc/lapis/util/functions.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/lapis/util/functions.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/lapis/util/functions.moon'

modules/lunadoc/project.moon:

modules/lunadoc/project.moon.install: modules/lunadoc/project.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/project.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/project.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/project.moon

modules/lunadoc/project.moon.clean:

modules/lunadoc/project.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/project.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/project.moon'

modules/lunadoc/template.moon:

modules/lunadoc/template.moon.install: modules/lunadoc/template.moon
	@echo '[01;31m  IN >    [01;37m$(LUA_SHAREDIR)/lunadoc/template.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc'
	$(Q)install -m0755 modules/lunadoc/template.moon $(DESTDIR)$(LUA_SHAREDIR)/lunadoc/template.moon

modules/lunadoc/template.moon.clean:

modules/lunadoc/template.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(LUA_SHAREDIR)/lunadoc/template.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(LUA_SHAREDIR)/lunadoc/template.moon'

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
install: subdirs.install lunadoc.install modules/lunadoc/doc_moon.moon.install modules/lunadoc/document.moon.install modules/lunadoc/gsplit.moon.install modules/lunadoc/indent.moon.install modules/lunadoc/init.moon.install modules/lunadoc/lapis/html.moon.install modules/lunadoc/lapis/util/functions.moon.install modules/lunadoc/project.moon.install modules/lunadoc/template.moon.install
	@:

subdirs.install:

uninstall: subdirs.uninstall lunadoc.uninstall modules/lunadoc/doc_moon.moon.uninstall modules/lunadoc/document.moon.uninstall modules/lunadoc/gsplit.moon.uninstall modules/lunadoc/indent.moon.uninstall modules/lunadoc/init.moon.uninstall modules/lunadoc/lapis/html.moon.uninstall modules/lunadoc/lapis/util/functions.moon.uninstall modules/lunadoc/project.moon.uninstall modules/lunadoc/template.moon.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: lunadoc.clean modules/lunadoc/doc_moon.moon.clean modules/lunadoc/document.moon.clean modules/lunadoc/gsplit.moon.clean modules/lunadoc/indent.moon.clean modules/lunadoc/init.moon.clean modules/lunadoc/lapis/html.moon.clean modules/lunadoc/lapis/util/functions.moon.clean modules/lunadoc/project.moon.clean modules/lunadoc/template.moon.clean

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
		$(PACKAGE)-$(VERSION)/lunadoc \
		$(PACKAGE)-$(VERSION)/examples/example.template.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/doc_moon.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/document.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/gsplit.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/indent.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/init.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/project.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/template.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunadoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.1-2.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.2-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.3-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.4-1.rockspec

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/lunadoc \
		$(PACKAGE)-$(VERSION)/examples/example.template.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/doc_moon.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/document.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/gsplit.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/indent.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/init.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/project.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/template.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunadoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.1-2.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.2-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.3-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.4-1.rockspec

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/lunadoc \
		$(PACKAGE)-$(VERSION)/examples/example.template.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/doc_moon.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/document.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/gsplit.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/indent.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/init.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/html.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/lapis/util/functions.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/project.moon \
		$(PACKAGE)-$(VERSION)/modules/lunadoc/template.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/lunadoc.cfg \
		$(PACKAGE)-$(VERSION)/LICENSE.md \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.1-2.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.2-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.3-1.rockspec \
		$(PACKAGE)-$(VERSION)/package/lunadoc-0.4-1.rockspec

help:
	@echo '[01;37m :: lunadoc-0.5.0[00m'
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
	@echo '    - [01;33mlunadoc       [37m script[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:           false'
	@echo '    - colors:        true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

