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

# rpl 60 area stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/cron_files/60_*_area.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl60 mon area processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# rpl 60 quest stats
questareas=$(echo "select count(*) from $MAD_DB.settings_geofence where geofence_id in (select geofence_included from $MAD_DB.settings_area_pokestops where level = 0);" | query)
if [ $questareas = 0 ]
then
echo "no quest areas defined, skip processing"
else
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/cron_files/60_*_area_quest.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl60 quest area processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# rpl 60 worker stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/cron_files/60_worker.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl60 worker processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


