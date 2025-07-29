#!/usr/bin/env bats

## should work on mac and ubuntu
## tests just the core features with minimum set of tools

INSTALL_DIR=
BATS_TMPDIR="${BATS_TMPDIR:-/tmp}"
fancyx='✗'
checkmark='✓'

## We need to create a new directory so that .hasrc file in the root does not get read by the `has` instance under test
setup() {
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
  [ "${lines[0]}" = 'Usage: has [OPTION] <command-names>...' ]
  [ "${lines[1]}" = 'Has checks the presence of various command line tools on the PATH and reports their installed version.' ]
}

@test "git version output is non-empty and debug output is shown" {
  run $has git
  echo "Output: $output"
  [ "$status" -eq 0 ]
  [ "$(echo "${lines[0]}" | grep "git")" ]
  version="${lines[0]##* }"
  [ "${#version}" -ge 2 ]
}

@test "check multiple real tools from .hasrc (make, curl, jq, node)" {
  run $has make curl jq node
  echo "Output: $output"
  [ "$status" -eq 0 ]
  for tool in make curl jq node; do
    line=$(echo "$output" | grep "$tool")
    [ -n "$line" ]
    version="${line##* }"
    [ "${#version}" -ge 1 ]
  done
}

@test "loads commands from .hasrc file and excludes comments (real tools, output debug)" {
  printf "bash\n#comment\nmake\n" > .hasrc
  run $has
  echo "Output: $output"
  [ "$status" -eq 0 ]
  for tool in bash make; do
    line=$(echo "$output" | grep "$tool")
    [ -n "$line" ]
    version="${line##* }"
    [ "${#version}" -ge 1 ]
  done
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


@test "loads commands from .hasrc file and honors CLI args as well" {
  printf "bash\nmake\ngit" >> .hasrc
  run $has git jq

  [ "$status" -eq 0 ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "bash")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "make")" ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "git")"  ]
  [ "$(echo "${output}" | grep ${checkmark} | grep "jq")"   ]
}
