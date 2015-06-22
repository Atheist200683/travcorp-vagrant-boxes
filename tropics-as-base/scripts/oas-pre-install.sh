#!/bin/sh

set -x

#See https://support.oracle.com/epmos/faces/SearchDocDisplay?_adf.ctrl-state=6k1kbutw3_426&_afrLoop=456603840459010 for OAS EL5.X installation requirements.
#See http://docs.oracle.com/cd/B14099_19/lop.1012/install.1012/install/silent.htm for silent installation documentation.

BLUE='\033[1;34m'

echo -e "${BLUE}Downloading and installing the required RPM packages as per Oracle support note 564174.1."
sudo yum -y --nogpgcheck install binutils
sudo yum -y --nogpgcheck install gcc
sudo yum -y --nogpgcheck install gcc-c++
sudo yum -y --nogpgcheck install compat-db
sudo yum -y --nogpgcheck install libXp
sudo yum -y --nogpgcheck install /vagrant-software/oas-10g/rpms/openmotif21-2.1.30-11.EL5.i386.rpm
sudo yum -y --nogpgcheck install /vagrant-software/oas-10g/rpms/xorg-x11-libs-compat-6.8.2-1.EL.33.0.1.i386.rpm

echo -e "${BLUE}Replacing the libdb.so.2 library in /usr/lib as per Oracle patch 6078836."
sudo cp /vagrant-software/oas-10g/libraries/libdb.so.2 /usr/lib/libdb.so.2

echo -e "${BLUE}Replacing the libXtst.so.6 library in /usr/lib as per Oracle support note 564174.1."
sudo ln -sf /usr/X11R6/lib/libXtst.so.6 /usr/lib/libXtst.so.6

echo -e "${BLUE}Installing oracle-validated RPM package."
sudo yum -y --nogpgcheck install oracle-validated

echo -e "${BLUE}Changing the oracle user password to \"oracle\"."
sudo passwd oracle > /dev/null 2>&1 <<EOF
oracle
oracle
EOF

echo -e "${BLUE}Creating the /apps directory and assinging ownership to oracle:oinstall."
sudo mkdir -p /apps
sudo chown -R oracle:oinstall /apps

echo -e "${BLUE}Adding the required environment variables to the oracle user .bash_profile file."
echo "####Oracle specific environment variables added by Vagrant DO NOT MODIFY THESE!#####" >> /home/oracle/.bash_profile
echo "TMP=/tmp; export TMP" >> /home/oracle/.bash_profile
echo "TMPDIR=\$TMP; export TMPDIR" >> /home/oracle/.bash_profile
echo "ORACLE_BASE=/apps/oracle; export ORACLE_BASE" >> /home/oracle/.bash_profile
echo "ORACLE_HOME=\$ORACLE_BASE/product/10.2.0/as_1; export ORACLE_HOME" >> /home/oracle/.bash_profile
echo "ORACLE_TERM=xterm; export ORACLE_TERM" >> /home/oracle/.bash_profile
echo "PATH=/usr/sbin:\$ORACLE_HOME/bin:\$PATH; export PATH" >> /home/oracle/.bash_profile
echo "PATH=\$PATH:\$ORACLE_HOME/dcm/bin; export PATH" >> /home/oracle/.bash_profile
echo "PATH=\$PATH:\$ORACLE_HOME/opmn/bin; export PATH" >> /home/oracle/.bash_profile
echo "PATH=\$PATH:\$ORACLE_HOME/Apache/Apache/bin; export PATH" >> /home/oracle/.bash_profile

set +x

exit $?