command_name="grunt"
output=$(grunt --version 2>&1)
status=$?
version=$(echo "$output" | egrep -o "$SIMPLE_VERSIONING")

_dq_report "$command_name" $status "$version"
