#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

query(){
if [ -z "$SQL_password" ]
then
  mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB $1
else
  mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB $1
fi
}

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


# rpl 15 vmlog
if [ ! -z $atvdetailsWH ] && $atvdetailsWH
then
  start=$(date '+%Y%m%d %H:%M:%S')
  cat $PATH_TO_STATS/cron_files/15_vmlog.sql | query
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Stats rpl15 vmlog processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# rpl 15 worker stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/cron_files/15_worker.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl15 worker processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


