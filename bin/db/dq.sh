OK=0
KO=0

PASS='✔'
FAIL='✘'

if [[ $TERM == xterm-*color ]]; then
  PASS="\E[32m$PASS\E[0m"
  FAIL="\E[31m$FAIL\E[0m"
fi

_dq_report () {
  if [ "$2" -eq 0 ]; then
    echo -e "$PASS $1"
    OK=$(($OK+1))
  else
    echo -e "$FAIL $1"
    KO=$(($KO+1))
  fi
}

mongo --version > /dev/null 2>&1
_dq_report 'mongo client' $?

mongod --version > /dev/null 2>&1
_dq_report 'mongo server' $?

mysql --version > /dev/null 2>&1
_dq_report 'mysql client' $?

psql --version > /dev/null 2>&1
_dq_report 'postgres client' $?

echo; echo Your dq is $OK / $(($OK+$KO))

exit $KO
