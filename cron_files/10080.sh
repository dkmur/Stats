#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

query(){
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB $1
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB $1
fi
}

# rpl 10080 area stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 mon area processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/10080_area.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 mon area processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log

# rpl 10080 quest stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 quest area processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/10080_area_quest.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 quest area processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log

# rpl 10080 worker stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 worker processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/10080_worker.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl10080 worker processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log


# optimize pokemon_history_temp, we stop doing this => useless as it will fill up anyway to its orgininal leverl and we delete not truncate
#echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
#if [ -z "$SQL_password" ]
#then
#  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB pokemon_history_temp
#  echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
#else
#  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB pokemon_history_temp
#  echo "`date '+%Y%m%d %H:%M:%S'` Weekly StatsDB optimize pokemon_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
#fi

# MAD log aggregation
if "$madlog"
then
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog processing started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
cat $PATH_TO_STATS/cron_files/madlog10080.sql | query
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD log aggregation worker level
if "$madlog_worker"
then
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog worker level processing started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
cat $PATH_TO_STATS/cron_files/madlog_worker10080.sql | query
echo "`date '+%Y%m%d %H:%M:%S'` Weekly aggregation MADlog worker level processing finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
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
