#!/usr/bin/env bats

@test "works with single command check" {
  run bash has git

  [ "$status" -eq 0 ]
  [[ $output == *"✔ git"* ]]
}

@test "safely tells about tools not configured" {
  run bash has something-missing

  [ "$status" -eq 1 ]
  [[ $output == *"✘ something-missing not understood"* ]]
}

@test "env var lets override safety check" {
  HAS_ALLOW_UNSAFE=y run bash has something-missing

  [ "$status" -eq 1 ]
  [[ $output == *"✘ something-missing"* ]]
}
