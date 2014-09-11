PREFIX ?= /usr/local
LDFLAGS += -framework CoreFoundation -ledit

all: mjolnir

mjolnir: mjolnir.o

install: mjolnir
	mkdir -p $(PREFIX)/{share/man/man1,bin}
	install -m 0755 mjolnir $(PREFIX)/bin
	install -m 0644 mjolnir.1 $(PREFIX)/share/man/man1

uninstall:
	rm -fr $(PREFIX)/bin/mjolnir
	rm -fr $(PREFIX)/share/man/man1/mjolnir.1

clean:
	rm -rf mjolnir.o mjolnir

.PHONY: all install clean
