scala -version > /dev/null 2>&1

# this guy has its own idea of exit codes, fix it!
if [ $? -eq 1 ]; then
    STATUS=0
else
    STATUS=1
fi

_dq_report 'scala' $STATUS
