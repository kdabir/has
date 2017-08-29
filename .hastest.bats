#!/usr/bin/env bats

@test "works with single command check" {
  run bash has git

  [ "$status" -eq 0 ]
  [[ $output == *"✔ git"* ]]
}

@test "safely tells about tools not configured" {
  run bash has foobar

  [ "$status" -eq 1 ]
  [[ $output == *"✘ foobar not understood"* ]]
}

@test "env var lets override safety check" {
  HAS_ALLOW_UNSAFE=y run bash has foobar

  [ "$status" -eq 1 ]
  [[ $output == *"✘ foobar"* ]]
}

@test "status code reflects number of failed commands" {
  HAS_ALLOW_UNSAFE=y run bash has foobar make git barbaz

  [ "$status" -eq 2 ]
  [[ $output == *"✘ foobar"* ]]
  [[ $output == *"✘ barbaz"* ]]
}
