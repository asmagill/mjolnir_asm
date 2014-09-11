PREFIX ?= /usr/local
MODULE = compat_51
LUAFILE  = init.lua
OBJCFILE = internal.m
HEADERS  = 

CFLAGS  += -Wall -Wextra
LDFLAGS += -dynamiclib -undefined dynamic_lookup

OFILE  := $(OBJCFILE:m=o)
SOFILE := $(OBJCFILE:m=so)

all: $(SOFILE)

install: install-library install-lua

install-library: $(SOFILE)
	mkdir -p $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)
	install -m 0644 $(SOFILE) $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)
	
install-lua: $(LUAFILE)
	mkdir -p $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)
	install -m 0644 $(LUAFILE) $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)

uninstall:
	rm -fr $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)/$(SOFILE)
	rm -fr $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)/$(LUAFILE)

bundle: $(TARFILE)

$(SOFILE): $(OFILE) $(HEADERS)
	$(CC) $(OFILE) $(CFLAGS) $(LDFLAGS) -o $@

docs.json: $(OBJCFILE) $(LUAFILE)
	ruby gendocs.rb --json $^ > $@

docs.in.sql: docs.json
	ruby gendocs.rb --sqlin $^ > $@

docs.out.sql: docs.json
	ruby gendocs.rb --sqlout $^ > $@

docs.html.d: docs.json
	rm -rf $@
	mkdir -p $@
	ruby gendocs.rb --html $^ $@

$(TARFILE): $(SOFILE) $(LUAFILE) docs.html.d docs.in.sql docs.out.sql README.md
	tar -czf $@ $^

clean:
	rm -rf $(OFILE) $(SOFILE) docs.json docs.in.sql docs.out.sql mjolnir docs.html.d $(TARFILE) *.rock

.PHONY: all clean
