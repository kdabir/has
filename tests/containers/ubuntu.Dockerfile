FROM ubuntu:bionic-20200311

# Updates path with node, npm, npx, and globally installed npm packages
ENV node=12.18.1
ENV PATH="${PATH}:/node-v${node}-linux-x64/bin"

# already contains
#       apt=1.6.12
#       apt-get=1.6.12
#       awk
#       bash=4.4.20
#       bzip2=1.0.6
#       gnu_coreutils=8.28
#       grep=3.1
#       gzip=1.6
#       perl=26
#       sed=4.4
#       tar=1.29
#       tput #todo
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y -qq \
        ack=2.22* \
        ant=1.10.5* \
        apache2-utils=2.4* `# ab=2.3` \
        apt-utils `# todo` \
        aptitude=0.8.10* \
        autojump=22.5.0* \
        awscli=1.14.44* `# aws=1.14.44` \
        build-essential zlib1g-dev libssl-dev libncurses-dev libffi-dev libsqlite3-dev libreadline-dev libbz2-dev `# required for eb` \
        bzr=2.7.0+bzr6622-10 `# bzr=2.8.0` \
        curl=7.58.0* \
        docker.io=19.03.6* `# docker=19.03.6` \
        emacs=47.0 `# emacs=25.2.2` \
        file=1:5.32* \
        gcc=4:7.4.0-1ubuntu2.3 `# gcc=7.5.0` \
        git=1:2.17.1* \
        gpg-agent `# todo:apt-key` \
        gradle=4.4.1* \
        groovy=2.4.16* \
        httpie=0.9.8* `# http=0.9.8` \
        hugo=0.40.1* \
        jq=1.5* \
        leiningen=2.8.1* `# lein=2.8.1` \
        locales `# required for brew` \
        make=4.1* \
        maven=3.6.0* `# mvn=3.6.0` \
        mercurial=4.5.3* `# hg=4.5.3` \
        nano=2.9.3* \
        openjdk-11-jdk-headless=11.0.7* `# java=11.0.7 # javac=11.0.7` \
        perl6=6.c-1 `# perl6=2018.03` \
        php=1:7.2+60ubuntu1 `# php=7.2.24` \
        postgresql-client=10+190* `# psql=10.12` \
        pv=1.6.6* \
        python=2.7.15~rc1-1 `# python=2.7.17` \
        python3=3.6.7-1~18.04 `# python3=3.6.9` \
        r-cran-littler=0.3.3* `# R=3.4.4` \
        rake=12.3.1* \
        ruby=1:2.5.1 \
        ruby-bundler=1.16.1* `# bundle=1.16.1` \
        rubygems `# gem=2.7.6` \
        scala=2.11.12* \
        silversearcher-ag=2.1.0* `# ag=2.1.0` \
        software-properties-common `# todo:add-apt-repository` \
        subversion=1.9.7* `# svn=1.9.7` \
        sudo=1.8.21* \
        tree=1.7.0* \
        unar=1.10.1* \
        unzip=6.0-21ubuntu1 `# unzip=6.00` \
        vim=2:8.0* \
        wget=1.19.4* \
        xz-utils=5.2.2* `# xz=5.2.2` \
        yarn `# yarn=0.32` \
        zip=3.0* \
        zsh=5.4.2* && \
    \
    commit="87b16eb" `# bats=1.2.0` && \
    curl -L "https://github.com/bats-core/bats-core/tarball/${commit}" | tar xz && \
    "bats-core-bats-core-${commit}/install.sh" /usr/local && \
    \
    brew=2.2.13 && \
    git clone --branch ${brew} https://github.com/Homebrew/brew && \
    locale-gen en_US en_US.UTF-8 && \
    eval $(brew/bin/brew shellenv) && \
    ln -s /brew/bin/brew /usr/local/bin/brew && \
    brew --version && \
    \
    code=1.44.2 && \
    curl -L "https://az764295.vo.msecnd.net/stable/ff915844119ce9485abfe8aa9076ec76b5300ddd/code_${code}-1587059832_amd64.deb" --output code_${code}.deb && \
    `# installing missing dependencies requires apt update which is the first done above` \
    dpkg -i code_${code}.deb || apt-get install -f -y && \
    rm -f code_${code}.deb && \
    \
    commit="102025c" `# eb=3.18.1` && \
    curl -L "https://github.com/aws/aws-elastic-beanstalk-cli-setup/tarball/${commit}" | tar xz && \
    "aws-aws-elastic-beanstalk-cli-setup-${commit}/scripts/bundled_installer" && \
    ln -s /root/.ebcli-virtual-env/executables/eb /usr/local/bin/eb && \
    \
    gcloud=289.0.0 && \
    curl -L "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${gcloud}-linux-x86_64.tar.gz" | tar xz && \
    ln -s /google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    \
    gor=1.0.0 && \
    curl -L "https://github.com/buger/goreplay/releases/download/v${gor}/gor_${gor}_x64.tar.gz" | tar xz --directory /usr/local/bin && \
    \
    hub=2.14.2 && \
    curl -fsSL "https://github.com/github/hub/raw/master/script/get" | bash -s ${hub} && \
    \
    kotlin=1.3.72 && \
    curl -L "https://github.com/JetBrains/kotlin/releases/download/v${kotlin}/kotlin-compiler-${kotlin}.zip" -o /kotlin.zip && \
    unzip kotlin.zip && rm kotlin.zip && \
    ln -s /kotlinc/bin/kotlin /usr/local/bin/kotlin && \
    ln -s /kotlinc/bin/kotlinc /usr/local/bin/kotlinc && \
    \
    netlifyctl=0.4.0 && \
    curl -L "https://github.com/netlify/netlifyctl/releases/download/v${netlifyctl}/netlifyctl-linux-amd64-${netlifyctl}.tar.gz" | tar xz --directory /usr/local/bin && \
    \
    rg=12.0.1 && \
    curl -L "https://github.com/BurntSushi/ripgrep/releases/download/${rg}/ripgrep-${rg}-x86_64-unknown-linux-musl.tar.gz" | tar xz && \
    ln -s "/ripgrep-${rg}-x86_64-unknown-linux-musl/rg" /usr/local/bin/rg && \
    \
    sbt=1.3.4 && \
    curl -L "https://piccolo.link/sbt-${sbt}.tgz" | tar xz && \
    ln -s /sbt/bin/sbt /usr/local/bin/sbt && \
    sbt --version && sbt --version && \
    \
    add-apt-repository -y ppa:longsleep/golang-backports `#go` && \
    add-apt-repository -y ppa:ondrej/php `#php5` && \
    add-apt-repository -y ppa:projectatomic/ppa `#podman` && \
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - `#subl` && \
    add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/" `#subl` && \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y -qq \
        golang-go=2:1.14* `# go=1.14.2` \
        php5.6=5.6.40* `# php5=5.6.40` \
        podman=1.6.2* \
        sublime-text=3211 `# subl=3211` && \
    ln -s /usr/bin/php5.6 /usr/bin/php5 && \
    \
    curl -L "https://nodejs.org/dist/v${node}/node-v${node}-linux-x64.tar.gz" | tar xz && \
    \
    npm install --global --no-optional `# npm=6.14.5` \
        brunch@"=3.0.0" \
        grunt-cli@"=1.3.2" \
        gulp-cli@"=2.2.0" \
        heroku@"=7.39.3" \
        netlify-cli@"=2.33.0" \
        serverless@"=1.67.3" `# sls=1.67.3` && \
    \
    apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*
