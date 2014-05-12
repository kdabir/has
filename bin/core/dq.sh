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

curl --version > /dev/null 2>&1
_dq_report 'curl' $?

git --version > /dev/null 2>&1
_dq_report 'git' $?

java -version > /dev/null 2>&1
_dq_report 'java' $?

node --version > /dev/null 2>&1
_dq_report 'node' $?

perl -v > /dev/null  2>&1
_dq_report 'perl' $?

python --version > /dev/null 2>&1
_dq_report 'python' $?
ruby -v > /dev/null 2>&1
_dq_report 'ruby' $?

vi --version > /dev/null 2>&1
_dq_report 'vi' $?
echo; echo Your dq is $OK / $(($OK+$KO))

exit $KO
