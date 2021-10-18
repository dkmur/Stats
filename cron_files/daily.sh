#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "`date '+%Y%m%d %H:%M:%S'` ATVdetails started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# Add mons from pokemn_history_temp to pokemon_history
if "$mon_backup"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily copy pokemn_history_temp to pokemon_history started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL move_mon_to_history();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily copy pokemn_history_temp to pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL move_mon_to_history();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily copy pokemn_history_temp to pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

sleep 30s

# delete from pokemon_history_temp
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemn_history_temp started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
then
mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_cleanup();"
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemn_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "SET SESSION tx_isolation = 'READ-UNCOMMITTED'; CALL mon_history_temp_cleanup();"
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemn_history_temp finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup pokemon_history
if "$mon_cleanup"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemon_history started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from pokemon_history where first_scanned < curdate() - interval $days_to_keep day;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup pokemon_history finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# reset spawndef 15
if "$SPAWNDEF15_CLEANUP"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily spwndef 15 cleanup started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS( select b.spawnpoint_id as 'spawnpoint', count(b.spawnpoint_id) as 'times' from $MAD_DB.trs_spawn a, $STATS_DB.pokemon_history b where a.spawnpoint = b.spawnpoint_id and a.spawndef = 15 and b.first_scanned like concat(curdate() - interval 1 day,'%') and b.first_scanned >= concat(curdate() -interval 1 day,' ','$QUEST_END') and b.first_scanned > b.disappear_time - interval 30 minute group by spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240  WHERE spawnpoint in (select spawnpoint from $STATS_DB.tmp60 where times >= $SPAWNDEF15_HOURS); DROP TABLE $STATS_DB.tmp60;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily spwndef 15 cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.tmp60 (INDEX (spawnpoint)) AS( select b.spawnpoint_id as 'spawnpoint', count(b.spawnpoint_id) as 'times' from $MAD_DB.trs_spawn a, $STATS_DB.pokemon_history b where a.spawnpoint = b.spawnpoint_id and a.spawndef = 15 and b.first_scanned like concat(curdate() - interval 1 day,'%') and b.first_scanned >= concat(curdate() -interval 1 day,' ','$QUEST_END') and b.first_scanned > b.disappear_time - interval 30 minute group by spawnpoint_id); UPDATE $MAD_DB.trs_spawn SET spawndef = 240  WHERE spawnpoint in (select spawnpoint from $STATS_DB.tmp60 where times >= $SPAWNDEF15_HOURS); DROP TABLE $STATS_DB.tmp60;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily spwndef 15 cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# pokestop to gym remove
if "$stop_to_gym_remove"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop converted to gym cleanup started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from pokestop where pokestop_id in (select gym_id from gym);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop converted to gym cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from pokestop where pokestop_id in (select gym_id from gym);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop converted to gym cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# remove pokestop without quest scanned for X days and unseen
if "$stop_no_quest_remove"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop without quest scanned cleanup started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from pokestop where date(last_updated) < curdate() -interval $no_quest_days day and pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop without quest scanned cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from pokestop where date(last_updated) < curdate() -interval $no_quest_days day and pokestop_id in (select GUID from trs_quest where date(from_unixtime(quest_timestamp)) < curdate() -interval $no_quest_days day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_quest where GUID not in (select pokestop_id from pokestop);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily delete pokestop without quest scanned cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# cleanup stats tables
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats area,worker and quest tables started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from stats_area_quest where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats area,worker and quest tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from stats_worker where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from stats_area where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from stats_area_quest where (RPL = 15 and Datetime < curdate() - interval $RPL15 day) or (RPL = 60 and Datetime < curdate() - interval $RPL60 day) or (RPL = 1440 and Datetime < curdate() - interval $RPL1440 day) or (RPL = 10080 and Datetime < curdate() - interval $RPL10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats area,worker and quest tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup of mad log tables
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog tables started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from error where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from warning where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from error where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from warning where (RPL = 60 and Datetime < curdate() - interval $log60 day) or (RPL = 1440 and Datetime < curdate() - interval $log1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# cleanup of mad log tables, worker level
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog worker tables started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from error_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "delete from warning_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog worker tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from error_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "delete from warning_worker where (RPL = 60 and Datetime < curdate() - interval $log_worker60 day) or (RPL = 1440 and Datetime < curdate() - interval $log_worker1440 day) or (RPL = 10080 and Datetime < curdate() - interval $log_worker10080 day);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup Stats madlog worker tables finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD cleanup trs_stats_detect
if "$trs_stats_detect"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_detect started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_detect finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_detect where from_unixtime(timestamp_scan) < curdate();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_detect finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD cleanup trs_stats_location
if "$trs_stats_location"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_location started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_location finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_stats_location where from_unixtime(timestamp_scan) < curdate();"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_stats_location finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD cleanup trs_usage
if "$trs_usage"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_usage started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_usage finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from trs_usage where from_unixtime(timestamp) < curdate() - interval 30 day;"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup MAD trs_usage finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD backup
if "$mad_backup"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD table backup started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD table backup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
  mkdir -p $PATH_TO_STATS/MAD_backup
  mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB --ignore-table=$MAD_DB.filestore_chunks --ignore-table=$MAD_DB.filestore_meta --ignore-table=$MAD_DB.pokemon --ignore-table=$MAD_DB.raid --ignore-table=$MAD_DB.weather --ignore-table=$MAD_DB.trs_status --ignore-table=$MAD_DB.trs_visited --ignore-table=$MAD_DB.trs_stats_detect --ignore-table=$MAD_DB.trs_stats_detect_mon_raw --ignore-table=$MAD_DB.trs_stats_detect_fort_raw --ignore-table=$MAD_DB.trs_stats_location --ignore-table=$MAD_DB.trs_stats_location_raw --ignore-table=$MAD_DB.trs_quest --ignore-table=$MAD_DB.trs_usage --ignore-table=$MAD_DB.trs_s2cells > $PATH_TO_STATS/MAD_backup/madbackup_$(date +%Y-%m-%d).sql
  echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD table backup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD delete
if "$mad_backup"
then
  echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD backup cleanup started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  find $PATH_TO_STATS/MAD_backup -type f -mtime +$backup_delete_days -exec rm -f {} \;
  echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD backup cleanup finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# Gym cleanup
echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup unseen gyms started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup unseen gyms finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "delete from gym where last_scanned < curdate() - interval $gym_not_scanned_days day; delete from gymdetails where gym_id not in (select gym_id from gym);"
  echo "`date '+%Y%m%d %H:%M:%S'` Daily cleanup unseen gyms finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi

# MAD log aggregation
if "$madlog"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog1440.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog1440.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi

# MAD log aggregation worker level
if "$madlog_worker"
then
 echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation worker level started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker1440.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation worker level finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS/cron_files/madlog_worker1440.sql
    echo "`date '+%Y%m%d %H:%M:%S'` Daily MAD log aggregation worker level finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi
