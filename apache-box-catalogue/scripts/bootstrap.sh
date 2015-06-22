#!/bin/sh

set -x

BLUE='\033[1;34m'

echo -e "${BLUE}Downloading and installing the Oracle Linux Yum repository file."
sudo wget -q http://public-yum.oracle.com/public-yum-el5.repo -O /etc/yum.repos.d/public-yum-el5.repo

echo -e "${BLUE}Installing Apache."
sudo yum install -y --nogpgcheck httpd

exit $?

set +x