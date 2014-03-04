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

java -version > /dev/null 2>&1
_dq_report 'java' $?

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

echo Your dq is $OK / $(($OK+$KO))

exit $KO
