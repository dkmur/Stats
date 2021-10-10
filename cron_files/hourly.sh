#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# append shiny stats to pokemon_history_temp
if [ -z "$SQL_password" ]
then
mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "Create TEMPORARY TABLE $MAD_DB.tmp100 AS(select b.encounter_id, count(distinct(b.worker)) as is_shiny from $MAD_DB.trs_stats_detect_mon_raw b where b.is_shiny = 1 group by b.encounter_id); update $STATS_DB.pokemon_history_temp a, $MAD_DB.tmp100 b set a.is_shiny = b.is_shiny where  a.encounter_id = b.encounter_id; drop table $MAD_DB.tmp100;"
else
mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "Create TEMPORARY TABLE $MAD_DB.tmp100 AS(select b.encounter_id, count(distinct(b.worker)) as is_shiny from $MAD_DB.trs_stats_detect_mon_raw b where b.is_shiny = 1 group by b.encounter_id); update $STATS_DB.pokemon_history_temp a, $MAD_DB.tmp100 b set a.is_shiny = b.is_shiny where  a.encounter_id = b.encounter_id; drop table $MAD_DB.tmp100;"
fi

# cleanup table pokemon + trs_stats_detect_seen_type + pokemon_display
if "$pokemon"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL pokemon_cleanup(); CALL detect_seen_cleanup(); CALL pokemon_display_cleanup();"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL pokemon_cleanup(); CALL detect_seen_cleanup(); CALL pokemon_display_cleanup();"
  fi
fi

# cleanup table detect_raw
if "$trs_stats_detect_raw"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_detect_mon_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_detect_fort_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_detect_mon_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_detect_fort_raw where from_unixtime(timestamp_scan) < now() - interval 1 hour;"
  fi
fi

# cleanup table location_raw
if "$trs_stats_location_raw"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_location_raw where from_unixtime(period) < now() - interval 1 hour;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_location_raw where from_unixtime(period) < now() - interval 1 hour;"
  fi
fi

# process MAD logs
if "$madlog"
then
  cd $PATH_TO_STATS/cron_files/ && ./madlog.sh
fi

# process MAD logs worker level
if "$madlog_worker"
then
  cd $PATH_TO_STATS/cron_files/ && ./madlog_worker.sh
fi
