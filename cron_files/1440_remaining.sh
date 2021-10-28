#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

query(){
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $1 -e "$2;"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $1 -e "$2;"
fi
}

# pokestop to gym remove
if "$stop_to_gym_remove"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from pokestop where pokestop_id in (select gym_id from gym);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily delete pokestop converted to gym cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# remove pokestop without quest scanned for X days and unseen
if "$stop_no_quest_remove"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from pokestop where date(last_updated) < curdate() -interval $no_quest_days day and pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  query "$MAD_DB" "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily delete pokestop without quest scanned cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup stats tables
start=$(date '+%Y%m%d %H:%M:%S')
query "$STATS_DB" "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
query "$STATS_DB" "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
query "$STATS_DB" "delete from stats_area_quest where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats area, worker and quest tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup of mad log tables
start=$(date '+%Y%m%d %H:%M:%S')
query "$STATS_DB" "delete from error where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
query "$STATS_DB" "delete from warning where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats madlog tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup of mad log tables, worker level
start=$(date '+%Y%m%d %H:%M:%S')
query "$STATS_DB" "delete from error_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
query "$STATS_DB" "delete from warning_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats madlog worker tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# MAD cleanup trs_stats_detect
if "$trs_stats_detect"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup MAD trs_stats_detect" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD cleanup trs_stats_location
if "$trs_stats_location"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup MAD trs_stats_location" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD cleanup trs_usage
if "$trs_usage"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup MAD trs_usage" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD backup
if "$mad_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  if [ -z "$SQL_password" ]
  then
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily MAD table backup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily MAD table backup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD delete
if "$mad_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  find $PATH_TO_STATS/MAD_backup -type f -mtime +$backup_delete_days -exec rm -f {} \;
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily MAD backup cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# Gym cleanup
start=$(date '+%Y%m%d %H:%M:%S')
query "$MAD_DB" "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup unseen gyms" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# MAD log aggregation
if "$madlog"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  cat $PATH_TO_STATS/cron_files/madlog1440.sql | query
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Stats rpl1440 MAD log aggregation" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD log aggregation worker level
if "$madlog_worker"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  cat $PATH_TO_STATS/cron_files/madlog_worker1440.sql | query
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Stats rpl1440 MAD log aggregation worker level" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
