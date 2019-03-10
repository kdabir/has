#PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

test:
	bats .hastest.bats

has:
	git pull

install: has
	install -vD -m 0755 has $(DESTDIR)$(PREFIX)/bin

update: has
	git pull

uninstall:
	rm -f /usr/local/bin/has

.PHONY: test install uninstall update
