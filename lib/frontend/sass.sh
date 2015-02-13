command_name="sass"
output=$(sass --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*.\d*")

_dq_report "$command_name" $status "$version"
