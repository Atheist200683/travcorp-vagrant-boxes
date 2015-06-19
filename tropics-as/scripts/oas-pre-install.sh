#!/bin/sh

#See https://support.oracle.com/epmos/faces/SearchDocDisplay?_adf.ctrl-state=6k1kbutw3_426&_afrLoop=456603840459010 for OAS EL5.X installation requirements.
#See http://docs.oracle.com/cd/B14099_19/lop.1012/install.1012/install/silent.htm for silent installation documentation.

BLUE='\033[1;34m'

echo -e "${BLUE}Downloading and installing the required RPM packages as per Oracle support note 564174.1."
sudo yum -y --quiet --nogpgcheck install binutils
sudo yum -y --quiet --nogpgcheck install gcc
sudo yum -y --quiet --nogpgcheck install gcc-c++
#sudo yum -y --quiet --nogpgcheck install glibc-devel
#sudo yum -y --quiet --nogpgcheck install libgcc
#sudo yum -y --quiet --nogpgcheck install libstdc++-devel
#sudo yum -y --quiet --nogpgcheck install libstdc++
#sudo yum -y --quiet --nogpgcheck install make
sudo yum -y --quiet --nogpgcheck install compat-db
sudo yum -y --quiet --nogpgcheck install libXp
sudo yum -y --quiet --nogpgcheck install /vagrant-software/oas-10g/rpms/openmotif21-2.1.30-11.EL5.i386.rpm
#sudo yum -y --quiet --nogpgcheck install /vagrant-software/oas-10g/rpms/xorg-x11-libs-compat-6.8.2-1.EL.33.0.1.i386.rpm

echo -e "${BLUE}Replacing the libdb.so.2 library in /usr/lib as per Oracle patch 6078836."
sudo cp /vagrant-software/oas-10g/libraries/libdb.so.2 /usr/lib/libdb.so.2

echo -e "${BLUE}Replacing the libXtst.so.6 library in /usr/lib as per Oracle support note 564174.1." - NEEDS TO BE RUN AS ROOT
sudo -i
sudo mv /usr/lib/libXtst.so.6 /usr/lib/libXtst.so.6.install
sudo ln -s /usr/X11R6/lib/libXtst.so.6 /usr/lib/libXtst.so.6
exit

echo -e "${BLUE}Installing oracle-validated RPM package."
sudo yum -y --quiet --nogpgcheck install oracle-validated

echo -e "${BLUE}Changing the oracle user password to \"oracle\"."
sudo passwd oracle > /dev/null 2>&1 <<EOF
oracle
oracle
EOF

echo -e "${BLUE}Creating the /apps directory and assinging ownership to oracle:oinstall."
sudo mkdir -p /apps
sudo chown -R oracle:oinstall /apps

echo -e "${BLUE}Creating /etc/oraInst.loc file for silent installation."
sudo echo "inventory_loc=/apps/oraInventory" >> /etc/oraInst.loc

echo -e "${BLUE}Creating /etc/oratab file for silent installation."
sudo touch /etc/oratab

exit $?