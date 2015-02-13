command_name="mongodb"
output=$(mongod --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*.\d*" | head -1)

_dq_report "$command_name" $status "$version"
