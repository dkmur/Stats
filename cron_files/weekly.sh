#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# optimize pokemon_history_temp
if [ -z "$SQL_password" ]
then
mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history_temp
else
mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history_temp
fi

# optimize pokemon_history
if "$mon_cleanup"
then
  if [ -z "$SQL_password" ]
  then
  mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history
  else
  mysqloptimize -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history
  fi
fi
