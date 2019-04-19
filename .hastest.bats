#!/usr/bin/env bats

INSTALL_DIR=
BATS_TMPDIR=${BATS_TMPDIR:-/tmp}
fancyx='✗'
checkmark='✓'

## We need to create a new directory so that .hasrc file in the root does not get read by the `has` instance under test
setup() {
  export BATS_TEST_TMPDIR="$BATS_TMPDIR/tmp-for-test"
  mkdir -p "$BATS_TEST_TMPDIR"
  cp -f has "$BATS_TEST_TMPDIR"
  cd "$BATS_TEST_TMPDIR"
}

teardown() {
  if [[ -n "$BATS_TEST_TMPDIR" ]]; then
    rm -rf "$BATS_TEST_TMPDIR"
  fi
}

@test "make install creates a valid installation" {
  INSTALL_DIR="${BATS_TEST_TMPDIR}/.local"
  cd "${BATS_TEST_DIRNAME}"
  run make PREFIX="${INSTALL_DIR}" install
  [ "$status" -eq 0 ]
  [ -x "${INSTALL_DIR}/bin/has" ]

  # has reads .hasrc from $PWD, so change anywhere else.
  cd "${INSTALL_DIR}"
  run "${INSTALL_DIR}/bin/has"
  [ "$status" -eq 0 ]
  [ "${lines[0]%% *}" == 'has' ]
  [ "${lines[1]%%:*}" == 'USAGE' ]
  rm -rf ${INSTALL_DIR}
}

@test "..even if 'has' is missing from directory" {
  INSTALL_DIR="${BATS_TEST_TMPDIR}/system_local"
  cd "${BATS_TEST_DIRNAME}"
  mv has has-been
  run make PREFIX="${INSTALL_DIR}" install
  [ "$status" -eq 0 ]
  [ -x "${INSTALL_DIR}/bin/has" ]
  cd "${BATS_TEST_DIRNAME}"
  mv has-been has
  rm -rf ${INSTALL_DIR}
}

@test "make update runs git fetch" {
  cd "${BATS_TEST_DIRNAME}"
  run make update

  [[ "$status" -eq 0 ]]
  [[ "${lines[@]}" =~ "git fetch --verbose" ]]
}

@test "has prints help" {
  run bash has

  [[ "$(echo "${output}" | grep "has")" ]]
  [[ "$(echo "${output}" | grep "USAGE:")" ]]
  [[ "$(echo "${output}" | grep "EXAMPLE:")" ]]
}

@test "works with single command check" {
  run bash has git

  [[ "$status" -eq 0 ]]
  [[ "$(echo "${output}" | grep ${checkmark} | grep "git")" ]]
}

@test "safely tells about tools not configured" {
  run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(echo "${output}" | grep ${fancyx} | grep "foobar not understood")" ]]
}

@test "env var lets override safety check" {
  HAS_ALLOW_UNSAFE=y run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(echo "${output}" | grep ${fancyx} | grep "foobar")" ]]
}

@test "status code reflects number of failed commands" {
  HAS_ALLOW_UNSAFE=y run bash has foobar bc git barbaz

  [[ "$status" -eq 2 ]]
  [[ "$(echo "${output}" | grep ${fancyx} | grep "foobar")" ]]
  [[ "$(echo "${output}" | grep ${fancyx} | grep "barbaz")" ]]
}

@test "status code reflects number of failed commands upto 126" {
  run bash has $(for i in {1..256}; do echo foo; done)

  [[ "$status" -eq 126 ]]
}

@test "loads commands from .hasrc file and excludes comments" {
  printf "bash\n#comment\nmake\n" >> .hasrc

  run bash has

  [[ "$status" -eq 0 ]]

  [[ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]]
  [[ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]]
}

@test "loads commands from .hasrc file and honors CLI args as well" {
  printf "bash\nmake\ngit" >> .hasrc
  HAS_ALLOW_UNSAFE=y run bash has git bc

  [[ "$status" -eq 0 ]]

  [[ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]]
  [[ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]]
  [[ "$(echo "${output}" | grep ${checkmark} | grep "git")" ]]
  [[ "$(echo "${output}" | grep ${checkmark} | grep "bc")" ]]
}

@test "testing PASS output with unicode" {
  run bash has git

  [[ "$status" -eq 0 ]]
  [[ "printf '%b\n' ${lines[0]}" =~ '✓' ]]
}

@test "testing FAIL output with unicode" {
  run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "printf '%b\n' ${lines[0]}" =~ '✗' ]]
}

@test "fail count 3: testing output with and without unicode" {
  run bash has git foobar barbaz barfoo

  [[ "$status" -eq 3 ]]
  [[ "printf '%b\n' ${lines[0]}" =~ "${checkmark}" ]]
  [[ "printf '%b\n' ${lines[2]}" =~ '✗' ]]
}

