#!/bin/bash
Home=$HOME
source config.ini

echo "Enter Pokemon number"

read poke

echo ""
echo "Enter number of days backwards from today - Enter for default (7 days)"
read DB
echo
if [ -z $DB ]
	then
	DB=7
fi

echo ""
sed -e s/rmdb/$MAD_DB/ -e s/pogodb/$STATS_DB/ -e s/XXB/$poke/ -e s/XXA/$DB/ $PATH_TO_STATS/sql/poke_seen.sql > $Home/temp.sql

mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


#rm $Home/temp.sql
