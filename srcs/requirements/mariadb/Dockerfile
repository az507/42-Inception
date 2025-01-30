FROM debian:11

# run apt-get update and install on the same line to ensure latest package versions get downloaded every time
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt-get/lists/* # clear the apt cache which reduces docker image size
COPY conf/mariadb.cnf /etc/mysql

# -r flag to create systems account, meant for daemons. With systems accounts, access by services can be restricted to files
# that are pertinent to the service, and limit the amount of damage that can be caused if the service was hijacked
# https://www.linuxquestions.org/questions/linux-newbie-8/useradd-r-option-and-system-account-question-892978/
RUN groupadd -g 1000 -r mariadb && useradd -u 1000 -r -g mariadb mariadb

# Without creating /run/mysqld directory, the /run/mysqld/mysqld.sock cant be created (no such file or directory)
# Without giving the daemon access/ownership to needed files/folders, error: permission denied
COPY tools/entrypoint.sh tools/create_usr.sh /usr/lib/mysql
RUN mkdir -p /run/mysqld && chown -R mariadb:mariadb /run/mysqld /var/lib/mysql /usr/lib/mysql

# After a fresh install of mysql, need to manually create the systemtables via mysql_install_db. The mysql daemon will
# not do it for you on startup. (mariadb and mysql shld be same)
# https://stackoverflow.com/questions/9083408/fatal-error-cant-open-and-lock-privilege-tables-table-mysql-host-doesnt-ex
#RUN mysql_install_db --user=mariadb
#WORKDIR /usr
USER mariadb

# commands to run placed in entrypoint script, because both have to be run "together" as last command
# if "mysql_install_db" was run as a regular RUN instruction, it will not run silently and docker build will not show any errors
CMD ["/usr/lib/mysql/entrypoint.sh"]
#CMD ["/usr/sbin/mariadbd", "--basedir=/usr", "--datadir=/var/lib/mysql", "--plugin-dir=/usr/lib/mysql/plugin", "--user=mysql", "--skip-log-error", "--pid-file=/run/mysqld/mysqld.pid", "--socket=/run/mysqld/mysqld.sock"]
