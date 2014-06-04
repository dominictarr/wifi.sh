
BIN ?= wifi
PREFIX ?= /usr/local

install:
	cp index.sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

