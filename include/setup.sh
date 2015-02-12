OK=0
KO=0

PASS='✔'
FAIL='✘'

if [[ $TERM == xterm-*color ]]; then
  PASS="\E[32m$PASS\E[0m"
  FAIL="\E[31m$FAIL\E[0m"
fi

# $1 command name
# $2 0 ok anything else
# $3 version
_dq_report () {
  if [ "$2" -eq 0 ]; then
    echo -e "$PASS $1 $3"
    OK=$(($OK+1))
  else
    echo -e "$FAIL $1"
    KO=$(($KO+1))
  fi
}
