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
query "$MAD_DB" "CALL archiveAndCleanup();"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Archive and cleanup table pokemon" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


# cleanup table trs_stats_detect_seen_type + pokemon_display
# cleanup table detect_raw
if "$trs_stats_detect_raw"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL trs_stats_detect_mon_raw_cleanup();"
  query "$MAD_DB" "delete from trs_stats_detect_fort_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Hourly cleanup MAD table trs_stats_detect_mon_raw" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup table location_raw
if "$trs_stats_location_raw"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$MAD_DB" "delete from trs_stats_location_raw where from_unixtime(period) < now() - interval 1 hour;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Hourly cleanup MAD table trs_stats_location_raw" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
