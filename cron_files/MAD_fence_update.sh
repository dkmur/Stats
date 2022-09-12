#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if [ -z "$SQL_password" ]
then
  query(){
  mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user "$1" -e "$2;"
  }
else
  query(){
  mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password "$1" -e "$2;"
  }
fi

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

# Re-create MAD mon fences
  start=$(date '+%Y%m%d %H:%M:%S')
  echo "Re-creating MAD mon fences"
  rm -f $PATH_TO_STATS/areas/*.mad

# delete existing
  query "$STATS_DB" "delete from geofences where type = 'mon'"

# get MAD mon_mitm fence data
        while read -r geofence_id name;
        do

        query "$MAD_DB" "SELECT LEFT(fence_data,length(fence_data)-1) from settings_geofence where geofence_id = $geofence_id;" | sed 's/\[\"\[/[/g' | sed 's/",/\n/g' | sed 's/"//g' | sed 's/^ //g' | sed 's/\[/§\[/g' > $PATH_TO_STATS/areas/input


                IFS=§;
                for i in `cat $PATH_TO_STATS/areas/input`;
                do
                        shopt -s lastpipe
                        echo $i | while read -r line;
                                do
                                        if [[ $line == *"["* ]] || [[ $line == *"]"* ]]; then
                                                coord=1
                                                fence=$(echo -n ${line} | sed 's/ /_/g' | tr -d "]" | tr -d "[")
                                                exec > $PATH_TO_STATS/areas/$fence.mad
                                                echo AREA_NAME=\"$name\"
                                                echo -n FENCE_NAME=\"
                                                echo -n "$line" | tr -d "]" | tr -d "["
                                                echo \"
                                        elif [ ! -z "$line" ]; then
                                                if [[ $coord == 1 ]]; then
                                                echo -n POLYGON=\"
                                                fi
                                        echo -n $line | sed s/"]"/\n/ | sed s/,/' '/g
                                        echo -n ", "
                                        let "coord+=1"
                                        fi
                                done
                        echo -n $i | tail +2 | head -1 | sed s/,/' '/g | sed s/$/\"/g
                done | sed s/"(,"/"("/g | sed s/", ,"/,/g
                unset IFS

        done < <(query "$MAD_DB" "$(cat << EOF
        select geofence_id, name from settings_geofence where geofence_id in (select a.geofence_included from settings_area_mon_mitm a, settings_area b where a.area_id=b.area_id);
EOF
        )")

# process to db
  for area in $PATH_TO_STATS/areas/*.mad
  do
    source $area
    FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
    AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)

  query "$STATS_DB" "insert ignore into geofences (area,fence,type,polygon) values ('$AREANAME','$FENCENAME','mon',st_geomfromtext('POLYGON(($POLYGON))'))"
  done

#cleanup
  rm -f $PATH_TO_STATS/areas/input
  rm -f $PATH_TO_STATS/areas/*.mad

  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Fence update pokemon areas" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


# Create pokestop area files based on MAD fences
questareas=$(query "$MAD_DB" "select count(*) from settings_geofence where geofence_id in (select geofence_included from settings_area_pokestops where level = 0);")
  if [ $questareas = 0 ]
  then
  echo "no quest areas defined, skip processing"
  else
  echo "$questareas Quest areas found, creating fences from MADdb"
  echo ""
  start=$(date '+%Y%m%d %H:%M:%S')
  rm -f $PATH_TO_STATS/areas/*.quest

# delete existing
  query "$STATS_DB" "delete from geofences where type = 'quest'"

# get MAD pokestop fence data
        while read -r geofence_id name;
        do

        query "$MAD_DB" "SELECT LEFT(fence_data,length(fence_data)-1) from settings_geofence where geofence_id = $geofence_id;" | sed 's/\[\"\[/[/g' | sed 's/",/\n/g' | sed 's/"//g' | sed 's/^ //g' | sed 's/\[/§\[/g' > $PATH_TO_STATS/areas/input_quest


                IFS=§;
                for i in `cat $PATH_TO_STATS/areas/input_quest`;
                do
                        shopt -s lastpipe
                        echo $i | while read -r line;
                                do
                                        if [[ $line == *"["* ]] || [[ $line == *"]"* ]]; then
                                                coord=1
                                                fence=$(echo -n ${line} | sed 's/ /_/g' | tr -d "]" | tr -d "[")
                                                exec > $PATH_TO_STATS/areas/$fence.quest
                                                echo AREA_NAME=\"$name\"
                                                echo -n FENCE_NAME=\"
                                                echo -n "$line" | tr -d "]" | tr -d "["
                                                echo \"
                                        elif [ ! -z "$line" ]; then
                                                if [[ $coord == 1 ]]; then
                                                echo -n POLYGON=\"
                                                fi
                                        echo -n $line | sed s/"]"/\n/ | sed s/,/' '/g
                                        echo -n ", "
                                        let "coord+=1"
                                        fi
                                done
                        echo -n $i | tail +2 | head -1 | sed s/,/' '/g | sed s/$/\"/g
                done | sed s/"(,"/"("/g | sed s/", ,"/,/g
                unset IFS

        done < <(query "$MAD_DB" "$(cat << EOF
        select geofence_id, name from settings_geofence where geofence_id in (select geofence_included from settings_area_pokestops where level = 0);
EOF
        )")

# process to db
  for area in $PATH_TO_STATS/areas/*.quest
  do
    source $area
    FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
    AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)

  query "$STATS_DB" "insert ignore into geofences (area,fence,type,polygon) values ('$AREANAME','$FENCENAME','quest',st_geomfromtext('POLYGON(($POLYGON))'))"
  done


#cleanup
  rm -f $PATH_TO_STATS/areas/input_quest
  rm -f $PATH_TO_STATS/areas/*.quest


stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Fence update quest areas" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


  fi

# Append new devices to table Area
if [[ "$MAD_DEVICE_INSERT" == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  echo "Append new devices and areas to table Area"
  if [ -z "$SQL_password" ]
  then
    query "$STATS_DB" "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a, $STATS_DB.device b SET a.Area = b.Area WHERE a.Origin = b.Origin; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Device update table Area" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    query "$STATS_DB" "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a, $STATS_DB.device b SET a.Area = b.Area WHERE a.Origin = b.Origin; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Device update table Area" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi
