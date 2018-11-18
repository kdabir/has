#!/usr/bin/env bash

## source: https://github.com/kdabir/has

## Important so that version is not extracted for failed commands (not found)
set -o pipefail

## constant - symbols for success failure
PASS="\e[1m\e[38;5;2m✔\e[m"
FAIL="\e[1m\e[38;5;1m✘\e[m"

## These variables are used to keep track of passed and failed commands
OK=0
KO=0

## Regex to extract simple version - extracts numeric sem-ver style versions
REGEX_SIMPLE_VERSION="([[:digit:]]+\.?){2,3}"

## RC file can contain commands to be tested
RC_FILE=".hasrc"


# try to extract version by executing $1 with $2 arg
__dynamic_detect(){
  cmd=$1
  params=$2
  version=$(eval ${cmd} ${params} "2>&1" | egrep -o "$REGEX_SIMPLE_VERSION" | head -1)
  status=$?
}

# commands that use `--version` flag
__dynamic_detect--version(){
  __dynamic_detect $1 "--version"
}

# commands that use `-version` flag
__dynamic_detect-version(){
  __dynamic_detect $1 "-version"
}

# commands that use `-v` flag
__dynamic_detect-v(){
  __dynamic_detect $1 "-v"
}

# commands that use `version` argument
__dynamic_detect-arg_version(){
  __dynamic_detect $1 "version"
}


## the main function
__detect(){
  name=$1

  # setup aliases maps commonly used name to exact command name
  case ${name} in
    golang) command="go" ;;
    jre) command="java" ;;
    jdk) command="javac" ;;
    nodejs) command="node" ;;
    goreplay) command="gor";;
    httpie) command="http";;
    homebrew) command="brew";;
    awsebcli) command="eb";;
    awscli) command="aws";;
    *)      command=${name} ;;
  esac

  case ${command} in

    # commands that need --version flag
    bash|zsh)               __dynamic_detect--version ${command} ;;
    git|hg|svn|bzr)         __dynamic_detect--version ${command} ;;
    gcc|make)               __dynamic_detect--version ${command} ;;
    curl|wget|http)         __dynamic_detect--version ${command} ;;
    vim|emacs|nano|subl)    __dynamic_detect--version ${command} ;;
    bats|tree|ack|autojump) __dynamic_detect--version ${command} ;;
    jq|ag|brew)             __dynamic_detect--version ${command} ;;
    
    R)                      __dynamic_detect--version ${command} ;;
    node|npm|yarn)          __dynamic_detect--version ${command} ;;
    grunt|brunch)           __dynamic_detect--version ${command} ;;
    ruby|gem|rake|bundle)   __dynamic_detect--version ${command} ;;
    python|python3)         __dynamic_detect--version ${command} ;;
    perl|perl6|php|php5)    __dynamic_detect--version ${command} ;;
    groovy|gradle|mvn)      __dynamic_detect--version ${command} ;;
    lein)                   __dynamic_detect--version ${command} ;;
    aws|eb|sls|gcloud)      __dynamic_detect--version ${command} ;;


    # commands that need -version flag
    ant|java|javac)         __dynamic_detect-version ${command} ;;
    scala|kotlin)           __dynamic_detect-version ${command} ;;

    # commands that need version arg
    hugo)                   __dynamic_detect-arg_version ${command} ;;

    ## Example of commands that need custom processing
    ## go needs version arg
    go)
      version=$(go version 2>&1| egrep -o "$REGEX_SIMPLE_VERSION" | head -1)
      status=$?
      ;;

    ## TODO cleanup, currently need to add extra space in regex, otherwise the time gets selected
    gulp)
      version=$(gulp --version 2>&1| egrep -o " $REGEX_SIMPLE_VERSION" | head -1)
      status=$?
      ;;

    ## ab uses -V flag
    ab)
      version=$(ab -V 2>&1 | egrep -o "$REGEX_SIMPLE_VERSION" | head -1)
      status=$?
      ;;

    ## gor returns version but does not return normal status code, hence needs custom processing
    gor)
      version=$(gor version 2>&1 | egrep -o "$REGEX_SIMPLE_VERSION" | head -1)
      if [ $? -eq 1 ]; then status=0; else status=1; fi
      ;;

    sbt)
        version=$(sbt about 2>&1 | egrep -o "([[:digit:]]{1,4}\.){2}[[:digit:]]{1,4}" | head -1)
        status=$?
      ;;

    has)
      version=$(has 2>&1 | egrep -o "$REGEX_SIMPLE_VERSION" | head -1)
      status=$?
      ;;

    *)
      ## Can allow dynamic checking here, i.e. checking commands that are not listed above
      if [[ "${HAS_ALLOW_UNSAFE}" == "y" ]]; then
        __dynamic_detect--version ${command}
        ## fallback checking based on status!=127 (127 means command not found)
        ## TODO can check other type of supported version-checks if status was not 127
      else
        ## -1 is special way to tell command is not supported/whitelisted by `has`
        status="-1"
      fi
      ;;
  esac


  if [ "$status" -eq "-1" ]; then     ## When unsafe processing is not allowed, the -1 signifies
    printf "${FAIL} ${command} not understood\n"
    KO=$(($KO+1))

  elif [ ${status} -eq 127 ]; then    ## command not installed
    printf "${FAIL} ${command}\n"
    KO=$(($KO+1))

  elif [ ${status} -eq 0 ] || [ ${status} -eq 141 ]; then      ## successfully executed
    printf "${PASS} ${command} \e[1m\e[33;5;2m${version}\e[m\n"
    OK=$(($OK+1))

  else  ## as long as its not 127, command is there, but we might not have been able to extract version
    printf "${PASS} ${command}\n"
    OK=$(($OK+1))
  fi

}



if [ -s "${RC_FILE}" ];  then
  HASRC="true"
fi

# if HASRC is not set AND no arguments passed to script
if [[ -z "${HASRC}" ]] && [ "$#" -eq 0 ]; then
  # print help
  BINARY_NAME="has"
  VERSION="v1.4.0"
  printf "${BINARY_NAME} ${VERSION}\n"
  printf "USAGE:    ${BINARY_NAME} <command-names>..\n"
  printf "EXAMPLE:  ${BINARY_NAME} git curl node\n\n"

else
  # for each cli-arg
  for cmd in "$@"; do
      __detect "$cmd"
  done

  ## display found / total
  #  echo  ${OK} / $(($OK+$KO))

  ## if HASRC has been set
  if [[ -n "${HASRC}" ]]; then
    ## for all
    for line in $(cat "${RC_FILE}" | egrep -v "^\s*(#|$)" ); do
      __detect "$line"
    done
  fi

  ## max status code that can be returned
  MAX_STATUS_CODE=126

  if [[ "$KO" -gt "${MAX_STATUS_CODE}" ]]; then
    exit "${MAX_STATUS_CODE}"
  else
    exit "${KO}"
  fi

fi
