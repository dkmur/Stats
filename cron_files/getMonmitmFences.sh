#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if [ -z "$SQL_password" ]
  then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $MAD_DB -N -e "SELECT LEFT(fence_data,length(fence_data)-1) from settings_geofence where geofence_id in (select geofence_included from settings_area_mon_mitm);" | sed 's/\[\"\[/[/g' | sed 's/",/\n/g' | sed 's/"//g' | sed 's/^ //g' > $folder/monmitmfences.txt
  else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $MAD_DB -N -e "SELECT LEFT(fence_data,length(fence_data)-1) from settings_geofence where geofence_id in (select geofence_included from settings_area_mon_mitm);" | sed 's/\[\"\[/[/g' | sed 's/",/\n/g' | sed 's/"//g' | sed 's/^ //g' > $folder/monmitmfences.txt
fi

PRE_TEXT="NOT ( "
MID_TEXT=" OR st_contains(st_geomfromtext('POLYGON(("
POST_TEXT="))'), point(latitude, longitude))"

IFS=[;
for i in `cat $folder/monmitmfences.txt`;
do
   echo $i | grep -v "\[" | while read -r line;
      do
         echo -n $line | sed s/.*]/$MID_TEXT/ | sed s/".*]"/$MID_TEXT/ | sed s/,/' '/g
         echo -n ", "
      done
      echo -n $i | tail +2 | head -1 | sed s/,/' '/g | sed s/$/$POST_TEXT/g
done | sed s/",  OR"/$PRE_TEXT/g | sed s/"(,"/"("/g | sed s/", ,"/,/g | tr -d '\n'
echo -n "));"
unset IFS
