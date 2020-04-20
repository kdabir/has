FROM bash:5.0.16

# already contains
#       awk
#       bash=5.0.16
#       bzip2
#       grep
#       gzip=1.31.1
#       sed=4.0
#       tar=1.31.1
#       unzip=6.00
#       wget
#       xz
RUN apk add --no-cache \
        ack=3.2.0-r0 \
        apache2-utils `# ab=2.3` \
        curl=7.67.0-r0 \
        bzr=2.7.0-r1 \
        docker=19.03.5-r0 \
        emacs=26.3-r2 \
        file=5.37-r1 \
        gcc=9.2.0-r4 \
        git~=2.24.2 \
        go=1.13.4-r1 \
        gradle=5.6.4-r0 \
        httpie=1.0.3-r1 `# http=1.0.3` \
        hugo=0.61.0-r0 \
        jq=1.6-r0 \
        make=4.2.1-r2 \
        maven=3.6.3-r0 `# mvn=3.6.3` \
        mercurial=5.3.2-r0 `# hg=5.3.2` \
        nano=4.6-r0 \
        ncurses=6.1_p20200118-r3 `#tput:todo` \
        npm=12.15.0-r1 `# npm=6.13.4 # node=12.15.0` \
        openjdk11=11.0.5_p10-r0 `# java=11.0.5` \
        perl=5.30.1-r0 ` # perl=30` \
        php7=7.3.17-r0 `# php=7.3.17 ` \
        postgresql=12.2-r0 `# psql=12.2` \
        pv=1.6.6-r1 \
        python=2.7.16-r3 \
        python3=3.8.2-r0 \
        R=3.6.2-r0 \
        ruby=2.6.6-r2 \
        ruby-bundler=2.0.2-r1 `# bundle=2.0.2` \
        ruby-bigdecimal ruby-json `# required for brew` \
        subversion=1.12.2-r1 `# svn=1.12.2` \
        sudo=1.8.31-r0 \
        tree=1.8.0-r0 \
        vim=8.2.0-r0 `# vim=8.2` \
        yarn=1.19.2-r0 \
        zip=3.0-r7 \
        zsh=5.7.1-r0; \
    \
    npm install --global \
        brunch@"=3.0.0" \
        grunt-cli@"=1.3.2" \
        gulp-cli@"=2.2.0" \
        heroku@"=7.39.3" \
        netlify-cli@"=2.46.0" \
        serverless@"=1.67.3" `# sls=1.67.3`; \
    \
    commit="87b16eb" `# bats=1.2.0`; \
    curl -L "https://github.com/bats-core/bats-core/tarball/${commit}" | tar xz; \
    "bats-core-bats-core-${commit}/install.sh" /usr/local; \
    \
    brew=2.2.13; \
    git clone --branch ${brew} https://github.com/Homebrew/brew; \
    ln -s $(which bash) /bin/bash; \
    eval $(brew/bin/brew shellenv); \
    ln -s /brew/bin/brew /usr/local/bin/brew; \
    brew --version; \
    \
    gcloud=289.0.0; \
    curl -L "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${gcloud}-linux-x86_64.tar.gz" | tar xz; \
    \
    gor=1.0.0; \
    curl -L "https://github.com/buger/goreplay/releases/download/v${gor}/gor_${gor}_x64.tar.gz" | tar xz --directory /usr/local/bin; \
    \
    hub=2.14.2; \
    curl -L "https://github.com/github/hub/releases/download/v${hub}/hub-linux-386-${hub}.tgz" | tar xz; \
    ln -s "/hub-linux-386-${hub}/bin/hub" /usr/local/bin/hub; \
    \
    `# javac=11.0.5`; \
    ln -s "/usr/lib/jvm/java-11-openjdk/bin/javac" /usr/local/bin/javac; \
    \
    netlifyctl=0.4.0; \
    curl -L "https://github.com/netlify/netlifyctl/releases/download/v${netlifyctl}/netlifyctl-linux-amd64-${netlifyctl}.tar.gz" | tar xz --directory /usr/local/bin; \
    \
    rg=12.0.1; \
    curl -L "https://github.com/BurntSushi/ripgrep/releases/download/${rg}/ripgrep-${rg}-x86_64-unknown-linux-musl.tar.gz" | tar xz; \
    ln -s "/ripgrep-${rg}-x86_64-unknown-linux-musl/rg" /usr/local/bin/rg; \
    \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    apk add --no-cache \
        podman=1.9.0-r0

ENV PATH /google-cloud-sdk/bin:$PATH
