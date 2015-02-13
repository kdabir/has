output=$(python --version 2>&1)
status=$?
version=$(echo "$output" | egrep -o "$SIMPLE_VERSIONING" | head -1)

_dq_report 'python' $status "$version"
