#!/bin/bash -eu

su - oracle -c "

echo -e \"#################################\"
echo -e \"### Starting new database...  ###\"
echo -e \"#################################\"
echo -e \" \"

sqlplus -s \"/ as sysdba\" <<EOF
		host lsnrctl start
		startup;
		exit
EOF

echo -e \" \"
echo -e \"#######################################\"
echo -e \"### Database provisioned and ready! ###\"
echo -e \"#######################################\""