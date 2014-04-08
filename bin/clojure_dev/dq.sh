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

## surprisingly no option for version that i could find of
clj --help > /dev/null 2>&1
_dq_report 'clojure' $?
emacs --version > /dev/null 2>&1
_dq_report 'emacs' $?
java -version > /dev/null 2>&1
_dq_report 'java' $?

lein -v > /dev/null 2>&1
_dq_report 'leiningen' $?
echo Your dq is $OK / $(($OK+$KO))

exit $KO
