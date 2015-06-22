#!/bin/sh

set -x

#http://sourceforge.net/projects/xming/ needs to be installed on the host machine so that the Oracle installer can connect to the display value assigned to DISPLAY below.

DISPLAY="$(netstat -rn | grep 'UG' | awk '{print $2}'):0.0"; export DISPLAY

/vagrant-software/oas-10g/disk1/runInstaller -ignoreSysPreReqs

set +x

exit $?