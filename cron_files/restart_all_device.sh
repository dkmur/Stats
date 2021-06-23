#!/bin/bash

if [ -z "$STY" ]; then exec screen -dm -S allDeviceReboot /bin/bash "$0"; fi

folder="$(cd ../ && pwd)"
source $folder/config.ini

reboot_wait=90s

## reboot devices for instance 1
if [ -z "$MAD_path_1" ]; then
        echo ""
	echo "No instance defined"
else
	echo "Rebooting devices from instance 1"
	echo ""
        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $MAD_DB -e "$1;"
        }
        while read -r name _ ;do
	curl -u $MADmin_username_1:$MADmin_password_1 "$MAD_url_1/restart_phone?origin=$name&adb=False"
        echo ""
	echo "Rebooted $name"
	echo "wait timer started, $reboot_wait"
	echo ""
	sleep $reboot_wait
        done < <(query "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance_name_1';")
fi

## reboot devices for instance 2
if [ -z "$MAD_path_2" ]; then
        echo ""
        echo "No 2nd instance defined"
else
        echo "Rebooting devices from instance 2"
        echo ""
        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $MAD_DB -e "$1;"
        }
        while read -r name _ ;do
        curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_2/restart_phone?origin=$name&adb=False"
        echo ""
        echo "Rebooted $name"
        echo "wait timer started, $reboot_wait"
        echo ""
        sleep $reboot_wait
        done < <(query "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance_name_2';")
fi

## reboot devices for instance 3
if [ -z "$MAD_path_3" ]; then
        echo ""
        echo "No 3rd instance defined"
else
        echo "Rebooting devices from instance 3"
        echo ""
        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $MAD_DB -e "$1;"
        }
        while read -r name _ ;do
        curl -u $MADmin_username_3:$MADmin_password_3 "$MAD_url_3/restart_phone?origin=$name&adb=False"
        echo ""
        echo "Rebooted $name"
        echo "wait timer started, $reboot_wait"
        echo ""
        sleep $reboot_wait
        done < <(query "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance_name_3';")
fi

## reboot devices for instance 4
if [ -z "$MAD_path_4" ]; then
        echo ""
        echo "No 4th instance defined"
else
        echo "Rebooting devices from instance 4"
        echo ""
        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $MAD_DB -e "$1;"
        }
        while read -r name _ ;do
        curl -u $MADmin_username_4:$MADmin_password_4 "$MAD_url_4/restart_phone?origin=$name&adb=False"
        echo ""
        echo "Rebooted $name"
        echo "wait timer started, $reboot_wait"
        echo ""
        sleep $reboot_wait
        done < <(query "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance_name_4';")
fi

## reboot devices for instance 5
if [ -z "$MAD_path_5" ]; then
        echo ""
        echo "No 5th instance defined"
else
        echo "Rebooting devices from instance 5"
        echo ""
        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $MAD_DB -e "$1;"
        }
        while read -r name _ ;do
        curl -u $MADmin_username_5:$MADmin_password_5 "$MAD_url_5/restart_phone?origin=$name&adb=False"
        echo ""
        echo "Rebooted $name"
        echo "wait timer started, $reboot_wait"
        echo ""
        sleep $reboot_wait
        done < <(query "select a.name from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance_name_5';")
fi

echo ""
echo "All done !!"
