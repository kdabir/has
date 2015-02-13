command_name="mongo-client"
output=$(mongo --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*.\d*" | head -1)

_dq_report "$command_name" $status "$version"
