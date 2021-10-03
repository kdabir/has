# has

`has` checks presence of various command line tools on the PATH and reports their installed version.

[![Build Status](https://travis-ci.org/kdabir/has.svg?branch=master)](https://travis-ci.org/kdabir/has)
[![Open Source Helpers](https://www.codetriage.com/kdabir/has/badges/users.svg)](https://www.codetriage.com/kdabir/has)

[![demo](demo.svg)](demo.svg)

## Quick Start 🚴

Just [install](#installing) the `has` script, (there is no dependency apart from `bash` itself). From the command line, pass the list of commands you want to check as arguments to `has`, for example:

```console
$ has node npm java git gradle
✔ node 8.2.1
✔ npm 5.3.0
✔ java 1.8.0
✔ git 2.14.1
✔ gradle 4.0.1
```

If everything is good `has` exits with status code `0`. The exit status code reflects number of commands **not found** on your path.

```console
$ has node go javac
✔ node 8.2.1
✔ go 1.8.3
✘ javac
```

And echo the status:

```console
$ echo $?
1
```

## Use `has` in scripts

`has` can be used in shell scripts to check presence of tool in very readable way

```bash
if has node
    then echo you have what it takes 🎉
fi
```

**Pro Tip**: the `has` in above command can be replaced with the entire curl command for to ensure portability of script → `if curl -sL https://git.io/_has | bash -s node then ...`


## Installing 🚀

`has` is a single bash script that does it all. You can [download](https://raw.githubusercontent.com/kdabir/has/master/has) the script and make it available on your `$PATH`. However, to make it even simpler, just follow *one* of these methods.

### Homebrew (MacOS) 🍺

Just run the following: 

```bash
brew install kdabir/tap/has
```

### Cloning the Repo

Just execute the following command in a terminal: it clones `has` repo and installs it into your path.

```bash
git clone https://github.com/kdabir/has.git && cd has && sudo make install
```

For a non-root installation:

```bash
git clone https://github.com/kdabir/has.git
cd has
make PREFIX=$HOME/.local install
```

To update just do a `git fetch` or `make update` followed by the appropriate `make install` command.

### Downloading to a file

```bash
curl -sL https://git.io/_has > /usr/local/bin/has
```

```bash
curl -sL https://git.io/_has | sudo tee /usr/local/bin/has >/dev/null
```

These commands are safe to be called multiple times as well (to update `has`)

### asdf users

```
asdf plugin add has https://github.com/sylvainmetayer/asdf-has
asdf install has 1.4.0
```

### Running directly off the Internet

If you are lazy, you can run `has` directly off the Internet as well:

```console
curl -sL https://git.io/_has | bash -s git node npm
✔ git 2.17.1
✔ node 11.11.0
✔ npm 6.7.0
```

**ProTip**: if that's too much typing every time, setup an alias in your `.bashrc`/`.zshrc` file:

```.bashrc
alias has="curl -sL https://git.io/_has | bash -s"
```

And use it

```console
$ has git
✔ git 2.17.1
$ type has
has is aliased to `curl -sL https://git.io/_has | bash -s'
```

## Command not understood by has?

Let's say `$ has foobar` returns `foobar not understood`, because `has` may not have whitelisted `foobar`.

In such cases, pass `HAS_ALLOW_UNSAFE=y has foobar`. This should still check for existance of `foobar` and tries to detect version as well.

> the value must exactly be `y` for it to work.

## The `.hasrc` file

`has` looks for `.hasrc` file in the directory from where `has` command is issued. This file can contain commands that `has`
will check for. List one command per line. Lines starting with `#` are treated as comments.

Following is example of `.hasrc` file:

```hs
# tools
git
curl

# interpreters
ruby
node
```

When `has` is run in directory containing this file, it produces:

```console
$ has
✔ git 2.19.1
✔ curl 7.54.0
✔ ruby 2.3.1
✔ node 10.7.0
```

Also, CLI arguments passed to `has` are additive to `.hasrc` file. For example, in the same dir, if the following command is fired,
`has` checks for both commands passed from cli args and provided in `.hasrc` file.

```bash
$ has java
✔ java 11.0.1
✔ git 2.19.1
✔ curl 7.54.0
✔ ruby 2.3.1
✔ node 10.7.0
```

**Pro Tip**: commit `.hasrc` file in root of your project. This can work as a quick check for confirming presence all command
line tools required to build and run your project.

On machines that don't even have `has` installed, your project's `.hasrc` is honored by this command:

`curl -sL https://git.io/_has | bash -s`

> take a look at [.hasrc](https://github.com/kdabir/has/blob/master/.hasrc) file for this repo.

## Contributing

1. Star the repo, tweet about it, spread the word
2. Update the documentation (i.e. the README file)
3. Adding support for more commands
4. Adding more features to `has`

## Adding more tools

The current list of supported packages can be viewed with `bash tests/packages_all.sh`

If the command you wish to include supports any of `-v`, `--version`, `-version`, `version`, `-V` then you can find 
corresponding function which can be called to check presence and extract version. However, for many tools version
extraction may not work and you will need to add custom parsing of command's output. The `has` script is commented
to guide developers about what needs to be done to add more tools. 

`/tests/test_all_packages.bats` will test every package has supports. This includes newly added commands so please add new packages to
 - `alpine.Dockerfile` and `ubuntu.Dockerfile` to install the tool OR
 - `packages_alpine_skip.txt` and `packages_ubuntu_skip.txt` to exclude the package from the tests

## Adding Features

If you are contributing a feature, please ensure to check current tests. Add test cases for your feature. Tests are
executed using the excellent [bats](https://github.com/bats-core/bats-core) testing framework. Add tests and run `make test`

Raise the PR and **make sure the tests pass** on [Travis-CI](https://travis-ci.org/kdabir/has).

### ♥
