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
gradle -v > /dev/null 2>&1
_dq_report 'gradle' $?
java -version > /dev/null 2>&1
_dq_report 'java' $?

# http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4380614
# jdk
javac -version > /dev/null 2>&1
_dq_report 'javac' $?

mvn -v > /dev/null 2>&1
_dq_report 'maven' $?
echo Your dq is $OK / $(($OK+$KO))

exit $KO
