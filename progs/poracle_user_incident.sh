#!/bin/bash
Home=$HOME
source config.ini

echo "Enter user to be displayed"
read UR
echo ""

sed -e s/rmdb/$MAD_DB/ -e s/pogodb/$STATS_DB/ -e "s/XXA/$UR/" $PATH_TO_STATS/sql/poracle_user_incident.sql > $Home/temp.sql

mysql -h 127.0.0.1 -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
