#!/bin/bash

set -x

echo "Post PostgreSQL populating 'uscustomers' database"
PGPASSWORD=$POSTGRESQL_PASSWORD /usr/bin/psql -h $USCUSTOMERS_SERVICE_HOST -d $POSTGRESQL_DATABASE -U $POSTGRESQL_USERNAME -f /tmp/src/extensions/extras/uscustomers-psql.sql

echo "Post MySQL populating 'eucustomers' database"
/usr/bin/mysql -u $MYSQL_USERNAME --password="$MYSQL_PASSWORD" -D $MYSQL_DATABASE -h $EUCUSTOMERS_SERVICE_HOST < /tmp/src/extensions/extras/eucustomers-mysql.sql
