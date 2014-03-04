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

gradle -v > /dev/null 2>&1
_dq_report 'gradle' $?
groovy --version > /dev/null 2>&1
_dq_report 'groovy' $?
groovyc -version > /dev/null 2>&1
_dq_report 'groovyc' $?
java -version > /dev/null 2>&1
_dq_report 'java' $?

lazybones --version > /dev/null 2>&1
_dq_report 'lazybones' $?
echo Your dq is $OK / $(($OK+$KO))

exit $KO
