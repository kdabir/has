# Makefile for has
# https://github.com/kdabir/has

# PREFIX is an environment variable.
# Use default value if not set.
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

test : has
	bats .hastest.bats

has :
	# ensure 'has' in repo
	git checkout --force -- has

install : has
	# install 'has' in specified directory
	chmod 755 has && \
	mkdir --verbose --parents $(DESTDIR)$(PREFIX)/bin && \
	cp --verbose --update has $(DESTDIR)$(PREFIX)/bin/has

# update: has
update : update-fetch has

update-fetch : update-force
	# update repo from upstream
	git fetch --verbose --force

update-force :
	# remove local repo 'has' to force update
	rm --force has

uninstall :
	rm --force /usr/local/bin/has

.PHONY: test install uninstall update

