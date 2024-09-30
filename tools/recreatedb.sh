#!/bin/bash

# Drop and re-create a database according to the currently configured CI environment.
# Your environment must be configured first using the environment.sh script.

set -e

case "${DBTYPE}" in
	"MySQL" | "MySQLi" | "MariaDB")
		sudo mysql -u root -e "DROP DATABASE IF EXISTS \`${DBNAME}\`; CREATE DATABASE \`${DBNAME}\` DEFAULT CHARACTER SET utf8;"
		sudo mysql -u root -e "DROP USER IF EXISTS \`${DBUSERNAME}\`@${DBHOST}"
		sudo mysql -u root -e "CREATE USER \`${DBUSERNAME}\`@${DBHOST} IDENTIFIED BY '${DBPASSWORD}'"
		sudo mysql -u root -e "GRANT ALL ON \`${DBNAME}\`.* TO \`${DBUSERNAME}\`@${DBHOST} WITH GRANT OPTION"
		# echo "DROP DATABASE IF EXISTS \`${DBNAME}\`; CREATE DATABASE \`${DBNAME}\` DEFAULT CHARACTER SET utf8;" | sudo mysql
		;;
	"PostgreSQL")
		dropdb -U postgres --if-exists ${DBNAME} && createdb -U postgres --owner=${DBUSERNAME} ${DBNAME}
		# echo "drop database IF EXISTS \`${DBNAME}\`; create database \`${DBNAME}\`; grant all privileges on database \`${DBNAME}\` to \`${DBUSERNAME}\`;" | sudo psql -U postgres
		;;
	*) echo "Unknown database type \"${DBTYPE}\". (Did you configure your environment?)"; exit -1 ;;
esac
