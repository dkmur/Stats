#!/bin/bash
Home=$HOME
source config.ini

echo ""
sed -e s/pogodb/$STATS_DB/ $PATH_TO_STATS/sql/location_noobs.sql > $Home/temp.sql
mysql -h$DB_IP -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt

