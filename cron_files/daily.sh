#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Add mons from pokemn_history_temp to pokemon_history
if "$mon_backup"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; insert ignore into pokemon_history select * from pokemon_history_temp where first_scanned < curdate();"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; insert ignore into pokemon_history select * from pokemon_history_temp where first_scanned < curdate();"
  fi
fi

sleep 30s

# delete from pokemon_history_temp
if [ -z "$SQL_password" ]
then
mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_cleanup();"
else
mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_cleanup();"
fi

# cleanup pokemon_history
if "$mon_cleanup"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  fi
fi

# reset spawndef 15
if "$SPAWNDEF15_CLEANUP"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS( select b.spawnpoint_id as 'spawnpoint', count(b.spawnpoint_id) as 'times' from $MAD_DB.trs_spawn a, $STATS_DB.pokemon_history b where a.spawnpoint = b.spawnpoint_id and a.spawndef = 15 and b.first_scanned like concat(curdate() - interval 1 day,'%') and b.first_scanned >= concat(curdate() -interval 1 day,' ','$QUEST_END') and (b.first_scanned > b.disappear_time - interval 30 minute or b.last_modified < b.disappear_time - interval 30 minute) group by spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240  WHERE spawnpoint in (select spawnpoint from $STATS_DB.tmp60 where times >= $SPAWNDEF15_HOURS); DROP TABLE $STATS_DB.tmp60;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS( select b.spawnpoint_id as 'spawnpoint', count(b.spawnpoint_id) as 'times' from $MAD_DB.trs_spawn a, $STATS_DB.pokemon_history b where a.spawnpoint = b.spawnpoint_id and a.spawndef = 15 and b.first_scanned like concat(curdate() - interval 1 day,'%') and b.first_scanned >= concat(curdate() -interval 1 day,' ','$QUEST_END') and (b.first_scanned > b.disappear_time - interval 30 minute or b.last_modified < b.disappear_time - interval 30 minute) group by spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240  WHERE spawnpoint in (select spawnpoint from $STATS_DB.tmp60 where times >= $SPAWNDEF15_HOURS); DROP TABLE $STATS_DB.tmp60;"
  fi
fi

# pokestop to gym remove
if "$stop_to_gym_remove"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from pokestop where pokestop_id in (select gym_id from gym);"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from pokestop where pokestop_id in (select gym_id from gym);"
  fi
fi

# remove pokestop without quest scanned for X days
if "$stop_no_quest_remove"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete pokestop where pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete pokestop where pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  fi
fi

# cleanup stats tables
if "$mon_cleanup"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  fi
fi

# MAD cleanup trs_stats_detect
if "$trs_stats_detect"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  fi
fi

# MAD cleanup trs_stats_location
if "$trs_stats_location"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  fi
fi

# MAD cleanup trs_usage
if "$trs_usage"
then
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
  fi
fi

# MAD backup
if "$mad_backup"
then
  if [ -z "$SQL_password" ]
  then
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  else
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  fi
fi

# MAD delete
if "$mad_backup"
then
  find $PATH_TO_STATS/MAD_backup -type f -mtime +$backup_delete_days -exec rm -f {} \;
fi

# Gym cleanup
if [ -z "$SQL_password" ]
then
mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
else
mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
fi
