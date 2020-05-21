#!/bin/bash
Home=$HOME
source config.ini

echo "Enter number of days backwards from today - Enter for today"
read DB
echo
if [ -z $DB ]
	then
	DB=0
fi

echo ""
sed -e s/pogodb/$STATS_DB/ -e s/XXA/$DB/ $PATH_TO_STATS/sql/gmail.sql > $Home/temp.sql

mysql -h 127.0.0.1 -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
