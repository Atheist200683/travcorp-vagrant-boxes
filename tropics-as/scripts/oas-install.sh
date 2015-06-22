#!/bin/sh

set -x

DISPLAY="$(netstat -rn | grep 'UG' | awk '{print $2}'):0.0"; export DISPLAY

/vagrant-software/oas-10g/disk1/runInstaller -ignoreSysPreReqs

set +x

exit $?