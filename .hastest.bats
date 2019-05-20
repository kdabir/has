#!/usr/bin/env bats

INSTALL_DIR=
BATS_TMPDIR="${BATS_TMPDIR:-/tmp}"
fancyx='✗'
checkmark='✓'
## We need to create a new directory so that .hasrc file in the root does not get read by the `has` instance under test
setup() {
  export HAS_TMPDIR="${BATS_TMPDIR}/tmp-for-test"
  mkdir -p "${HAS_TMPDIR}"
  cp -f "${BATS_TEST_DIRNAME}"/has "${HAS_TMPDIR}"
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
  [ "${lines[0]%% *}" = 'has'     ]
  [ "${lines[1]%%:*}" = 'USAGE'   ]
  [ "${lines[2]}" = 'EXAMPLE: has git curl node' ]
}

@test "make install creates a valid installation" {
  INSTALL_DIR="${HAS_TMPDIR}/.local"
  cd "${BATS_TEST_DIRNAME}"
  run make PREFIX="${INSTALL_DIR}" install
  [ "$status" -eq 0 ]
  [ -x "${INSTALL_DIR}/bin/has" ]

  # has reads .hasrc from $PWD, so change anywhere else.
  cd "${INSTALL_DIR}"
  run "${INSTALL_DIR}/bin/has"
  [ "$status" -eq 0 ]
  [ "${lines[0]%% *}" = 'has'     ]
  [ "${lines[1]%%:*}" = 'USAGE'   ]
  [ "${lines[2]}" = 'EXAMPLE: has git curl node' ]
  # [ "${lines[2]%%:*}" = 'EXAMPLE' ]
}

@test "..even if 'has' is missing from directory" {
  INSTALL_DIR="${HAS_TMPDIR}/system_local"
  cd "${BATS_TEST_DIRNAME}"
  mv has has-been
  run make PREFIX="${INSTALL_DIR}" install
  [ "$status" -eq 0 ]
  [ -x "${INSTALL_DIR}/bin/has" ]
  cd "${BATS_TEST_DIRNAME}"
  mv has-been has
}

@test "make update runs git fetch" {
  cd "${BATS_TEST_DIRNAME}"
  skip "make update overwrites my changes"
  run make update

  [ "$status" -eq 0 ]
  [ "${lines[*]}" =~ "git fetch --verbose" ]
}

@test "works with single command check" {
  run $has git

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "git")" ]
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
  HAS_ALLOW_UNSAFE=y run $has foobar bc git barbaz

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
  HAS_ALLOW_UNSAFE=y run $has git bc

  [ "$status" -eq 0 ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "git")"  ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "bc")"   ]
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
  run $has tar unzip gzip xz unar pv zip

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "tar")" ]
  [ "$(echo "${lines[1]}" | grep "unzip")" ]
  [ "$(echo "${lines[2]}" | grep "gzip")" ]
  [ "$(echo "${lines[3]}" | grep "xz")" ]
  [ "$(echo "${lines[4]}" | grep "unar")" ]
  [ "$(echo "${lines[5]}" | grep "pv")" ]
  [ "$(echo "${lines[6]}" | grep "zip")" ]
}

@test "testing coreutils commands" {
  run $has coreutils sed awk grep sudo file linux-utils

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "gnu_coreutils")" ]
  [ "$(echo "${lines[5]}" | grep "file")" ]
  [ "$(echo "${lines[6]}" | grep "gnu_coreutils")" ]
}

@test "testing hub version is different to git version" {
  run $has hub git

  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "hub")" ]
  [ "$(echo "${lines[1]}" | grep "git")" ]
  [ ! "${lines[0]##*\ }" = "${lines[1]##*\ }" ]
}
