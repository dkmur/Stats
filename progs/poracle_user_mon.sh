#!/bin/bash
Home=$HOME

echo "Enter user to be displayed"
read UR
echo ""

sed -e "s/XXA/$UR/" pathToStatssql/poracle_user_mon.sql > $Home/temp.sql

mysql -h 127.0.0.1 < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt


rm $Home/temp.sql
