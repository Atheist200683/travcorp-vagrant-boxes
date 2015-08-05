##oracle-db vagrant box

###tropics-db machine:

1. **Usage:**
  - **create:**	vagrant --version=[dev(default)/qa/patch] up tropics-db
  - **provision:** vagrant --version=[dev(default)/qa/patch] provision tropics-db
  - **halt:** vagrant halt tropics-db
  - **resume:** vagrant resume tropics-db
  - **destroy:** vagrant destroy --force tropics-db
  - **ssh:** vagrant ssh tropics-db
  
2. **Notes:**
  - **--version:**	
  - Specifies the state of the database you want create in your Vagrant box (see the create command above).
  - For example if "patch" is specified it will create a database with the same state as the patch environment.
  -	The default value if this parameter is unspecified is "dev".
  -	You can switch between database states using the vagrant provision command as detailed above.
  -	**This feature will use actual database changset scripts in the near future and change to accept a version number instead of a environment tag.**
  
3. **Basebox (oracle-db) credentials:**
  - vagrant/vagrant (sudoer)
  - oracle/oracle (sudoer) - su to this user to access Oracle via the command line with SQLPlus.
  
4. **Database connection details:**
  - host: 	localhost
  - port: 	1521
  - sid:	vagrant

5. **Database user credentials:**
  - cs_ttc/cs_ttc
  - rs_ttc/rs_ttc
  - op_ttc/op_ttc
  - pr_ttc/pr_ttc
  - sc_ttc/sc_ttc
  - itropics/itropics
  - system/vagrant
  - sys/vagrant as sysdba

6. **TROPICS user credentials:**
  - dev.user/qwerty123