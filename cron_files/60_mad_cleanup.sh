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
echo "`date '+%Y%m%d %H:%M:%S'` Hourly append shiny Stats started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
query "$MAD_DB" "Create TEMPORARY TABLE $MAD_DB.tmp100 AS(select b.encounter_id, count(distinct(b.worker)) as is_shiny from $MAD_DB.trs_stats_detect_mon_raw b where b.is_shiny = 1 group by b.encounter_id); update $STATS_DB.pokemon_history_temp a, $MAD_DB.tmp100 b set a.is_shiny = b.is_shiny where  a.encounter_id = b.encounter_id; drop table $MAD_DB.tmp100;"
echo "`date '+%Y%m%d %H:%M:%S'` Hourly append shiny Stats finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# cleanup table pokemon + trs_stats_detect_seen_type + pokemon_display
if "$pokemon"
then
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD tables pokemon, trs_stats_detect_seen_type and pokemon_display started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  query "$MAD_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL pokemon_cleanup(); CALL detect_seen_cleanup(); CALL pokemon_display_cleanup();"
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD tables pokemon, trs_stats_detect_seen_type and pokemon_display finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup table detect_raw
if "$trs_stats_detect_raw"
then
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD table trs_stats_detect_mon_raw started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  query "$MAD_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL trs_stats_detect_mon_raw_cleanup();"
  query "$MAD_DB" "delete from trs_stats_detect_fort_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD table trs_stats_detect_mon_raw finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup table location_raw
if "$trs_stats_location_raw"
then
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD table trs_stats_location_raw started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  query "$MAD_DB" "delete from trs_stats_location_raw where from_unixtime(period) < now() - interval 1 hour;"
  echo "`date '+%Y%m%d %H:%M:%S'` Hourly cleanup MAD table trs_stats_location_raw finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
