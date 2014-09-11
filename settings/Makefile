PREFIX = /usr/local
MODULE = settings
LUAFILES  = init.lua
OBJCFILES = internal.m
HEADERS   = 

CFLAGS  += -Wall -Wextra
LDFLAGS += -dynamiclib -undefined dynamic_lookup

OFILES  := $(OBJCFILES:m=o)
SOFILES := $(OBJCFILES:m=so)

all: $(SOFILES)

install: $(SOFILES)
	install -d $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)/
	cp $(SOFILES) $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)/
	install -d $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)/
	cp $(LUAFILES) $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)/

uninstall:
	rm -fr $(PREFIX)/lib/lua/5.2/mjolnir/_asm/$(MODULE)/$(SOFILES)
	rm -fr $(PREFIX)/share/lua/5.2/mjolnir/_asm/$(MODULE)/$(LUAFILES)

bundle: $(TARFILE)

$(SOFILES): $(OFILES) $(HEADERS)
	$(CC) $(OFILES) $(CFLAGS) $(LDFLAGS) -o $@

docs.json: $(OBJCFILES) $(LUAFILES)
	ruby gendocs.rb --json $^ > $@

docs.in.sql: docs.json
	ruby gendocs.rb --sqlin $^ > $@

docs.out.sql: docs.json
	ruby gendocs.rb --sqlout $^ > $@

docs.html.d: docs.json
	rm -rf $@
	mkdir -p $@
	ruby gendocs.rb --html $^ $@

$(TARFILE): $(SOFILES) $(LUAFILES) docs.html.d docs.in.sql docs.out.sql README.md
	tar -czf $@ $^

clean:
	rm -rf $(OFILES) $(SOFILES) docs.json docs.in.sql docs.out.sql mjolnir docs.html.d $(TARFILE) *.rock

.PHONY: all clean
