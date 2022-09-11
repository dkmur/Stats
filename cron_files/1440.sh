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

query2(){
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $1 -e "$2;"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $1 -e "$2;"
fi
}

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# rpl 1440 mon area stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/default_files/1440_area.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl1440 mon area processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# rpl 1440 spawnpoint area stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/default_files/1440_area_spawnpoint.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl1440 spawnpoint area processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# rpl 1440 quest stats
questareas=$(echo "select count(*) from $MAD_DB.settings_geofence where geofence_id in (select geofence_included from $MAD_DB.settings_area_pokestops where level = 0);" | query)
if [ $questareas = 0 ]
then
echo "no quest areas defined, skip processing"
else
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/default_files/1440_area_quest.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl1440 quest area processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 worker stats
start=$(date '+%Y%m%d %H:%M:%S')
cat $PATH_TO_STATS/default_files/1440_worker.sql | query
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl1440 worker processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

if [ ! -z $atvdetailsWH ] && $atvdetailsWH
then
  # rpl 1440 vmlog stats
  start=$(date '+%Y%m%d %H:%M:%S')
  cat $PATH_TO_STATS/cron_files/1440_vmlog.sql | query
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Stats rpl1440 vmlog processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

  #rpl 1440 ATVstats
  start=$(date '+%Y%m%d %H:%M:%S')
  cat $PATH_TO_STATS/cron_files/1440_atvstats.sql | query
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Stats rpl1440 ATVstats processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi


# pokestop to gym OR gym to pokestop remove
if "$stop_to_gym_remove"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$MAD_DB" "delete a from gym a, pokestop b where a.gym_id=b.pokestop_id and a.last_scanned<b.last_updated; delete b from gym a, pokestop b where a.gym_id=b.pokestop_id and a.last_scanned>b.last_updated; delete from gymdetails where gym_id not in (select gym_id from gym);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily delete stop/gym conversion" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# remove pokestop without quest scanned for X days and unseen
if "$stop_no_quest_remove"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$MAD_DB" "delete from pokestop where date(last_updated) < curdate() -interval $no_quest_days day and pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  query2 "$MAD_DB" "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily delete pokestop without quest scanned cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup stats tables
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$STATS_DB" "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
query2 "$STATS_DB" "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
query2 "$STATS_DB" "delete from stats_area_quest where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
query2 "$STATS_DB" "delete from vmlog where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats area, worker, quest and vmlog tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup of mad log tables
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$STATS_DB" "delete from error where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
query2 "$STATS_DB" "delete from warning where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats madlog tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup of mad log tables, worker level
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$STATS_DB" "delete from error_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
query2 "$STATS_DB" "delete from warning_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats madlog worker tables" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup of ATVstats table
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$STATS_DB" "delete from ATVstats where (RPL < 1440 and timestamp < curdate() - interval $ATVstatsNON1440 day) or (RPL = 1440 and timestamp < curdate() - interval $ATVstats1440 day)"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup Stats ATVstats table" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# MAD cleanup trs_stats_detect
if "$trs_stats_detect"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$MAD_DB" "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup MAD trs_stats_detect" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD cleanup trs_stats_location
if "$trs_stats_location"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$MAD_DB" "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup MAD trs_stats_location" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD cleanup trs_usage
if "$trs_usage"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$MAD_DB" "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
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
query2 "$MAD_DB" "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup unseen gyms" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# vMAD table gympokemon cleanup
if [ ! -z ${vmad+x} ]
then
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$MAD_DB" "delete from cev_gympokemon where last_seen < now() - interval $gympokemon day;"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup vMAD gympokemon" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# vMAD table trainer_pokemon cleanup
if [ ! -z ${vmad+x} ]
then
start=$(date '+%Y%m%d %H:%M:%S')
query2 "$MAD_DB" "delete from cev_trainer_pokemon where last_seen < now() - interval $trainer_pokemon day;"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup vMAD trainer_pokemon" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

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

# reset spawndef 15
if "$SPAWNDEF15_CLEANUP"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query2 "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS(SELECT spawnpoint_id as 'spawnpoint', count(spawnpoint_id) as 'times' FROM $STATS_DB.pokemon_history_temp WHERE spawnpoint_id <> 0 and first_scanned < concat(curdate(),' 00:00:00') and first_scanned >= concat(curdate() - interval 1 DAY,' ','$QUEST_END') and first_scanned > disappear_time - interval 30 minute GROUP BY spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240 WHERE spawnpoint in (SELECT a.spawnpoint FROM $MAD_DB.trs_spawn a, $STATS_DB.tmp60 b WHERE a.spawnpoint = b.spawnpoint and b.times >= $SPAWNDEF15_HOURS and a.spawndef = 15); DROP TABLE $STATS_DB.tmp60;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily spawndef 15 cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
