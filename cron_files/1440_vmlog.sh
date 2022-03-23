#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if [[ $vmad != "true" ||  $vmlog != "true" ]]
then
  exit
fi

mkdir -p $folder/tmp

process_date_vmc=$(date -d '1 day ago' +%Y"-"%m"-"%d)
process_date_vm=$(date -d '1 day ago' +%-m"/"%-d"/"%y)

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


doit(){
echo ""
echo "Processing vm logs for instance: $MAD_instance"
echo ""

# get the logs
while read -r origin ;do
echo "Processing $origin"
rm -f $folder/tmp/logcat_$origin.zip
curl --silent  --show-error --fail -J -L -o $folder/tmp/logcat_$origin.zip -u $MADmin_user:$MADmin_pass "$MADmin_url/download_logcat?origin=$origin"
rm -f $folder/tmp/logcat.txt
rm -f $folder/tmp/vm.log
rm -f $folder/tmp/vmapper.log
unzip -q $folder/tmp/logcat_$origin.zip -d $folder/tmp/
rm -f $folder/tmp/logcat_$origin.zip

# processing logs
vmc_reboot="$(grep $process_date_vmc $folder/tmp/vm.log | grep 'Device rebooted' | wc -l)"
vm_patcher_restart="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Patcher (re)started' | wc -l)"
vm_pogo_restart="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Restarting game' | wc -l)"
vm_crash_dialog="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Found crash dialog' | wc -l)"
vm_injection="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Injection successful' | wc -l)"
vm_injectTimeout="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Injection timeout' | wc -l)"
vm_consent="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'consent dialog' | wc -l)"
vm_ws_stop_pogo="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'WS: stopped app' | wc -l)"
vm_ws_start_pogo="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'WS: started' | wc -l)"
vm_authStart="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Starting authentication' | wc -l)"
vm_authSuccess="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Authentication was successful' | wc -l)"
vm_authFailed="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'Login failed' | wc -l)"
vm_Gtoken="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'New Google auth token is needed' | wc -l)"
vm_Ptoken="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'New PTC auth token is needed' | wc -l)"
vm_PtokenMaster="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'New PTC master token is needed' | wc -l)"
vm_died="$(grep $process_date_vm $folder/tmp/vmapper.log | grep 'The service died. We will restart' | wc -l)"
acc_level="$(grep 'VM_API_Bag: Level' $folder/tmp/logcat.txt | tail -n1 | awk '{ print $NF }')"
acc_xp="$(grep 'VM_API_Bag: XP' $folder/tmp/logcat.txt | tail -n1 | awk '{ print $NF }')"
acc_stop="$(grep 'VM_API_Bag: Stops spun' $folder/tmp/logcat.txt | tail -n1 | awk '{ print $NF }')"
acc_mon="$(grep 'VM_API_Bag: Mons caught' $folder/tmp/logcat.txt | tail -n1 | awk '{ print $NF }')"
acc_item="$(grep 'VM_API_Bag: Total item count' $folder/tmp/logcat.txt | tail -n1 | awk '{ print $NF }')"

# update db
query "$STATS_DB" "update vmlog set vmc_reboot='$vmc_reboot', vm_patcher_restart='$vm_patcher_restart', vm_pogo_restart='$vm_pogo_restart', vm_crash_dialog='$vm_crash_dialog', vm_injection='$vm_injection', vm_consent='$vm_consent', vm_ws_stop_pogo='$vm_ws_stop_pogo', vm_ws_start_pogo='$vm_ws_start_pogo',acc_level='$acc_level', acc_xp='$acc_xp', acc_stop='$acc_stop',acc_mon='$acc_mon', acc_item='$acc_item', vm_injectTimeout='$vm_injectTimeout', vm_authStart='$vm_authStart', vm_authSuccess='$vm_authSuccess', vm_authFailed='$vm_authFailed', vm_Gtoken='$vm_Gtoken', vm_Ptoken='$vm_Ptoken', vm_PtokenMaster='$vm_PtokenMaster', vm_died='$vm_died'  where Origin = '$origin' and datetime = concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 86400) * 86400));"

done < <(query "$MAD_DB" "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance';")
}

#echo $process_date_vmc
#echo $process_date_vm


## Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
start=$(date '+%Y%m%d %H:%M:%S')

## Initial insert of origins
query "$STATS_DB" "insert ignore into vmlog (datetime,Origin,RPL,instance) select concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 86400) * 86400)), a.name , '1440', b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"

## run job for instance 1
if [ -z "$MAD_path_1" ]; then
  echo ""
  echo "No instance defined"
else
  MAD_instance=$MAD_instance_name_1
  MADmin_user=$MADmin_username_1
  MADmin_pass=$MADmin_password_1
  MADmin_url=$MAD_url_1
  doit
fi

## run job for instance 2
if [ -z "$MAD_path_2" ]; then
  echo ""
  echo "No 2nd instance defined"
else
  MAD_instance=$MAD_instance_name_2
  MADmin_user=$MADmin_username_2
  MADmin_pass=$MADmin_password_2
  MADmin_url=$MAD_url_2
  doit
fi

## run job for instance 3
if [ -z "$MAD_path_3" ]; then
  echo ""
  echo "No 3rd instance defined"
else
  MAD_instance=$MAD_instance_name_3
  MADmin_user=$MADmin_username_3
  MADmin_pass=$MADmin_password_3
  MADmin_url=$MAD_url_3
  doit
fi

## run job for instance 4
if [ -z "$MAD_path_4" ]; then
  echo ""
  echo "No 4th instance defined"
else
  MAD_instance=$MAD_instance_name_4
  MADmin_user=$MADmin_username_4
  MADmin_pass=$MADmin_password_4
  MADmin_url=$MAD_url_4
  doit
fi

## run job for instance 5
if [ -z "$MAD_path_5" ]; then
  echo ""
  echo "No 5th instance defined"
else
  MAD_instance=$MAD_instance_name_5
  MADmin_user=$MADmin_username_5
  MADmin_pass=$MADmin_password_5
  MADmin_url=$MAD_url_5
  doit
fi

## run job for instance 6
if [ -z "$MAD_path_6" ]; then
  echo ""
  echo "No 6th instance defined"
else
  MAD_instance=$MAD_instance_name_6
  MADmin_user=$MADmin_username_6
  MADmin_pass=$MADmin_password_6
  MADmin_url=$MAD_url_6
  doit
fi

## run job for instance 7
if [ -z "$MAD_path_7" ]; then
  echo ""
  echo "No 7th instance defined"
else
  MAD_instance=$MAD_instance_name_7
  MADmin_user=$MADmin_username_7
  MADmin_pass=$MADmin_password_7
  MADmin_url=$MAD_url_7
  doit
fi

echo ""
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] Stats rpl1440 vm log processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "All done!"
