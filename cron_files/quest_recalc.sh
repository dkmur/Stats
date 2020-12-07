#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

## recalculate Quest routes for instance 1
if [ -z "$MAD_instance_name_1" ]; then
        echo ""
	echo "No MAD instance defined"
else
        echo ""
	echo "Start recalculation Quest routes for instance 1"

        query(){
        mysql  -u$DB_user -p$DB_pass -NB -h$DB_IP -P$DB_PORT $MAD_db -e "$1;"
        }
        while read -r area_id _ ;do
	echo Recalculating area_id: $area_id
	curl -s -u $MADmin_username_1:$MADmin_password_1 -H 'Content-Type: application/json-rpc' -d '{"call": "recalculate"}' $MAD_url_1/api/area/$area_id
        echo Sleeping $quest_recalc_wait
	echo ""
	sleep $quest_recalc_wait
	done < <(query "select a.area_id from settings_area_pokestops a, settings_area b, madmin_instance c where a.area_id = b.area_id and b.instance_id = c.instance_id and a.route_calc_algorithm = 'route' and c.name = '$MAD_instance_name_1';")
fi

## recalculate Quest routes for instance 2
if [ -z "$MAD_instance_name_2" ]; then
        echo ""
        echo "No 2nd MAD instance defined"
else
        echo ""
        echo "Start recalculation Quest routes for instance 2"

        query(){
        mysql  -u$DB_user -p$DB_pass -NB -h$DB_IP -P$DB_PORT $MAD_db -e "$1;"
        }
        while read -r area_id _ ;do
        echo Recalculating area_id: $area_id
        curl -s -u $MADmin_username_2:$MADmin_password_2 -H 'Content-Type: application/json-rpc' -d '{"call": "recalculate"}' $MAD_url_2/api/area/$area_id
        echo Sleeping $quest_recalc_wait
        echo ""
        sleep $quest_recalc_wait
	done < <(query "select a.area_id from settings_area_pokestops a, settings_area b, madmin_instance c where a.area_id = b.area_id and b.instance_id = c.instance_id and a.route_calc_algorithm = 'route' and c.name = '$MAD_instance_name_2';")
fi

## recalculate Quest routes for instance 3
if [ -z "$MAD_instance_name_3" ]; then
        echo ""
        echo "No 3rd MAD instance defined"
else
        echo ""
        echo "Start recalculation Quest routes for instance 3"

        query(){
        mysql  -u$DB_user -p$DB_pass -NB -h$DB_IP -P$DB_PORT $MAD_db -e "$1;"
        }
        while read -r area_id _ ;do
        echo Recalculating area_id: $area_id
        curl -s -u $MADmin_username_3:$MADmin_password_3 -H 'Content-Type: application/json-rpc' -d '{"call": "recalculate"}' $MAD_url_3/api/area/$area_id
        echo Sleeping $quest_recalc_wait
        echo ""
        sleep $quest_recalc_wait
        done < <(query "select a.area_id from settings_area_pokestops a, settings_area b, madmin_instance c where a.area_id = b.area_id and b.instance_id = c.instance_id and a.route_calc_algorithm = 'route' and c.name = '$MAD_instance_name_3';")
fi

## recalculate Quest routes for instance 4
if [ -z "$MAD_instance_name_4" ]; then
        echo ""
        echo "No 4th MAD instance defined"
else
        echo ""
        echo "Start recalculation Quest routes for instance 4"

        query(){
        mysql  -u$DB_user -p$DB_pass -NB -h$DB_IP -P$DB_PORT $MAD_db -e "$1;"
        }
        while read -r area_id _ ;do
        echo Recalculating area_id: $area_id
        curl -s -u $MADmin_username_4:$MADmin_password_4 -H 'Content-Type: application/json-rpc' -d '{"call": "recalculate"}' $MAD_url_4/api/area/$area_id
        echo Sleeping $quest_recalc_wait
        echo ""
        sleep $quest_recalc_wait
        done < <(query "select a.area_id from settings_area_pokestops a, settings_area b, madmin_instance c where a.area_id = b.area_id and b.instance_id = c.instance_id and a.route_calc_algorithm = 'route' and c.name = '$MAD_instance_name_4';")
fi

## recalculate Quest routes for instance 5
if [ -z "$MAD_instance_name_5" ]; then
        echo ""
        echo "No 5th MAD instance defined"
else
        echo ""
        echo "Start recalculation Quest routes for instance 5"

        query(){
        mysql  -u$DB_user -p$DB_pass -NB -h$DB_IP -P$DB_PORT $MAD_db -e "$1;"
        }
        while read -r area_id _ ;do
        echo Recalculating area_id: $area_id
        curl -s -u $MADmin_username_5:$MADmin_password_5 -H 'Content-Type: application/json-rpc' -d '{"call": "recalculate"}' $MAD_url_5/api/area/$area_id
        echo Sleeping $quest_recalc_wait
        echo ""
        sleep $quest_recalc_wait
        done < <(query "select a.area_id from settings_area_pokestops a, settings_area b, madmin_instance c where a.area_id = b.area_id and b.instance_id = c.instance_id and a.route_calc_algorithm = 'route' and c.name = '$MAD_instance_name_5';")
fi
