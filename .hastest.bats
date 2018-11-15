#!/usr/bin/env bats

@test "works with single command check" {
  run bash has git

  [[ "$status" -eq 0 ]]
  [[ "$(echo "${output}" | grep "✔" | grep "git")" ]]
}

@test "safely tells about tools not configured" {
  run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(echo "${output}" | grep "✘" | grep "foobar not understood")" ]]
}

@test "env var lets override safety check" {
  HAS_ALLOW_UNSAFE=y run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(echo "${output}" | grep "✘" | grep "foobar")" ]]
}

@test "status code reflects number of failed commands" {
  HAS_ALLOW_UNSAFE=y run bash has foobar bc git barbaz

  [[ "$status" -eq 2 ]]
  [[ "$(echo "${output}" | grep "✘" | grep "foobar")" ]]
  [[ "$(echo "${output}" | grep "✘" | grep "barbaz")" ]]
}
