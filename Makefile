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

# Completion directories
BASH_COMPLETION_DIR := $(DESTDIR)$(PREFIX)/share/bash-completion/completions
ZSH_COMPLETION_DIR := $(DESTDIR)$(PREFIX)/share/zsh/site-functions
FISH_COMPLETION_DIR := $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d

# install 'has' in specified directory
install : has
	chmod 755 has && \
	mkdir -v -p $(DESTDIR)$(PREFIX)/bin && \
	cp -v has $(DESTDIR)$(PREFIX)/bin/has

# install shell completions
install-completions:
	mkdir -v -p $(BASH_COMPLETION_DIR) && \
	mkdir -v -p $(ZSH_COMPLETION_DIR) && \
	mkdir -v -p $(FISH_COMPLETION_DIR) && \
	cp -v completions/has.bash $(BASH_COMPLETION_DIR)/has && \
	cp -v completions/_has $(ZSH_COMPLETION_DIR)/_has && \
	cp -v completions/has.fish $(FISH_COMPLETION_DIR)/has.fish

# install everything
install-all: install install-completions

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

uninstall-completions:
	rm -f $(BASH_COMPLETION_DIR)/has
	rm -f $(ZSH_COMPLETION_DIR)/_has
	rm -f $(FISH_COMPLETION_DIR)/has.fish

uninstall-all: uninstall uninstall-completions

.PHONY: test install install-completions install-all uninstall uninstall-completions uninstall-all update

# bump VERSION in 'has', commit, tag and push. Triggers .github/workflows/release.yml
release:
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "Working tree is not clean. Commit or stash changes first."; exit 1; \
	fi
	@read -p "New version (vX.Y.Z): " version; \
	if ! echo "$$version" | grep -qE '^v[0-9]+\.[0-9]+\.[0-9]+$$'; then \
		echo "Version must look like vX.Y.Z"; exit 1; \
	fi; \
	sed -i.bak "s/^readonly VERSION=.*/readonly VERSION=\"$$version\"/" has && rm has.bak; \
	git commit -am "release $$version"; \
	git tag "$$version"; \
	git push origin HEAD "$$version"

.PHONY: release

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


list:
	@grep -o "^ \\+[a-zA-Z0-9_|-]\\+)" has | grep -o "[a-zA-Z0-9_|-]\\+" | tr "|" "\\n" | sort -f | sed '1,3d'


check:
	@shellcheck has

.PHONY: check
