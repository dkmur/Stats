#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# Monthly backup pokemon_history

if $monthly_mon_table && ! $weekly_backup
then
  start=$(date '+%Y%m%d %H:%M:%S')
  yearmonth=$(date --date="yesterday" +"%Y_%m")
  if [ -z "$SQL_password" ]
  then
    mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB --no-data pokemon_history > $PATH_TO_STATS\pokemon_history_structure.sql
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "alter table $STATS_DB.pokemon_history RENAME $monthly_mon_database.pokemon_history_$yearmonth"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $PATH_TO_STATS\pokemon_history_structure.sql
    rm $PATH_TO_STATS/pokemon_history_structure.sql
#    mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $monthly_mon_database pokemon_history_$yearmonth
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Monthly backup pokemon_history" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
    if "$monthly_mon_file"
    then
      start=$(date '+%Y%m%d %H:%M:%S')
      mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user $monthly_mon_database pokemon_history_$yearmonth > $monthly_mon_folder/pokemon_history_$yearmonth.sql
      tar -czvf $monthly_mon_folder/pokemon_history_$yearmonth.tar.gz $monthly_mon_folder/pokemon_history_$yearmonth.sql
      rm $monthly_mon_folder/pokemon_history_$yearmonth.sql
      mysql -h$DB_IP -P$DB_PORT -u$SQL_user $monthly_mon_database -e "drop table pokemon_history_$yearmonth"
      echo "[$start] [$stop] [$diff] Monthly backup pokemon_history dumped, zipped and removed" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
    else
      mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $monthly_mon_database pokemon_history_$yearmonth
    fi
  else
    mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB --no-data pokemon_history > $PATH_TO_STATS\pokemon_history_structure.sql
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "alter table $STATS_DB.pokemon_history RENAME $monthly_mon_database.pokemon_history_$yearmonth"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $PATH_TO_STATS\pokemon_history_structure.sql
    rm $PATH_TO_STATS/pokemon_history_structure.sql
#    mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $monthly_mon_database pokemon_history_$yearmonth
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Monthly backup pokemon_history" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
    if "$monthly_mon_file"
    then
      start=$(date '+%Y%m%d %H:%M:%S')
      mysqldump -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $monthly_mon_database pokemon_history_$yearmonth > $monthly_mon_folder/pokemon_history_$yearmonth.sql
      tar -czvf $monthly_mon_folder/pokemon_history_$yearmonth.tar.gz $monthly_mon_folder/pokemon_history_$yearmonth.sql
      rm $monthly_mon_folder/pokemon_history_$yearmonth.sql
      mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $monthly_mon_database -e "drop table pokemon_history_$yearmonth"
      echo "[$start] [$stop] [$diff] Monthly backup pokemon_history dumped, zipped and removed" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
    else
      mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $monthly_mon_database pokemon_history_$yearmonth
    fi
  fi
fi

# Monthly optimize Stats db
start=$(date '+%Y%m%d %H:%M:%S')
if [ -z "$SQL_password" ]
then
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Monthly StatsDB optimize" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
else
  mysqloptimize --skip-write-binlog -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Monthly StatsDB optimize" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi
