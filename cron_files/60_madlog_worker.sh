#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "`date '+%Y%m%d %H:%M:%S'` Hourly MAD log processing worker level started" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log

## update db for instance 1
if [ -z "$MAD_path_1" ]; then
        echo ""
        echo "No instance defined"
else
        echo "Inserting all origins into tables"
        echo ""
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into warning_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into error_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        echo ""
        echo "Processing MAD logs for $MAD_instance_name_1 workers"

        query(){
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -NB -e "$1;"
        }
        while read -r origin _ ;do
	# Errors
	errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
	failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
	oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
	originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
	wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
	killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
	wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
	killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
	killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
	noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
	tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

	# warnings
	warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | wc -l)"
	failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Worker failed to retrieve proper data' | wc -l)"
	manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Too many timeouts' | wc -l)"
	frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Screen is frozen' | wc -l)"
	wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Timeout, increasing timeout-counter' | wc -l)"
	wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Connection' | grep 'closed' | wc -l)"
	noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Not injected in time - reboot' | wc -l)"
	noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed restarting PoGo - reboot device' | wc -l)"
	failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed retrieving screenshot' | wc -l)"
	noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'No PTC Accounts' | wc -l)"
	failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed getting the topmost app' | wc -l)"
	pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Restarting PoGo failed - reboot device' | wc -l)"
	screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
	failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed clearing box' | wc -l)"
	itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Deletion not confirmed' | wc -l)"
	noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Cannot find any active area defined for current time' | wc -l)"
	noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Could not get to Mainscreen' | wc -l)"
	noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'has not accessed a location in 500 seconds' | wc -l)"
	noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'has not been processed thrice in a row' | wc -l)"
	failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
	softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Softban' | wc -l)"
	questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed getting quest but got items' | wc -l)"
	foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Tried to open a stop but found a gym instead' | wc -l)"
	noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Failed to find a walker configuration' | wc -l)"
	noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
	failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
	noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Could not login again' | wc -l)"
	failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Worker failed running post_move_location_routine' | wc -l)"
	inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'In game error detected' | wc -l)"
	gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'Detected GPS error - reboot device' | wc -l)"
	pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep "$origin" | grep 'PoGo is not opened! Current topmost app' | wc -l)"

	echo "updating db"
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE error_worker SET errors='$errors',failedPogoStop='$failedPogoStop',oldConnection='$oldConnection',originTimeout='$originTimeout',wsLost='$wsLost',killPogoWait='$killPogoWait',wokerInitFail='$wokerInitFail',killInjection='$killInjection',killSleep='$killSleep',noItemDelete='$noItemDelete',tesseract='$tesseract' where Origin='$origin' and instance='$MAD_instance_name_1' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE warning_worker SET warns='$warns',failedData='$failedData',manyTimeOut='$manyTimeOut',frozenScreen='$frozenScreen',wsTimeout='$wsTimeout',wsConnClosed='$wsConnClosed',noInject='$noInject',noPogoStart='$noPogoStart',failedScreenshot='$failedScreenshot',noPTC='$noPTC',failedTopApp='$failedTopApp',pogoRestartFail='$pogoRestartFail',screenFailure='$screenFailure',failedBoxClear='$failedBoxClear',itemDelUnknown='$itemDelUnknown',noActiveArea='$noActiveArea',noMainScreen='$noMainScreen',noLocAccess='$noLocAccess',noStopProcess='$noStopProcess',failStopOpen='$failStopOpen',softban='$softban',questFull='$questFull',foundGym='$foundGym',noWalkerConfig='$noWalkerConfig',noStop='$noStop',failStopSpin='$failStopSpin',noLogin='$noLogin',failPostMove='$failPostMove',inGameError='$inGameError',gpsError='$gpsError',pogoNotOpen='$pogoNotOpen'  where Origin='$origin' and instance='$MAD_instance_name_1' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        done < <(query "select origin FROM warning_worker where RPL = 60 and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600) and instance='$MAD_instance_name_1';")
fi


## update db for instance 2
if [ -z "$MAD_path_2" ]; then
        echo ""
        echo "No 2nd instance defined"
else
        echo "Inserting all origins into tables"
        echo ""
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into warning_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into error_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        echo ""
        echo "Processing MAD logs for $MAD_instance_name_2 workers"

        query(){
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -NB -e "$1;"
        }
        while read -r origin _ ;do
        # Errors
        errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
        failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
        oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
        originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
        wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
        killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
        wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
        killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
        killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
        noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
        tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

        # warnings
        warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | wc -l)"
        failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Worker failed to retrieve proper data' | wc -l)"
        manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Too many timeouts' | wc -l)"
        frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Screen is frozen' | wc -l)"
        wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Timeout, increasing timeout-counter' | wc -l)"
        wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Connection' | grep 'closed' | wc -l)"
        noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Not injected in time - reboot' | wc -l)"
        noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed restarting PoGo - reboot device' | wc -l)"
        failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed retrieving screenshot' | wc -l)"
        noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'No PTC Accounts' | wc -l)"
        failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed getting the topmost app' | wc -l)"
        pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Restarting PoGo failed - reboot device' | wc -l)"
        screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
        failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed clearing box' | wc -l)"
        itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Deletion not confirmed' | wc -l)"
        noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Cannot find any active area defined for current time' | wc -l)"
        noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Could not get to Mainscreen' | wc -l)"
        noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'has not accessed a location in 500 seconds' | wc -l)"
        noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'has not been processed thrice in a row' | wc -l)"
        failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
        softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Softban' | wc -l)"
        questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed getting quest but got items' | wc -l)"
        foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Tried to open a stop but found a gym instead' | wc -l)"
        noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Failed to find a walker configuration' | wc -l)"
        noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
        failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
        noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Could not login again' | wc -l)"
        failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Worker failed running post_move_location_routine' | wc -l)"
        inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'In game error detected' | wc -l)"
        gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'Detected GPS error - reboot device' | wc -l)"
        pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep "$origin" | grep 'PoGo is not opened! Current topmost app' | wc -l)"

        echo "updating db"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE error_worker SET errors='$errors',failedPogoStop='$failedPogoStop',oldConnection='$oldConnection',originTimeout='$originTimeout',wsLost='$wsLost',killPogoWait='$killPogoWait',wokerInitFail='$wokerInitFail',killInjection='$killInjection',killSleep='$killSleep',noItemDelete='$noItemDelete',tesseract='$tesseract' where Origin='$origin' and instance='$MAD_instance_name_2' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE warning_worker SET warns='$warns',failedData='$failedData',manyTimeOut='$manyTimeOut',frozenScreen='$frozenScreen',wsTimeout='$wsTimeout',wsConnClosed='$wsConnClosed',noInject='$noInject',noPogoStart='$noPogoStart',failedScreenshot='$failedScreenshot',noPTC='$noPTC',failedTopApp='$failedTopApp',pogoRestartFail='$pogoRestartFail',screenFailure='$screenFailure',failedBoxClear='$failedBoxClear',itemDelUnknown='$itemDelUnknown',noActiveArea='$noActiveArea',noMainScreen='$noMainScreen',noLocAccess='$noLocAccess',noStopProcess='$noStopProcess',failStopOpen='$failStopOpen',softban='$softban',questFull='$questFull',foundGym='$foundGym',noWalkerConfig='$noWalkerConfig',noStop='$noStop',failStopSpin='$failStopSpin',noLogin='$noLogin',failPostMove='$failPostMove',inGameError='$inGameError',gpsError='$gpsError',pogoNotOpen='$pogoNotOpen'  where Origin='$origin' and instance='$MAD_instance_name_2' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        done < <(query "select origin FROM warning_worker where RPL = 60 and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600) and instance='$MAD_instance_name_2';")
fi

## update db for instance 3
if [ -z "$MAD_path_3" ]; then
        echo ""
        echo "No 3rd instance defined"
else
        echo "Inserting all origins into tables"
        echo ""
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into warning_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into error_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        echo ""
        echo "Processing MAD logs for $MAD_instance_name_3 workers"

        query(){
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -NB -e "$1;"
        }
        while read -r origin _ ;do
        # Errors
        errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
        failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
        oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
        originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
        wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
        killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
        wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
        killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
        killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
        noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
        tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

        # warnings
        warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | wc -l)"
        failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Worker failed to retrieve proper data' | wc -l)"
        manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Too many timeouts' | wc -l)"
        frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Screen is frozen' | wc -l)"
        wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Timeout, increasing timeout-counter' | wc -l)"
        wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Connection' | grep 'closed' | wc -l)"
        noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Not injected in time - reboot' | wc -l)"
        noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed restarting PoGo - reboot device' | wc -l)"
        failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed retrieving screenshot' | wc -l)"
        noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'No PTC Accounts' | wc -l)"
        failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed getting the topmost app' | wc -l)"
        pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Restarting PoGo failed - reboot device' | wc -l)"
        screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
        failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed clearing box' | wc -l)"
        itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Deletion not confirmed' | wc -l)"
        noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Cannot find any active area defined for current time' | wc -l)"
        noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Could not get to Mainscreen' | wc -l)"
        noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'has not accessed a location in 500 seconds' | wc -l)"
        noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'has not been processed thrice in a row' | wc -l)"
        failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
        softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Softban' | wc -l)"
        questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed getting quest but got items' | wc -l)"
        foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Tried to open a stop but found a gym instead' | wc -l)"
        noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Failed to find a walker configuration' | wc -l)"
        noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
        failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
        noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Could not login again' | wc -l)"
        failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Worker failed running post_move_location_routine' | wc -l)"
        inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'In game error detected' | wc -l)"
        gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'Detected GPS error - reboot device' | wc -l)"
        pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep "$origin" | grep 'PoGo is not opened! Current topmost app' | wc -l)"

        echo "updating db"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE error_worker SET errors='$errors',failedPogoStop='$failedPogoStop',oldConnection='$oldConnection',originTimeout='$originTimeout',wsLost='$wsLost',killPogoWait='$killPogoWait',wokerInitFail='$wokerInitFail',killInjection='$killInjection',killSleep='$killSleep',noItemDelete='$noItemDelete',tesseract='$tesseract' where Origin='$origin' and instance='$MAD_instance_name_3' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE warning_worker SET warns='$warns',failedData='$failedData',manyTimeOut='$manyTimeOut',frozenScreen='$frozenScreen',wsTimeout='$wsTimeout',wsConnClosed='$wsConnClosed',noInject='$noInject',noPogoStart='$noPogoStart',failedScreenshot='$failedScreenshot',noPTC='$noPTC',failedTopApp='$failedTopApp',pogoRestartFail='$pogoRestartFail',screenFailure='$screenFailure',failedBoxClear='$failedBoxClear',itemDelUnknown='$itemDelUnknown',noActiveArea='$noActiveArea',noMainScreen='$noMainScreen',noLocAccess='$noLocAccess',noStopProcess='$noStopProcess',failStopOpen='$failStopOpen',softban='$softban',questFull='$questFull',foundGym='$foundGym',noWalkerConfig='$noWalkerConfig',noStop='$noStop',failStopSpin='$failStopSpin',noLogin='$noLogin',failPostMove='$failPostMove',inGameError='$inGameError',gpsError='$gpsError',pogoNotOpen='$pogoNotOpen'  where Origin='$origin' and instance='$MAD_instance_name_3' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        done < <(query "select origin FROM warning_worker where RPL = 60 and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600) and instance='$MAD_instance_name_3';")
fi

## update db for instance 4
if [ -z "$MAD_path_4" ]; then
        echo ""
        echo "No 4th instance defined"
else
        echo "Inserting all origins into tables"
        echo ""
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into warning_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into error_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        echo ""
        echo "Processing MAD logs for $MAD_instance_name_4 workers"

        query(){
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -NB -e "$1;"
        }
        while read -r origin _ ;do
        # Errors
        errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
        failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
        oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
        originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
        wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
        killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
        wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
        killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
        killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
        noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
        tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

        # warnings
        warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | wc -l)"
        failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Worker failed to retrieve proper data' | wc -l)"
        manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Too many timeouts' | wc -l)"
        frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Screen is frozen' | wc -l)"
        wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Timeout, increasing timeout-counter' | wc -l)"
        wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Connection' | grep 'closed' | wc -l)"
        noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Not injected in time - reboot' | wc -l)"
        noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed restarting PoGo - reboot device' | wc -l)"
        failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed retrieving screenshot' | wc -l)"
        noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'No PTC Accounts' | wc -l)"
        failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed getting the topmost app' | wc -l)"
        pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Restarting PoGo failed - reboot device' | wc -l)"
        screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
        failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed clearing box' | wc -l)"
        itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Deletion not confirmed' | wc -l)"
        noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Cannot find any active area defined for current time' | wc -l)"
        noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Could not get to Mainscreen' | wc -l)"
        noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'has not accessed a location in 500 seconds' | wc -l)"
        noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'has not been processed thrice in a row' | wc -l)"
        failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
        softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Softban' | wc -l)"
        questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed getting quest but got items' | wc -l)"
        foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Tried to open a stop but found a gym instead' | wc -l)"
        noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Failed to find a walker configuration' | wc -l)"
        noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
        failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
        noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Could not login again' | wc -l)"
        failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Worker failed running post_move_location_routine' | wc -l)"
        inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'In game error detected' | wc -l)"
        gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'Detected GPS error - reboot device' | wc -l)"
        pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep "$origin" | grep 'PoGo is not opened! Current topmost app' | wc -l)"

        echo "updating db"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE error_worker SET errors='$errors',failedPogoStop='$failedPogoStop',oldConnection='$oldConnection',originTimeout='$originTimeout',wsLost='$wsLost',killPogoWait='$killPogoWait',wokerInitFail='$wokerInitFail',killInjection='$killInjection',killSleep='$killSleep',noItemDelete='$noItemDelete',tesseract='$tesseract' where Origin='$origin' and instance='$MAD_instance_name_4' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE warning_worker SET warns='$warns',failedData='$failedData',manyTimeOut='$manyTimeOut',frozenScreen='$frozenScreen',wsTimeout='$wsTimeout',wsConnClosed='$wsConnClosed',noInject='$noInject',noPogoStart='$noPogoStart',failedScreenshot='$failedScreenshot',noPTC='$noPTC',failedTopApp='$failedTopApp',pogoRestartFail='$pogoRestartFail',screenFailure='$screenFailure',failedBoxClear='$failedBoxClear',itemDelUnknown='$itemDelUnknown',noActiveArea='$noActiveArea',noMainScreen='$noMainScreen',noLocAccess='$noLocAccess',noStopProcess='$noStopProcess',failStopOpen='$failStopOpen',softban='$softban',questFull='$questFull',foundGym='$foundGym',noWalkerConfig='$noWalkerConfig',noStop='$noStop',failStopSpin='$failStopSpin',noLogin='$noLogin',failPostMove='$failPostMove',inGameError='$inGameError',gpsError='$gpsError',pogoNotOpen='$pogoNotOpen'  where Origin='$origin' and instance='$MAD_instance_name_4' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        done < <(query "select origin FROM warning_worker where RPL = 60 and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600) and instance='$MAD_instance_name_4';")
fi

## update db for instance 5
if [ -z "$MAD_path_5" ]; then
        echo ""
        echo "No 5th instance defined"
else
        echo "Inserting all origins into tables"
        echo ""
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into warning_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into error_worker (datetime,origin,RPL,instance) select SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600), a.name, 60, b.name from $MAD_DB.settings_device a, $MAD_DB.madmin_instance b where a.instance_id = b.instance_id;"
        echo ""
        echo "Processing MAD logs for $MAD_instance_name_5 workers"

        query(){
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -NB -e "$1;"
        }
        while read -r origin _ ;do
        # Errors
        errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
        failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
        oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
        originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
        wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
        killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
        wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
        killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
        killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
        noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
        tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

        # warnings
        warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | wc -l)"
        failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Worker failed to retrieve proper data' | wc -l)"
        manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Too many timeouts' | wc -l)"
        frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Screen is frozen' | wc -l)"
        wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Timeout, increasing timeout-counter' | wc -l)"
        wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Connection' | grep 'closed' | wc -l)"
        noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Not injected in time - reboot' | wc -l)"
        noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed restarting PoGo - reboot device' | wc -l)"
        failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed retrieving screenshot' | wc -l)"
        noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'No PTC Accounts' | wc -l)"
        failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed getting the topmost app' | wc -l)"
        pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Restarting PoGo failed - reboot device' | wc -l)"
        screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
        failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed clearing box' | wc -l)"
        itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Deletion not confirmed' | wc -l)"
        noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Cannot find any active area defined for current time' | wc -l)"
        noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Could not get to Mainscreen' | wc -l)"
        noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'has not accessed a location in 500 seconds' | wc -l)"
        noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'has not been processed thrice in a row' | wc -l)"
        failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
        softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Softban' | wc -l)"
        questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed getting quest but got items' | wc -l)"
        foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Tried to open a stop but found a gym instead' | wc -l)"
        noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Failed to find a walker configuration' | wc -l)"
        noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
        failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
        noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Could not login again' | wc -l)"
        failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Worker failed running post_move_location_routine' | wc -l)"
        inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'In game error detected' | wc -l)"
        gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'Detected GPS error - reboot device' | wc -l)"
        pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep "$origin" | grep 'PoGo is not opened! Current topmost app' | wc -l)"

        echo "updating db"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE error_worker SET errors='$errors',failedPogoStop='$failedPogoStop',oldConnection='$oldConnection',originTimeout='$originTimeout',wsLost='$wsLost',killPogoWait='$killPogoWait',wokerInitFail='$wokerInitFail',killInjection='$killInjection',killSleep='$killSleep',noItemDelete='$noItemDelete',tesseract='$tesseract' where Origin='$origin' and instance='$MAD_instance_name_5' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -e "UPDATE warning_worker SET warns='$warns',failedData='$failedData',manyTimeOut='$manyTimeOut',frozenScreen='$frozenScreen',wsTimeout='$wsTimeout',wsConnClosed='$wsConnClosed',noInject='$noInject',noPogoStart='$noPogoStart',failedScreenshot='$failedScreenshot',noPTC='$noPTC',failedTopApp='$failedTopApp',pogoRestartFail='$pogoRestartFail',screenFailure='$screenFailure',failedBoxClear='$failedBoxClear',itemDelUnknown='$itemDelUnknown',noActiveArea='$noActiveArea',noMainScreen='$noMainScreen',noLocAccess='$noLocAccess',noStopProcess='$noStopProcess',failStopOpen='$failStopOpen',softban='$softban',questFull='$questFull',foundGym='$foundGym',noWalkerConfig='$noWalkerConfig',noStop='$noStop',failStopSpin='$failStopSpin',noLogin='$noLogin',failPostMove='$failPostMove',inGameError='$inGameError',gpsError='$gpsError',pogoNotOpen='$pogoNotOpen'  where Origin='$origin' and instance='$MAD_instance_name_5' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600);"
        done < <(query "select origin FROM warning_worker where RPL = 60 and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600) and instance='$MAD_instance_name_5';")
fi

echo "`date '+%Y%m%d %H:%M:%S'` Hourly MAD log processing worker level finished" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "All done !!"
