# Makefile for has
# https://github.com/kdabir/has
# Sadly, longopts like --verbose are not working on MacOS for cp, mkdir and rm


# PREFIX is an environment variable.
# Use default value if not set.
ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif


test: unit-test intg-test

unit-test:
	bats tests/unit/unit-tests.bats
	bats tests/unit/with-mocks.bats

intg-test:
	bats -t tests/intg/intg-tests.bats 

has :
	# ensure 'has' in repo
	git checkout --force -- has

# install 'has' in specified directory
install : has
	chmod 755 has && \
	mkdir -v -p $(DESTDIR)$(PREFIX)/bin && \
	cp -v has $(DESTDIR)$(PREFIX)/bin/has

# update: has
update : update-fetch has

update-fetch : update-force
	# update repo from upstream
	git fetch --verbose --force

update-force :
	# remove local repo 'has' to force update
	rm -f has

uninstall :
	rm -f $(DESTDIR)$(PREFIX)/bin/has

.PHONY: test install uninstall update

CONTAINERS = ubuntu alpine

.PHONY: docker-test

docker-test:
	@for c in $(CONTAINERS); do \
		$(MAKE) docker-test-$$c; \
	done

.PHONY: docker-test-%
docker-test-%:
	docker build -t test-image:$* -f tests/to-fix/containers/$*.Dockerfile .
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		test-image:$* \
		bash -c "make test || bats -t ./tests/to-fix/test_all_packages.bats || true"
