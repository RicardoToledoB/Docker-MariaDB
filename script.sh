#!/bin/bash
echo 'Starting mysqld'
mysqld_safe &
# The sleep 1 is there to make sure that inotifywait starts up before the socket is created
echo 'Waiting for mysqld to come online'
while [ ! -x /var/run/mysqld/mysqld.sock ]; do
	sleep 1
done

# Wait for the mysqld_safe process to start
mysql -uroot <<MYSQL_SCRIPT
	CREATE DATABASE ${MAKE_NEW_DATABASE};
	CREATE USER '${MAKE_USERNAME}'@'%' IDENTIFIED BY '${MAKE_USER_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MAKE_NEW_DATABASE}.* TO '${MAKE_USERNAME}'@'%';
	SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MAKE_ROOT_PASSWORD}');
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MAKE_ROOT_PASSWORD}' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
MYSQL_SCRIPT


exec "$@"
