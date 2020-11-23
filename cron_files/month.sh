#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Monthly backup pokemon_history
if "$monthly_mon_table"
then
  yearmonth=$(date --date="yesterday" +"%Y_%m")
  if [ -z "$SQL_password" ]
  then
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB --no-data pokemon_history > $PATH_TO_STATS\pokemon_history_structure.sql
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "alter table $STATS_DB.pokemon_history RENAME $monthly_mon_database.pokemon_history_$yearmonth"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS\pokemon_history_structure.sql
  mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user $monthly_mon_database pokemon_history_$yearmonth
  rm $PATH_TO_STATS\pokemon_history_structure.sql
  else
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB --no-data pokemon_history > $PATH_TO_STATS\pokemon_history_structure.sql
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "alter table $STATS_DB.pokemon_history RENAME $monthly_mon_database.pokemon_history_$yearmonth"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS\pokemon_history_structure.sql
  rm $PATH_TO_STATS\pokemon_history_structure.sql
  mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $monthly_mon_database pokemon_history_$yearmonth
  fi
fi
