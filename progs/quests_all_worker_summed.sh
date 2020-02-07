#!/bin/bash
Home=$HOME

echo "Enter number of days backwards from today - Enter for today only"
read DB
echo
if [ -z $DB ]
	then
	DB="0"
fi

echo ""
sed -e s/XXA/$DB/ pathToStatssql/quests_all_worker_summed.sql > $Home/temp.sql

mysql -h 127.0.0.1 < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
