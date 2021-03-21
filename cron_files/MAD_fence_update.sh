#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Update MAD fences and re-create area files
if [[ "$FENCE" == "MAD" ]]
then
  echo "Re-creating MAD fence config and area files"
  rm -f $PATH_TO_STATS/areas/*.mad

# get MAD fence data
  if [ -z "$SQL_password" ]
  then
        query(){
        mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -e "$1;"
        }
  else
        query(){
        mysql -NB -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -e "$1;"
        }
  fi
        while read -r geofence_id name;
        do

        query "SELECT LEFT(fence_data,length(fence_data)-1) from settings_geofence where geofence_id = $geofence_id;" | sed 's/\[\"\[/[/g' | sed 's/",/\n/g' | sed 's/"//g' | sed 's/^ //g' | sed 's/\[/§\[/g' > $PATH_TO_STATS/areas/input


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

        done < <(query "$(cat << EOF
        select geofence_id, name from settings_geofence where geofence_id in (select geofence_included from settings_area_mon_mitm);
EOF
        )")
  rm -f $PATH_TO_STATS/areas/input

# recreate 15/60/1440 area files
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
fi

# adjust databases
cp $PATH_TO_STATS/default_files/10080_area.sql.default $PATH_TO_STATS/cron_files/10080_area.sql
sed -i "s/pogodb/$STATS_DB/g" $PATH_TO_STATS/cron_files/*_area.sql
sed -i "s/rmdb/$MAD_DB/g" $PATH_TO_STATS/cron_files/*_area.sql

# Add area files for unfenced data
cp $PATH_TO_STATS/default_files/15_area_unfenced.sql.default $PATH_TO_STATS/cron_files/15_ZZZZZ_Unfenced_area.sql
cp $PATH_TO_STATS/default_files/60_area_unfenced.sql.default $PATH_TO_STATS/cron_files/60_ZZZZZ_Unfenced_area.sql
cp $PATH_TO_STATS/default_files/1440_area_unfenced.sql.default $PATH_TO_STATS/cron_files/1440_ZZZZZ_Unfenced_area.sql
sed -i "s/pogodb/$STATS_DB/g" $PATH_TO_STATS/cron_files/*_Unfenced_area.sql
sed -i "s/rmdb/$MAD_DB/g" $PATH_TO_STATS/cron_files/*_Unfenced_area.sql

# Append new devices to table Area
if [[ "$FENCE" == "MAD" ]] && [[ "$MAD_DEVICE_INSERT" == "true" ]]
then
  echo "Append new devices and areas to table Area"
  if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a LEFT JOIN $STATS_DB.device b ON a.Origin = b.Origin SET a.Area = b.Area; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "CREATE TEMPORARY TABLE $STATS_DB.device AS(SELECT a.name as 'Area', f.name as 'Origin' FROM $MAD_DB.settings_geofence a, $MAD_DB.settings_area_mon_mitm b, $MAD_DB.settings_walkerarea d, $MAD_DB.settings_walker_to_walkerarea e, $MAD_DB.settings_device f WHERE a.geofence_id = b.geofence_included and b.area_id = d.area_id and d.walkerarea_id = e.walkerarea_id and e.walker_id = f.walker_id GROUP BY f.name, b.geofence_included); UPDATE $STATS_DB.Area a LEFT JOIN $STATS_DB.device b ON a.Origin = b.Origin SET a.Area = b.Area; INSERT IGNORE INTO $STATS_DB.Area SELECT * from $STATS_DB.device; DROP TABLE $STATS_DB.device;"
  fi
fi
