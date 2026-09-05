# Bash completion script for 'has' - https://github.com/kdabir/has
# A simple utility to check the presence of command line tools

_has_completions() {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  # Options for has
  opts="-q -h --help -v --version --color-auto --color-never --color-always"

  # If current word starts with a dash, complete options
  if [[ ${cur} == -* ]]; then
    # shellcheck disable=SC2207,SC2086 # word-splitting is intentional; mapfile needs bash 4+ (unavailable on macOS)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi

  # Otherwise, complete with available commands on the system
  # shellcheck disable=SC2207,SC2086 # word-splitting is intentional; mapfile needs bash 4+ (unavailable on macOS)
  COMPREPLY=( $(compgen -c -- ${cur}) )
  return 0
}

complete -F _has_completions has
