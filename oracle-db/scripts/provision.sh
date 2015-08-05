#!/bin/bash -eu

su - oracle -c "

HOST_SSH_DIR=\"/vagrant/ssh\"
GUEST_SSH_DIR=\"/home/oracle/.ssh\"
SOURCE_USER_HOST=\"vagrant@lonrmstdb01.corp.ttc\"
SOURCE_DATA_DIR=\"/apps/vagrant/dbf-files\"
LOCAL_DATA_DIR=\"/apps/oradata\"
SOURCE_DATA_SET=\"$1\"

echo -e \"########################\"
echo -e \"### Provisioning SSH ###\"
echo -e \"########################\"
rm -rf \${GUEST_SSH_DIR}
mkdir \${GUEST_SSH_DIR}
cp \${HOST_SSH_DIR}/* \${GUEST_SSH_DIR}
chmod 700 \${GUEST_SSH_DIR}
chmod 644 \${GUEST_SSH_DIR}/id_rsa.pub \${GUEST_SSH_DIR}/known_hosts
chmod 600 \${GUEST_SSH_DIR}/id_rsa

echo -e \" \"
echo -e \"#################################################\"
echo -e \"### Checking source database file consistency ###\"
echo -e \"#################################################\"
if ssh \${SOURCE_USER_HOST} \"test -e \${SOURCE_DATA_DIR}/\${SOURCE_DATA_SET}/\${SOURCE_DATA_SET}.lock\"; then
	echo -e \" \"
	echo -e \"#######################################\"
	echo -e \"###Source database currently invalid###\"
	echo -e \"#######################################\"
	echo -e \" \"
	exit 1
fi

echo -e \" \"
echo -e \"#################################################\"
echo -e \"### Terminating existing database if required ###\"
echo -e \"#################################################\"
echo -e \" \"
lsnrctl stop
sqlplus -s \"/ as sysdba\" <<EOF
		shutdown abort;
EOF
rm -f \${LOCAL_DATA_DIR}/\${ORACLE_SID}/*
rm -f /apps/oracle/fast_recovery_area/\${ORACLE_SID}/*.ctl

echo -e \" \"
echo -e \"##################################\"
echo -e \"### Copying new database files ###\"
echo -e \"##################################\"
echo -e \" \"
rsync --ignore-times --progress \${SOURCE_USER_HOST}:\${SOURCE_DATA_DIR}/\${SOURCE_DATA_SET}/* \${LOCAL_DATA_DIR}/\${ORACLE_SID}

echo -e \" \"
echo -e \"#################################\"
echo -e \"### Provisioning new database ###\"
echo -e \"#################################\"
echo -e \" \"
DATAFILES=\$(for i in  \$(ls -w 1 -b \${LOCAL_DATA_DIR}/\${ORACLE_SID}/*.dbf) ; do echo \,\'"\${i}"\'\\\r ; done);
DATAFILES=\${DATAFILES:1:\${#DATAFILES}-3};
CF_BEGIN=\"STARTUP NOMOUNT\r
CREATE CONTROLFILE set DATABASE \${ORACLE_SID} RESETLOGS  NOARCHIVELOG\r
MAXLOGFILES 2\r
MAXLOGMEMBERS 2\r
MAXDATAFILES 20\r
MAXINSTANCES 1\r
LOGFILE\r
GROUP 1 '\${LOCAL_DATA_DIR}/\${ORACLE_SID}/redo01.log'  SIZE 100M,\r
GROUP 2 '\${LOCAL_DATA_DIR}/\${ORACLE_SID}/redo02.log'  SIZE 100M\r
DATAFILE\"
CF_END=\"CHARACTER SET WE8ISO8859P1;\"
SQL_CMD=\"\${CF_BEGIN}\n\${DATAFILES}\n\${CF_END}\"
echo -e \"\$SQL_CMD\" > \"\${LOCAL_DATA_DIR}/\${ORACLE_SID}/control_file.sql\"
sqlplus -s \"/ as sysdba\" <<EOF
		@\${LOCAL_DATA_DIR}/\${ORACLE_SID}/control_file.sql
		alter database open resetlogs;
		shutdown immediate;
		startup mount;
		alter database open;
		alter tablespace temp add tempfile '\${LOCAL_DATA_DIR}/\${ORACLE_SID}/temp01.dbf' size 100m reuse autoextend on next 50m maxsize 1g;
		shutdown immediate;
		host lsnrctl start
		startup;
		exit
EOF
echo -e \" \"
echo -e \"#######################################\"
echo -e \"### Database provisioned and ready! ###\"
echo -e \"#######################################\""