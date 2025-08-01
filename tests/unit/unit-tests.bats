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

@test "invoking 'has' without arguments prints usage" {
  run $has

  [ "$status" -eq 0 ]
  __assert_usage
}

# @test "make install creates a valid installation" {
#   INSTALL_DIR="${HAS_TMPDIR}/.local"
#   ## has is two levels up
#   cd "${BATS_TEST_DIRNAME}/../.."
#   run make PREFIX="${INSTALL_DIR}" install
#   [ "$status" -eq 0 ]
#   [ -x "${INSTALL_DIR}/bin/has" ]
#
#   # has reads .hasrc from $PWD, so change anywhere else.
#   cd "${INSTALL_DIR}"
#   run "${INSTALL_DIR}/bin/has"
#
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = 'Usage: has [OPTION] <command-names>...' ]
#   [ "${lines[1]}" = 'Has checks the presence of various command line tools on the PATH and reports their installed version.' ]
#   [ "${lines[2]}" = 'Options:' ]
#   [ "${lines[3]}" = '        -q              Silent mode' ]
#   [ "${lines[4]}" = '        -h, --help      Display this help text and quit' ]
#   [ "${lines[5]}" = '        -v, --version   Show version number and quit' ]
#   [ "${lines[6]}" = 'Examples: has git curl node' ]
# }
#
# @test "..even if 'has' is missing from directory" {
#   if [[ -n $GITHUB_ACTION ]] || [[ -n $GITHUB_ACTIONS ]]; then
#     if grep -iq "ubuntu" /etc/issue; then
#       skip "todo: this test fails on ubuntu in CI"
#     fi
#   fi
#
#   INSTALL_DIR="${HAS_TMPDIR}/system_local"
#   cd "${BATS_TEST_DIRNAME}"
#
#   run make PREFIX="${INSTALL_DIR}" install
#   [ "$status" -eq 0 ]
#   [ -x "${INSTALL_DIR}/bin/has" ]
#   cd "${BATS_TEST_DIRNAME}"
#
# }

#@test "make update runs git fetch" {
#  cd "${BATS_TEST_DIRNAME}"
#  if [[ -z $GITHUB_ACTION ]] && [[ -z $GITHUB_ACTIONS ]]; then
#    skip "make update overwrites my git working tree"
#  elif grep -iq "ubuntu" /etc/issue; then
#    skip "todo: this test fails on ubuntu in CI"
#  fi
#
#  run make update
#
#  [ "$status" -eq 0 ]
#  [ "$(echo "${output}" | grep "git fetch --verbose")" ]
#}

@test "works with single command check" {
  local GIT_VERSION="2.39.5"
  export GIT_VERSION
  run $has git

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "git")" ]
  [ "$(echo "${lines[0]}" | grep "${GIT_VERSION}")" ]
}

@test "'has' warns about tools not configured" {
  run $has foobar

  [ "$status" -eq 1 ]
  [ "$(echo "${output}" | grep ${fancyx} | grep "foobar not understood")" ]
}

@test "env var 'HAS_ALLOW_UNSAFE' overrides safety check" {
  HAS_ALLOW_UNSAFE=y run $has foobar

  [ "$status" -eq 1 ]
  [ "$(echo "${output}" | grep ${fancyx} | grep "foobar")" ]
}

@test "status code reflects number of failed commands" {
  HAS_ALLOW_UNSAFE=y run $has foobar git barbaz

  [ "$status" -eq 2 ]
  [ "$(echo "${output}" | grep ${fancyx} | grep "foobar")" ]
  [ "$(echo "${output}" | grep ${fancyx} | grep "barbaz")" ]
}

@test "status code reflects number of failed commands up to 126" {
  run $has $(for i in {1..256}; do echo foo; done)

  [ "$status" -eq 126 ]
}

@test "loads commands from .hasrc file and excludes comments" {
  printf "bash\n#comment\nmake\n" >> .hasrc

  run $has

  [ "$status" -eq 0 ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]
}

@test "loads commands from .hasrc file and honors CLI args as well" {
  printf "bash\nmake\ngit" >> .hasrc
  run $has git jq

  [ "$status" -eq 0 ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "git")"  ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "jq")"   ]
}

@test "testing PASS output with unicode" {
  run $has git

  [ "$status" -eq 0 ]
  [[ "printf '%b\n' ${lines[0]}" =~ '✓' ]]
}

@test "testing FAIL output with unicode" {
  run $has foobar

  [ "$status" -eq 1 ]
  [[ "printf '%b\n' ${lines[0]}" =~ '✗' ]]
}

@test "fail count 3: testing output with and without unicode" {
  run $has git foobar barbaz barfoo

  [ "$status" -eq 3 ]
  [[ "printf '%b\n' ${lines[0]}" =~ "${checkmark}" ]]
  [[ "printf '%b\n' ${lines[2]}" =~ '✗' ]]
}

@test "testing archiving commands" {
  run $has tar unzip gzip zip

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "tar")" ]
  [ "$(echo "${lines[1]}" | grep "unzip")" ]
  [ "$(echo "${lines[2]}" | grep "gzip")" ]
  [ "$(echo "${lines[3]}" | grep "zip")" ]
}

@test "testing coreutils commands" {
  run $has coreutils sed awk grep sudo file linuxutils

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "gnu_coreutils")" ]
  [ "$(echo "${lines[5]}" | grep "file")" ]
  [ "$(echo "${lines[6]}" | grep "gnu_coreutils")" ]
}

@test "testing hub version is different to git version" {
  if ! command -v hub; then
    skip "'hub' command not found. Installation command can be found at the bottom of ./tests/containers/debian.Dockerfile"
  fi
  run $has hub git

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "hub")" ]
  [ "$(echo "${lines[1]}" | grep "git")" ]
  [ ! "${lines[0]##*\ }" = "${lines[1]##*\ }" ]
}

@test "quiet mode" {
  run $has -q git

  [ "$status" -eq 0 ]
  [ -z "${output}" ]
}

@test "quiet mode should print usage when no commands or .hasrc file" {
  run $has -q

  [ "$status" -eq 0 ]
  __assert_usage
}

@test "status code in quiet mode still equal to number of failed commands" {
  HAS_ALLOW_UNSAFE=y run $has -q foobar bc git barbaz

  [ "$status" -eq 2 ]
  [ -z "${output}" ]
}

@test "'has' prints version with --version" {
  run $has --version
  [ "$status" -eq 0 ]
  [[ "${output}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]
}

@test "'has' prints version with -v" {
  run $has -v
  [ "$status" -eq 0 ]
  [[ "${output}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]
}

@test "'has' prints help with --help" {
  run $has --help
  [ "$status" -eq 0 ]
  __assert_usage
}

@test "'has' prints help with -h" {
  run $has -h
  [ "$status" -eq 0 ]
  __assert_usage
}


__assert_usage() {
    [ "${lines[0]}" = 'Usage: has [OPTION] <command-names>...' ]
    [ "${lines[1]}" = 'Has checks the presence of various command line tools on the PATH and reports their installed version.' ]
    [ "${lines[2]}" = 'Options:' ]
    [ "${lines[3]}" = '        -q              Silent mode' ]
    [ "${lines[4]}" = '        -h, --help      Display this help text and quit' ]
    [ "${lines[5]}" = '        -v, --version   Show version number and quit' ]
    [ "${lines[6]}" = 'Examples: has git curl node' ]
}
