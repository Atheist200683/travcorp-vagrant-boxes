#!/bin/sh

DISPLAY="$(netstat -rn | grep 'UG' | awk '{print $2}'):0.0"; export DISPLAY
SCRIPT_USAGE="Usage: $0 {record|silent|install}"


record() {
	/vagrant/scripts/oas-record-response-file.sh
}
silent() {
	#/vagrant/scripts/record-response-file.sh
	echo -e "No script for this action!"
}
install() {
	#/vagrant/scripts/record-response-file.sh
	echo -e "No script for this action!"
}

case $1 in

        record)
          record
        ;;

        silent)  
          silent
        ;;

        install)
          install
        ;;

        *)
        echo -e $SCRIPT_USAGE
        ;;
esac

exit $?