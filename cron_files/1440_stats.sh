#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

query(){
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB $1
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB $1
fi
}

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# rpl 1440 area stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 mon area processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/1440_*_area.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 mon area processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log

# rpl 1440 quest stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 quest area processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/1440_area_quest.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 quest area processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log

# rpl 1440 worker stats
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 worker processing started" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
cat $PATH_TO_STATS/cron_files/1440_worker.sql | query
echo "`date '+\%Y\%m\%d \%H:\%M:\%S'` Stats rpl1440 worker processing finished" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log


