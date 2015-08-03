#!/bin/bash

su - oracle -c "
SOURCE_USER_HOST=vagrant@lonrmstdb01.corp.ttc
SOURCE_DATA_DIR=/apps/vagrant/oradata/VAGRANT;
LOCAL_DATA_DIR=/apps/oradata;

if ssh \${SOURCE_USER_HOST} test ~/test.file \> /dev/null 2\>\&1 ; then
	echo -e \"Source database is currently unavailable please try again later, exiting.......\"            
	exit 1
fi
echo -e \"Terminating the current database if one exists...\"
lsnrctl stop > /dev/null 2>&1
sqlplus \"/ as sysdba\" > /dev/null 2\>\&1 <<EOF
		shutdown abort;
EOF
rm -f \${LOCAL_DATA_DIR}/\${ORACLE_SID}/*
rm -f /apps/oracle/fast_recovery_area/\${ORACLE_SID}/*.ctl
echo -e \"Copying a new database from the source server...\"
rsync --archive --ignore-times --exclude \"temp*\" --exclude \"*.log\" --exclude \"*.ctl\" \${SOURCE_USER_HOST}:\${SOURCE_DATA_DIR}/ \${LOCAL_DATA_DIR}/\${ORACLE_SID}
echo -e \"Provisioning new database...\"
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
sqlplus \"/ as sysdba\" > /dev/null 2\>\&1 <<EOF
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
echo -e \"Database provisioned and ready!\""