#!/bin/bash
Home=$HOME
source config.ini

echo ""

mysql -h$DB_IP -u$SQL_user -p$SQL_password < "$PATH_TO_STATS"sql/location_noobs.sql > $Home/tempstats.txt
cat $Home/tempstats.txt

