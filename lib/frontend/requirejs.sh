command_name="requirejs"
output=$(r.js -v 2>&1)
status=$?
version=$(echo "$output" | egrep -o "$SIMPLE_VERSIONING" | head -1)

_dq_report "$command_name" $status "$version"
