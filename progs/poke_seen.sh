#!/bin/bash
Home=$HOME

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
sed -e s/XXB/$poke/ -e s/XXA/$DB/ pathToStatssql/poke_seen.sql > $Home/temp.sql

mysql -h 127.0.0.1 < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


#rm $Home/temp.sql
