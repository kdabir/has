test:
	bats .hastest.bats

install:
	cp has /usr/local/bin/has

uninstall:
	rm -f /usr/local/bin/has
