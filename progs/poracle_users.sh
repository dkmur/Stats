#!/bin/bash
Home=$HOME

echo "Enter number of users to be displayed - Enter defaults to top 20 users"
read UR
echo
if [ -z $UR ]
	then
	UR=20
fi

echo ""
sed -e s/XXA/$UR/ pathToStatssql/poracle_users.sql > $Home/temp.sql

mysql -h 127.0.0.1 < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
