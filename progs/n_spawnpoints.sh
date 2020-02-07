#!/bin/bash
Home=$HOME

echo "Enter resolution - Enter defaults to 1440 (Daily statistics) "
echo "  15: quarterly, 60: hourly, 1440: daily, 10080: weekly"

read res
if [ -z $res ]
	then
	res="1440"
fi

echo ""

if [ $res = 15 ]
        then
        DB_default="1"

elif [ $res = 60 ]
        then
        DB_default="2"
elif [ $res = 1440 ]
        then
        DB_default="21"
elif [ $res = 10080 ]
        then
        DB_default="150"
elif [ $res = 44640 ]
        then
        DB_default="400"
fi

echo "Enter number of days backwards from today - Enter for defaults ("$DB_default" days)"
read DB
echo
if [ -z $DB ]
	then
	DB=$DB_default
fi

echo ""
sed -e s/XXA/$DB/ -e s/XXB/$res/ pathToStatssql/n_spawnpoints.sql > $Home/temp.sql

mysql -h 127.0.0.1 < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
