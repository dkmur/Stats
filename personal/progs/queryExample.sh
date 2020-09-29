#!/bin/bash
Home=$HOME
source config.ini

echo "Enter user to be displayed"
read UR
echo ""

sed -e "s/XXA/$UR/" /home/dkmur/progs/Stats/personal/sql/queryExample.sql > $Home/temp.sql

mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password < $Home/temp.sql > $Home/tempstats.txt
cat $Home/tempstats.txt
# echo "        "tempstats.txt" codkmured to /home/dkmur/Stats"

rm $Home/temp.sql
