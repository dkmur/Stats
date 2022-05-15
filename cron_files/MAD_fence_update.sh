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

# Update MAD fences and re-create area files
if [[ "$FENCE" == "MAD" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  echo "Re-creating MAD fence config and area files"
  rm -f $PATH_TO_STATS/areas/*.mad

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
        select geofence_id, name from settings_geofence where geofence_id in (select geofence_included from settings_area_mon_mitm);
EOF
        )")
  rm -f $PATH_TO_STATS/areas/input

# add fences to db
query "$STATS_DB" "delete from geofences where type = 'mon'"
for file in "$PATH_TO_STATS"areas/*.mad
do
#  echo "$file"
  source $file
  FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
  AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)
  POLY="st_geomfromtext('POLYGON(( $POLYGON ))')"
  query "$STATS_DB" "insert ignore into geofences (area,fence,type,coords) values ('$AREANAME', '$FENCENAME', 'mon', $POLY)"
done


# recreate mon_mitm 15/60/1440 area files
  rm -f $PATH_TO_STATS/cron_files/15*_area.sql
  rm -f $PATH_TO_STATS/cron_files/60*_area.sql
  rm -f $PATH_TO_STATS/cron_files/1440*_area.sql
  for area in "$PATH_TO_STATS"areas/*.mad
  do
    echo "$area"
    source $area
    FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
    AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)
    cp $PATH_TO_STATS/default_files/15_area.sql.default $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Alphen/$AREA_NAME/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Fency/$FENCE_NAME/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/FENCE_COORDS/$POLYGON/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area.sql
    cp $PATH_TO_STATS/default_files/60_area.sql.default $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Alphen/$AREA_NAME/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Fency/$FENCE_NAME/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/FENCE_COORDS/$POLYGON/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area.sql
    cp $PATH_TO_STATS/default_files/1440_area.sql.default $PATH_TO_STATS/cron_files/1440_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Alphen/$AREA_NAME/g" $PATH_TO_STATS/cron_files/1440_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/Fency/$FENCE_NAME/g" $PATH_TO_STATS/cron_files/1440_"$AREANAME"_"$FENCENAME"_area.sql
    sed -i "s/FENCE_COORDS/$POLYGON/g" $PATH_TO_STATS/cron_files/1440_"$AREANAME"_"$FENCENAME"_area.sql
  done

  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] Fence update pokemon areas" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
fi


# Create pokestop area files based on MAD fences
if [[ "$FENCE" == "MAD" ]]
then
questareas=$(query "$MAD_DB" "select count(*) from settings_geofence where geofence_id in (select geofence_included from settings_area_pokestops where level = 0);")
  if [ $questareas = 0 ]
  then
  echo "no quest areas defined, skip processing"
  else
  echo "$questareas Quest areas found, creating fencesfrom MADdb"
  echo ""
  start=$(date '+%Y%m%d %H:%M:%S')
  rm -f $PATH_TO_STATS/areas/*.quest

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
  rm -f $PATH_TO_STATS/areas/input_quest

# add fences to db
query "$STATS_DB" "delete from geofences where type = 'quest'"
for file in "$PATH_TO_STATS"areas/*.mad
do
#  echo "$file"
  source $file
  FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
  AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)
  POLY="st_geomfromtext('POLYGON(( $POLYGON ))')"
  query "$STATS_DB" "insert ignore into geofences (area,fence,type,coords) values ('$AREANAME', '$FENCENAME', 'quest', $POLY)"
done

# create quest area RPL 15+60 files
  rm -f $PATH_TO_STATS/cron_files/15*_area_quest.sql
  rm -f $PATH_TO_STATS/cron_files/60*_area_quest.sql
  rm -f $PATH_TO_STATS/cron_files/60_area_quest.sql
  for area in "$PATH_TO_STATS"areas/*.quest
  do
    echo "$area"
    source $area
    FENCENAME=$(echo $FENCE_NAME | sed s/' '/_/g)
    AREANAME=$(echo $AREA_NAME | sed s/' '/_/g)
    cp $PATH_TO_STATS/default_files/15_area_quest.sql.default $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/Alphen/$AREA_NAME/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/Fency/$FENCE_NAME/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/FENCE_COORDS/$POLYGON/g" $PATH_TO_STATS/cron_files/15_"$AREANAME"_"$FENCENAME"_area_quest.sql
    cp $PATH_TO_STATS/default_files/60_area_quest.sql.default $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/Alphen/$AREA_NAME/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/Fency/$FENCE_NAME/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area_quest.sql
    sed -i "s/FENCE_COORDS/$POLYGON/g" $PATH_TO_STATS/cron_files/60_"$AREANAME"_"$FENCENAME"_area_quest.sql
  done

stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Fence update quest areas" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log


#adjust for scanner type
    if [ -z ${vmad+x} ]
    then
      sed -i "s/-- yy //g" $PATH_TO_STATS/cron_files/*_area_quest.sql
    else
      sed -i "s/-- xx //g" $PATH_TO_STATS/cron_files/*_area_quest.sql
    fi
  fi
fi

# adjust databases
cp $PATH_TO_STATS/default_files/10080_area.sql.default $PATH_TO_STATS/cron_files/10080_area.sql
sed -i "s/pogodb/$STATS_DB/g" $PATH_TO_STATS/cron_files/*_area.sql
sed -i "s/rmdb/$MAD_DB/g" $PATH_TO_STATS/cron_files/*_area.sql
sed -i "s/pogodb/$STATS_DB/g" $PATH_TO_STATS/cron_files/*_area_quest.sql
sed -i "s/rmdb/$MAD_DB/g" $PATH_TO_STATS/cron_files/*_area_quest.sql

# Add area files for unfenced data
cp $PATH_TO_STATS/default_files/15_area_unfenced.sql.default $PATH_TO_STATS/cron_files/15_ZZZZZ_Unfenced_area.sql
cp $PATH_TO_STATS/default_files/60_area_unfenced.sql.default $PATH_TO_STATS/cron_files/60_ZZZZZ_Unfenced_area.sql
cp $PATH_TO_STATS/default_files/1440_area_unfenced.sql.default $PATH_TO_STATS/cron_files/1440_ZZZZZ_Unfenced_area.sql
sed -i "s/pogodb/$STATS_DB/g" $PATH_TO_STATS/cron_files/*_Unfenced_area.sql
sed -i "s/rmdb/$MAD_DB/g" $PATH_TO_STATS/cron_files/*_Unfenced_area.sql

# Append new devices to table Area
if [[ "$FENCE" == "MAD" ]] && [[ "$MAD_DEVICE_INSERT" == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  echo "Append new devices and areas to table Area"
  if [ -z "$SQL_password" ]
  then
    query "$STATS_DB" "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a LEFT JOIN $STATS_DB.device b ON a.Origin = b.Origin SET a.Area = b.Area; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Device update table Area" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  else
    query "$STATS_DB" "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a LEFT JOIN $STATS_DB.device b ON a.Origin = b.Origin SET a.Area = b.Area; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
    stop=$(date '+%Y%m%d %H:%M:%S')
    diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
    echo "[$start] [$stop] [$diff] Device update table Area" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
  fi
fi
