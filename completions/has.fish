# Fish completion script for 'has' - https://github.com/kdabir/has
# A simple utility to check the presence of command line tools

# Arguments are commands to check.
complete -c has -fa "(__fish_complete_command)"

complete -c has -l color-auto -d "Enable color output automatically (default)"
complete -c has -l color-always -d "Always enable color output"
complete -c has -l color-never -d "Disable color output"
complete -c has -s q -d "Silent mode"
complete -c has -s h -l help -d "Display this help text and quit"
complete -c has -s v -l version -d "Show version number and quit"
