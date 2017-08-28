#!/usr/bin/env bats

@test "works with single command check" {
    result=$(bash has git)

   [[ $result == *"✔ git"* ]]
}

@test "safely tells about tools not configured" {
    result=$(bash has something-missing)

   [[ $result == *"✘ something-missing not understood"* ]]
}

@test "env lets override safety check" {
    result=$(HAS_ALLOW_UNSAFE=y bash has something-missing)

   [[ $result == *"✘ something-missing"* ]]
}
