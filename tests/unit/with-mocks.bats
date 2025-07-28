#!/usr/bin/env bats

## should work on mac and ubuntu
## tests just the core features with minimum set of tools

INSTALL_DIR=
BATS_TMPDIR="${BATS_TMPDIR:-/tmp}"
fancyx='✗'
checkmark='✓'
## We need to create a new directory so that .hasrc file in the root does not get read by the `has` instance under test
setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  export HAS_TMPDIR="${BATS_TMPDIR}/tmp-for-test"
  mkdir -p "${HAS_TMPDIR}"
  cp -f "${BATS_TEST_DIRNAME}"/../../has "${HAS_TMPDIR}"
  cd "${HAS_TMPDIR}" || return
  export has="${HAS_TMPDIR}/has"
}

teardown() {
  if [[ -d "${HAS_TMPDIR}" ]]; then
    rm -rf "${HAS_TMPDIR}"
  fi
}


@test "works with commands that support --version (git)" {
  local GIT_VERSION="2.39.5"
  export GIT_VERSION

  run $has git

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep ${checkmark} )" ]
  [ "$(echo "${lines[0]}" | grep "git")" ]
  [ "$(echo "${lines[0]}" | grep "${GIT_VERSION}")" ]
}

@test "works with commands that support -v (unzip)" {
  local UNZIP_VERSION="6.00"
  export UNZIP_VERSION

  run $has unzip

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep ${checkmark} )" ]
  [ "$(echo "${lines[0]}" | grep "unzip")" ]
  [ "$(echo "${lines[0]}" | grep "${UNZIP_VERSION}")" ]
}


@test "works with commands that support -version (java)" {
  local JAVA_VERSION="24.0.2"
  export JAVA_VERSION

  run $has java

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep ${checkmark} )" ]
  [ "$(echo "${lines[0]}" | grep "java")" ]
  [ "$(echo "${lines[0]}" | grep "${JAVA_VERSION}")" ]
}

@test "works with commands that support -V (composer)" {
  local COMPOSER_VERSION="2.7.2"
  export COMPOSER_VERSION

  run $has composer

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep ${checkmark})" ]
  [ "$(echo "${lines[0]}" | grep "composer")" ]
  [ "$(echo "${lines[0]}" | grep "${COMPOSER_VERSION}")" ]
}

@test "works with commands that support version as argument (go)" {
  local GO_VERSION="1.23.6"
  export GO_VERSION

  run $has go

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep ${checkmark} )" ]
  [ "$(echo "${lines[0]}" | grep "go")" ]
  [ "$(echo "${lines[0]}" | grep "${GO_VERSION}")" ]
}

@test "fails gracefully for unknown command" {
  run $has notarealcmd

  echo "OUTPUT: ${lines[0]}" >&3

  [ "$status" -eq 1 ]
  [ "$(echo "${lines[0]}" | grep ${fancyx} )" ]
  [ "$(echo "${lines[0]}" | grep "notarealcmd")" ]
}
