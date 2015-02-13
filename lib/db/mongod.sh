command_name="mongodb"
output=$(mongod --version 2>&1)
status=$?
version=$(echo "$output" | egrep -o "$SIMPLE_VERSIONING" | head -1)

_dq_report "$command_name" $status "$version"
