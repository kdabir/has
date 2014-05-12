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

bundle -v > /dev/null 2>&1
_dq_report 'bundler' $?

gem -v > /dev/null 2>&1
_dq_report 'gem' $?

rake -V > /dev/null 2>&1
_dq_report 'rake' $?

ruby -v > /dev/null 2>&1
_dq_report 'ruby' $?

rvm -v > /dev/null 2>&1
_dq_report 'rvm' $?

echo; echo Your dq is $OK / $(($OK+$KO))

exit $KO
