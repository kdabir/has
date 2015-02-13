command_name="grunt"
output=$(grunt --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*.\d*")

_dq_report "$command_name" $status "$version"
