#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# optimize pokemon_history_temp
echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
then
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history_temp
  echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history_temp
  echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# optimize pokemon_history
if "$mon_cleanup"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
    mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD log aggregation
if "$madlog"
then
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog processing started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog10080.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog10080.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD log aggregation worker level
if "$madlog_worker"
then
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog worker level processing started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker10080.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog worker level processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker10080.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog worker level processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi
