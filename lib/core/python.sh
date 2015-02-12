output=$(python --version 2>&1)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*\.\d*" | head -1)

_dq_report 'python' $status "$version"
