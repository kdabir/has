FROM ubuntu:xenial-20200212

# already contains
#       apt
#       apt-get
#       bash
#       grep
#       gzip
#       tar
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y -qq \
        bc \
        pv \
        unar \
        make \
        curl \
        git \
        unzip \
        xz-utils `#xz` \
        unar \
        pv \
        zip \
        sudo \
        file \
        && apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*; \
    \
    #bats
    commit="87b16eb"; \
    curl -L "https://github.com/bats-core/bats-core/tarball/${commit}" | tar xz; \
    "bats-core-bats-core-${commit}/install.sh" /usr/local; \
    \
    #hub
    curl -fsSL https://github.com/github/hub/raw/master/script/get | bash -s 2.14.2
