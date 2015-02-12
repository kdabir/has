output=$(java -version 2>&1)
status=$?
version=$(echo "$output" | grep -o "\d*\.\d*\.\d*" | head -1)

_dq_report 'java' $status "$version"
