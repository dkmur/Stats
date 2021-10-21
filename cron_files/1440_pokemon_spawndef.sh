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

# Add mons from pokemn_history_temp to pokemon_history
if "$mon_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL move_mon_to_history();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily copy pokemn_history_temp to pokemon_history" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
fi

sleep 10s

# delete from pokemon_history_temp
start=$(date '+%Y%m%d %H:%M:%S')
query "$STATS_DB" "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_cleanup();"
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Daily cleanup pokemn_history_temp" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log

# cleanup pokemon_history
if "$mon_cleanup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily cleanup pokemon_history" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
fi

# reset spawndef 15
if "$SPAWNDEF15_CLEANUP"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  query "$STATS_DB" "CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS( select b.spawnpoint_id as 'spawnpoint', count(b.spawnpoint_id) as 'times' from $MAD_DB.trs_spawn a, $STATS_DB.pokemon_history b where a.spawnpoint = b.spawnpoint_id and a.spawndef = 15 and b.first_scanned like concat(curdate() - interval 1 day,'%') and b.first_scanned >= concat(curdate() -interval 1 day,' ','$QUEST_END') and b.first_scanned > b.disappear_time - interval 30 minute group by spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240  WHERE spawnpoint in (select spawnpoint from $STATS_DB.tmp60 where times >= $SPAWNDEF15_HOURS); DROP TABLE $STATS_DB.tmp60;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Daily spwndef 15 cleanup" >> $PATH_TO_STATS/logs/log_$(date '+\%Y\%m').log
fi
