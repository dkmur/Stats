#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# optimize pokemon_history_temp
if [ -z "$SQL_password" ]
then
mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history_temp
else
mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history_temp
fi

# optimize pokemon_history
if "$mon_cleanup"
then
  if [ -z "$SQL_password" ]
  then
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history
  else
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history
  fi
fi

# MAD log aggregation
if "$madlog"
then
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog10080.sql
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog10080.sql
  fi
fi

# MAD log aggregation worker level
if "$madlog_worker"
then
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker10080.sql
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker10080.sql
  fi
fi
