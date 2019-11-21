#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: Provide common logging
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 17/05/19 * Initial Version

colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colrst='\033[0m'    # Text Reset

verbosity=4

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
esilent () { verb_lvl=${silent_lvl} elog "$@" ;}
enotify () { verb_lvl=${ntf_lvl} elog "$@" ;}
eok ()    { verb_lvl=${silent_lvl} elog "${colgrn}SUCCESS${colrst} ---- $@" ;}
ewarn ()  { verb_lvl=${wrn_lvl} elog "${colylw}WARNING${colrst} - $@" ;}
einfo ()  { verb_lvl=${inf_lvl} elog "${colwht}INFO${colrst} ---- $@" ;}
edebug () { verb_lvl=${dbg_lvl} elog "${colgrn}DEBUG${colrst} --- $@" ;}
eerror () { verb_lvl=${err_lvl} elog "${colred}ERROR${colrst} --- $@" ;}
ecrit ()  { verb_lvl=${crt_lvl} elog "${colpur}FATAL${colrst} --- $@" ;}
edumpvar () { for var in $@ ; do edebug "$var=${!var}" ; done }
elog() {
        if [ ${verbosity} -ge ${verb_lvl} ]; then
                datestring=`date +"%Y-%m-%d %H:%M:%S"`
                echo -e "${datestring} - $@"
        fi
}

if [ -z ${log_level} ]
then
      log_level="-V"
fi

echo "The log level is ${log_level}"

case ${log_level} in
    -s)
            verbosity=${silent_lvl}
            edebug "-s specified: Silent mode"
            ;;
    -V)
            verbosity=${inf_lvl}
            edebug "-V specified: Verbose mode"
            ;;
    -G)
            verbosity=${dbg_lvl}
            edebug "-G specified: Debug mode"
            ;;
esac

check_output () {
    if [[ $1 -eq 0 ]]
    then
        eok "Processing completed."
    else
        eerror "Processing encountered a failure. Exiting with status: $1"
        exit $1
    fi
}
