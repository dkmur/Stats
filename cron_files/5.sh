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

# append shiny stats to pokemon_history_temp
start=$(date '+%Y%m%d %H:%M:%S')
query "$MAD_DB" "Create TEMPORARY TABLE $MAD_DB.tmp100 AS(select b.encounter_id, count(distinct(b.worker)) as is_shiny from $MAD_DB.trs_stats_detect_mon_raw b where b.is_shiny = 1 group by b.encounter_id); update $STATS_DB.pokemon_history_temp a, $MAD_DB.tmp100 b set a.is_shiny = b.is_shiny where  a.encounter_id = b.encounter_id; drop table $MAD_DB.tmp100;"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Append shiny Stats" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


# archive data and cleanup table pokemon
start=$(date '+%Y%m%d %H:%M:%S')
query "$MAD_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED';  CALL archiveAndCleanup();"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Archive and cleanup table pokemon" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


# backup pokemon_history_temp and cleanup
if "$mon_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_backup_cleanup();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Backup and clean pokemon_history_temp" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; delete from pokemon_history_temp where first_scanned < now() - interval 1 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Cleanup pokemon_history_temp" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi


# cleanup pokemon_history
if "$mon_cleanup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Cleanup pokemon_history" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi


# cleanup table detect_raw
if "$trs_stats_detect_raw"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "DELETE FROM trs_stats_detect_mon_raw WHERE timestamp_scan < (unix_timestamp()-1200);"
  query "$MAD_DB" "delete from trs_stats_detect_fort_raw where timestamp_scan < (unix_timestamp()-1200);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Table trs_stats_detect_mon_raw cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi


# cleanup table location_raw
if "$trs_stats_location_raw"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from trs_stats_location_raw where period < (unix_timestamp()-1200);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Table trs_stats_location_raw cleanup" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
