#!/bin/sh

set -x

linux32 bash /vagrant-software/oas-10g/disk1/runInstaller -ignoreSysPreReqs -record -destinationFile /vagrant/oas-install-files/oas-install-response-file

set +x