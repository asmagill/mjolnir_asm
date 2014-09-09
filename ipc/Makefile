LUAFILES  = init.lua
OBJCFILES = internal.m
HEADERS   = 

CFLAGS  += -Wall -Wextra
LDFLAGS += -dynamiclib -undefined dynamic_lookup

OFILES  := $(OBJCFILES:m=o)
SOFILES := $(OBJCFILES:m=so)

all: $(SOFILES)

install: $(SOFILES)
	install -d /usr/local/lib/lua/5.2/mjolnir/_asm/ipc/
	cp $(SOFILES) /usr/local/lib/lua/5.2/mjolnir/_asm/ipc 
	install -d /usr/local/share/lua/5.2/mjolnir/_asm/ipc/
	cp $(LUAFILES) /usr/local/share/lua/5.2/mjolnir/_asm/ipc/

uninstall:
	rm -fr /usr/local/lib/lua/5.2/mjolnir/_asm/ipc/$(SOFILES)
	rm -fr /usr/local/share/lua/5.2/mjolnir/_asm/ipc/$(LUAFILES)

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
	rm -rf $(OFILES) $(SOFILES) docs.json docs.in.sql docs.out.sql mjolnir docs.html.d $(TARFILE)

.PHONY: all clean
