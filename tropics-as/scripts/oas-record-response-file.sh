#!/bin/sh

set -x

/vagrant-software/oas-10g/disk1/runInstaller -ignoreSysPreReqs -record -destinationFile /vagrant/oas-install-response-file/oas-install-response.file

set +x