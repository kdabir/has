OK=0
KO=0

PASS='✔'
FAIL='✘'

# by default show installed versions
NO_VERSION=1
if [[ "$1" == "--no-version" ]]; then
  NO_VERSION=0
fi

if [[ $TERM == xterm-*color ]]; then
  PASS="\E[32m$PASS\E[0m"
  FAIL="\E[31m$FAIL\E[0m"
fi

# $1 command name
# $2 0 OK, anything else KO
# $3 optional version string, should send in quotes
_dq_report () {
  if [ "$2" -eq 0 ]; then
    if [ "$NO_VERSION" -eq 0 ]; then
      printf "$PASS $1\n"
    else
      printf "$PASS %-30s %s\n"  $1 $3
    fi
    OK=$(($OK+1))
  else
    printf "$FAIL $1\n"
    KO=$(($KO+1))
  fi
}
