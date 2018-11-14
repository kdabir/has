#!/usr/bin/env bats

@test "works with single command check" {
  run bash has git

  [[ "$status" -eq 0 ]]
  [[ "$(grep "\e\[1m\e\[38;5;2m✔\e\[m git" <<< "${output}")" ]]
}

@test "safely tells about tools not configured" {
  run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(grep "\e\[1m\e\[38;5;1m✘\e\[m foobar not understood" <<< "${output}")" ]]
}

@test "env var lets override safety check" {
  HAS_ALLOW_UNSAFE=y run bash has foobar

  [[ "$status" -eq 1 ]]
  [[ "$(grep "\e\[1m\e\[38;5;1m✘\e\[m foobar" <<< "${output}")" ]]
}

@test "status code reflects number of failed commands" {
  HAS_ALLOW_UNSAFE=y run bash has foobar bc git barbaz

  [[ "$status" -eq 2 ]]
  [[ "$(grep "\e\[1m\e\[38;5;1m✘\e\[m foobar" <<< "${output}")" ]]
  [[ "$(grep "\e\[1m\e\[38;5;1m✘\e\[m barbaz" <<< "${output}")" ]]
}
