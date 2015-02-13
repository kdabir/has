command_name="node"
output=$(node --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*.\d*")

_dq_report "$command_name" $status "$version"
