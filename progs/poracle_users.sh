#!/bin/bash
Home=$HOME
source config.ini

echo "Enter number of users to be displayed - Enter defaults to top 20 users"
read UR
echo
if [ -z $UR ]
	then
	UR=20
fi

echo ""
sed -e s/rmdb/$MAD_DB/ -e s/pogodb/$STATS_DB/ -e s/XXA/$UR/ $PATH_TO_STATS/sql/poracle_users.sql > $Home/temp.sql

mysql -h 127.0.0.1 -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
