OK=0
KO=0

_dq_report () {
	if [ "$2" -eq 0 ]; then
	 	echo "✔ $1"
		OK=$(($OK+1))
	else
		echo "✘ $1"
	    KO=$(($KO+1))
	fi
}

ant -version > /dev/null 2>&1
_dq_report 'ant' $?
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

vi --version > /dev/null 2>&1
_dq_report 'vi' $?
yo --version > /dev/null 2>&1
_dq_report 'yoeman' $?

echo Your dq is $OK / $(($OK+$KO))

exit $KO
