output=$(groovy --version)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*\.\d*" | head -1)

_dq_report 'groovy' $status "$version"
