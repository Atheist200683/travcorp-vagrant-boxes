#!/bin/sh

set -x

linux32 bash /vagrant/oas-install-files/Disk1/runInstaller -ignoreSysPreReqs -record -destinationFile /vagrant/oas-install-files/oas-install-response-file

set +x