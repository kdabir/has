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

ack --version > /dev/null 2>&1
_dq_report 'ack' $?

ant -version > /dev/null 2>&1
_dq_report 'ant' $?
autojump --version > /dev/null 2>&1
_dq_report 'autojump' $?

bower --version > /dev/null 2>&1
_dq_report 'bower' $?
bundle -v > /dev/null 2>&1
_dq_report 'bundler' $?

## surprisingly no option for version that i could find of
clj --help > /dev/null 2>&1
_dq_report 'clojure' $?
coffee --version > /dev/null 2>&1
_dq_report 'coffee' $?
curl --version > /dev/null 2>&1
_dq_report 'curl' $?

emacs --version > /dev/null 2>&1
_dq_report 'emacs' $?
gem -v > /dev/null 2>&1
_dq_report 'gem' $?

git --version > /dev/null 2>&1
_dq_report 'git' $?

gradle -v > /dev/null 2>&1
_dq_report 'gradle' $?
groovy --version > /dev/null 2>&1
_dq_report 'groovy' $?
groovyc -version > /dev/null 2>&1
_dq_report 'groovyc' $?
grunt --version > /dev/null 2>&1
_dq_report 'grunt' $?
java -version > /dev/null 2>&1
_dq_report 'java' $?

# http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4380614
# jdk
javac -version > /dev/null 2>&1
_dq_report 'javac' $?

lazybones --version > /dev/null 2>&1
_dq_report 'lazybones' $?
lein -v > /dev/null 2>&1
_dq_report 'leiningen' $?
mongo --version > /dev/null 2>&1
_dq_report 'mongo client' $?

mongod --version > /dev/null 2>&1
_dq_report 'mongo server' $?

mvn -v > /dev/null 2>&1
_dq_report 'maven' $?
mysql --version > /dev/null 2>&1
_dq_report 'mysql client' $?

node --version > /dev/null 2>&1
_dq_report 'node' $?

npm --version > /dev/null 2>&1
_dq_report 'npm' $?
perl -v > /dev/null  2>&1
_dq_report 'perl' $?

psql --version > /dev/null 2>&1
_dq_report 'postgres client' $?

python --version > /dev/null 2>&1
_dq_report 'python' $?
rake -V > /dev/null 2>&1
_dq_report 'rake' $?

ruby -v > /dev/null 2>&1
_dq_report 'ruby' $?

rvm -v > /dev/null 2>&1
_dq_report 'rvm' $?

sass --version > /dev/null 2>&1
_dq_report 'sass' $?
# this guy downloads the entire internet before telling its version
sbt sbt-version > /dev/null 2>&1
_dq_report 'sbt' $?

scala -version > /dev/null 2>&1

# this guy has its own idea of exit codes, fix it!
if [ $? -eq 1 ]; then
    STATUS=0
else
    STATUS=1
fi

_dq_report 'scala' $STATUS

scalac -version > /dev/null 2>&1
_dq_report 'scalac' $?

tree --version > /dev/null 2>&1
_dq_report 'tree' $?

vi --version > /dev/null 2>&1
_dq_report 'vi' $?
wget --version > /dev/null 2>&1
_dq_report 'wget' $?

yo --version > /dev/null 2>&1
_dq_report 'yeoman' $?

zsh --version > /dev/null 2>&1
_dq_report 'zsh' $?

echo; echo Your dq is $OK / $(($OK+$KO))

exit $KO
