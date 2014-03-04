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

mongo --version > /dev/null 2>&1
_dq_report 'mongo client' $?

mongod --version > /dev/null 2>&1
_dq_report 'mongo server' $?

mysql --version > /dev/null 2>&1
_dq_report 'mysql client' $?

psql --version > /dev/null 2>&1
_dq_report 'postgres client' $?

echo Your dq is $OK / $(($OK+$KO))

exit $KO
