# Makefile for has
# https://github.com/kdabir/has

# PREFIX is an environment variable.
# Use default value if not set.
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

test:
	bats .hastest.bats

has:
	git checkout -- has

install: has
	install -vD -m 0755 has $(DESTDIR)$(PREFIX)/bin/has

update: has
	git pull

uninstall:
	rm -f /usr/local/bin/has

.PHONY: test install uninstall update
