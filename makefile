NAME=dummy-virtual-keyboard

INSTALL = install
INSTALL_PROGRAM = ${INSTALL} -D -m 0755
INSTALL_DATA = ${INSTALL} -D -m 0644

prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
libdir = $(exec_prefix)/lib

DEBUG ?= 0
ifeq ($(DEBUG),0)
	ARGS += --release
	TARGET = release
endif

all: build

install:
	echo "installing executable file to $(DESTDIR)$(bindir)"
	$(INSTALL_PROGRAM) "target/release/${NAME}" "$(DESTDIR)$(bindir)/$(NAME)"

	$(INSTALL_DATA) "./$(NAME).service" "$(DESTDIR)$(libdir)/systemd/system/$(NAME).service"

uninstall:
	echo "removing executable file from $(DESTDIR)$(bindir)"
	rm -f "$(DESTDIR)$(bindir)/$(NAME)"
	rm -f "$(DESTDIR)$(libdir)/systemd/system/$(NAME).service"

clean:
	echo cleaning
	cargo clean

build:
	cargo build $(ARGS)