output=$(java -version 2>&1)
status=$?
version=$(echo "$output" | egrep -o "$SIMPLE_VERSIONING" | head -1)

_dq_report 'java' $status "$version"
