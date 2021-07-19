#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")
interval=$(date -d '1 hour ago' +%m"-"%d" "%H)


## update db for instance 1
if [ -z "$MAD_path_1" ]
then
  echo ""
  echo "No instance defined"
else
  echo "Processing MAD logs for $MAD_instance_name_1"
  echo ""
  mkdir -p $folder/tmp
#  grep "$interval" $MAD_path_1/logs/$MAD_instance_name_1-$process_date.log > $folder/tmp/$MAD_instance_name_1.log
  grep "\[$interval" $MAD_path_1/logs/*$MAD_instance_name_1* > $folder/tmp/$MAD_instance_name_1.log
#  echo "Errors"
  errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
  deadlock="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Deadlock found' | wc -l)"
  failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
  oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
  originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
  wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
  killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
  wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
  jobFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep -i 'Job jobType'  | wc -l)"
  killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
  killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
  python="$(grep 'Traceback (most recent call last)' $folder/tmp/$MAD_instance_name_1.log |  wc -l)"
  noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
  tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_1.log | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"
# cat 20210526_1346_mad.log | grep -w [E] | grep -v 'Deadlock found' | grep -v 'Old connection open while a new one is attempted to be established' | grep -v  '5 consecutive timeouts or origin' | grep -v 'Failed stopping com.nianticlabs.pokemongo' | grep -v 'Websocket connection to' | grep -v 'Killed while waiting for pogo start' | grep -v 'Failed initializing worker' | grep -v 'Error while getting response from device - Reason' | grep -v 'Job jobType' | grep -v 'Killed while waiting for injection' | grep -v 'killed while sleeping' | grep -v 'Unable to delete any items' | grep -v 'Cannot start job' | grep -v 'Job for' | grep -v 'Tesseract Error'

#  echo "Warnings"
  warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | wc -l)"
  failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Worker failed to retrieve proper data' | wc -l)"
  manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Too many timeouts' | wc -l)"
  fallingBehind="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'falling behind' | wc -l)"
  if (( $fallingBehind > 0 ))
  then
    maxFalling="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'falling behind' | awk '{print ($NF)}' | jq -s max)"
  else
    maxFalling=0
  fi
  frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Screen is frozen' | wc -l)"
  wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Timeout, increasing timeout-counter' | wc -l)"
  wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Connection' | grep 'closed' | wc -l)"
  noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Not injected in time - reboot' | wc -l)"
  noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed restarting PoGo - reboot device' | wc -l)"
  failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed retrieving screenshot' | wc -l)"
  noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'No PTC Accounts' | wc -l)"
  failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed getting the topmost app' | wc -l)"
  pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Restarting PoGo failed - reboot device' | wc -l)"
  screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
  failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed clearing box' | wc -l)"
  itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Deletion not confirmed' | wc -l)"
  noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Cannot find any active area defined for current time' | wc -l)"
  noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Could not get to Mainscreen' | wc -l)"
  noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'has not accessed a location in 300 seconds' | wc -l)"
  noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'has not been processed thrice in a row' | wc -l)"
  failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Giving up on this stop after 3 failures in open_pokestop loop' | wc -l)"
  softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Softban' | wc -l)"
  questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed getting quest but got items' | wc -l)"
  foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Tried to open a stop but found a gym instead' | wc -l)"
  noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Failed to find a walker configuration' | wc -l)"
  noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
  dupMac="$(grep 'Duplicate MAC' $folder/tmp/$MAD_instance_name_1.log | wc -l)"
  failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
  noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Could not login again' | wc -l)"
  failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Worker failed running post_move_location_routine' | wc -l)"
  inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'In game error detected' | wc -l)"
  gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'Detected GPS error - reboot device' | wc -l)"
  pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_1.log | grep 'PoGo is not opened! Current topmost app' | wc -l)"

# cat MAD2-2021-06-25.log | grep -w \[W\] | grep -v 'Worker failed to retrieve proper data' | grep -v 'Too many timeouts' | grep -v 'falling behind' | grep -v 'Screen is frozen' | grep -v 'Timeout, increasing timeout-counter' | grep -v 'Not injected in time - reboot' | grep -v 'Failed restarting PoGo - reboot device' | grep -v 'Failed retrieving screenshot' | grep -v 'No PTC Accounts' | grep -v 'Failed getting the topmost app' | grep -v 'Restarting PoGo failed - reboot device' | grep -v 'Something wrong with screendetection or pogo failure screen' | grep -v 'Failed clearing box' | grep -v 'Deletion not confirmed' | grep -v 'Cannot find any active area defined for current time' | grep -v 'Could not get to Mainscreen' | grep -v 'has not accessed a location in 300 seconds' | grep -v 'has not been processed thrice in a row' | grep -v 'Giving up on this stop after 3 failures in open_pokestop loop' | grep -v 'Softban' | grep -v 'Failed getting quest but got items' | grep -v 'Tried to open a stop but found a gym instead' | grep -v 'Failed to find a walker configuration' | grep -v 'yielding a spinnable stop - likely not standing exactly on top' | grep -v 'giving up spinning after 4 tries in handle_stop loop' | grep -v 'Could not login again' | grep -v 'Worker failed running post_move_location_routine'

#  echo ""
#  echo "$process_hour"
#  echo ""
#  echo "errors: $errors"
#  echo "deadlock: $deadlock"
#  echo "failedPogoStop: $failedPogoStop"
#  echo "oldConnection: $oldConnection"
#  echo "originTimeout: $originTimeout"
#  echo "wsLost: $wsLost"
#  echo "killPogoWait: $killPogoWait"
#  echo "wokerInitFail: $wokerInitFail"
#  echo "jobFail: $jobFail"
#  echo "killInjection: $killInjection"
#  echo "killSleep: $killSleep"
#  echo "python: $python"
#  echo "noItemDelete: $noItemDelete"
#  echo ""
#  missingE=$(($errors-$deadlock-$failedPogoStop-$oldConnection-$originTimeout-$wsLost-$killPogoWait-$wokerInitFail-$jobFail-$killInjection-$killSleep-$noItemDelete))
#  echo "Missing errors: $missingE"
#  echo ""
#  echo "warns: $warns"
#  echo "failedData $failedData"
#  echo "manyTimeOut: $manyTimeOut"
#  echo "fallingBehind: $fallingBehind"
#  echo "maxFalling: $maxFalling"
#  echo "frozenScreen: $frozenScreen"
#  echo "wsTimeout: $wsTimeout"
#  echo "wsConnClosed: $wsConnClosed"
#  echo "noInject: $noInject"
#  echo "noPogoStart: $noPogoStart"
#  echo "failedScreenshot: $failedScreenshot"
#  echo "noPTC: $noPTC"
#  echo "failedTopApp: $failedTopApp"
#  echo "pogoRestartFail: $pogoRestartFail"
#  echo "screenFailure: $screenFailure"
#  echo "failedBoxClear: $failedBoxClear"
#  echo "itemDelUnknown: $itemDelUnknown"
#  echo "noActiveArea: $noActiveArea"
#  echo "noMainScreen: $noMainScreen"
#  echo "noLocAccess: $noLocAccess"
#  echo "noStopProcess: $noStopProcess"
#  echo "failStopOpen: $failStopOpen"
#  echo "softban: $softban"
#  echo "questFull: $questFull"
#  echo "foundGym: $foundGym"
#  echo "noWalkerConfig: $noWalkerConfig"
#  echo "noStop: $noStop"
#  missingW=$(($warns-$failedData-$manyTimeOut-$fallingBehind-$frozenScreen-$wsTimeout-$wsConnClosed-$noInject-$noPogoStart-$failedScreenshot-$noPTC-$failedTopApp-$pogoRestartFail-$screenFailure-$failedBoxClear-$itemDelUnknown-$noActiveArea-$noMainScreen-$noLocAccess-$noStopProcess-$failStopOpen-$softban-$questFull-$foundGym-$noWalkerConfig-$noStop))
#  echo "Missing warnings: $missingW"
#  echo ""

  echo "Insert $MAD_instance_name_1 data into DB"
  echo ""
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  fi
fi

## update db for instance 2
if [ -z "$MAD_path_2" ]
then
  echo ""
  echo "No 2nd instance defined"
else
  echo "Processing MAD logs for $MAD_instance_name_2"
  echo ""
#  mkdir -p $folder/tmp
#  grep "$interval" $MAD_path_2/logs/$MAD_instance_name_2-$process_date.log > $folder/tmp/$MAD_instance_name_2.log
  grep "\[$interval" $MAD_path_2/logs/*$MAD_instance_name_2* > $folder/tmp/$MAD_instance_name_2.log
#  echo "Errors"
  errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
  deadlock="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Deadlock found' | wc -l)"
  failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
  oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
  originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
  wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
  killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
  wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
  jobFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep -i 'Job jobType'  | wc -l)"
  killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
  killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
  python="$(grep 'Traceback (most recent call last)' $folder/tmp/$MAD_instance_name_2.log |  wc -l)"
  noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
  tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_2.log | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

#  echo "Warnings"
  warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | wc -l)"
  failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Worker failed to retrieve proper data' | wc -l)"
  manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Too many timeouts' | wc -l)"
  fallingBehind="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'falling behind' | wc -l)"
  if (( $fallingBehind > 0 ))
  then
    maxFalling="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'falling behind' | awk '{print ($NF)}' | jq -s max)"
  else
    maxFalling=0
  fi
  frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Screen is frozen' | wc -l)"
  wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Timeout, increasing timeout-counter' | wc -l)"
  wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Connection' | grep 'closed' | wc -l)"
  noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Not injected in time - reboot' | wc -l)"
  noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed restarting PoGo - reboot device' | wc -l)"
  failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed retrieving screenshot' | wc -l)"
  noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'No PTC Accounts' | wc -l)"
  failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed getting the topmost app' | wc -l)"
  pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Restarting PoGo failed - reboot device' | wc -l)"
  screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
  failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed clearing box' | wc -l)"
  itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Deletion not confirmed' | wc -l)"
  noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Cannot find any active area defined for current time' | wc -l)"
  noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Could not get to Mainscreen' | wc -l)"
  noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'has not accessed a location in 300 seconds' | wc -l)"
  noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'has not been processed thrice in a row' | wc -l)"
  failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Giving up on this stop after 3 failures in open_pokestop loop' | wc -l)"
  softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Softban' | wc -l)"
  questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed getting quest but got items' | wc -l)"
  foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Tried to open a stop but found a gym instead' | wc -l)"
  noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Failed to find a walker configuration' | wc -l)"
  noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
  dupMac="$(grep 'Duplicate MAC' $folder/tmp/$MAD_instance_name_2.log | wc -l)"
  failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
  noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Could not login again' | wc -l)"
  failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Worker failed running post_move_location_routine' | wc -l)"
  inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'In game error detected' | wc -l)"
  gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'Detected GPS error - reboot device' | wc -l)"
  pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_2.log | grep 'PoGo is not opened! Current topmost app' | wc -l)"

  echo "Insert $MAD_instance_name_2 data into DB"
  echo ""
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  fi
fi

## update db for instance 3
if [ -z "$MAD_path_3" ]
then
  echo ""
  echo "No 3nd instance defined"
else
  echo "Processing MAD logs for $MAD_instance_name_3"
  echo ""
#  mkdir -p $folder/tmp
#  grep "$interval" $MAD_path_3/logs/$MAD_instance_name_3-$process_date.log > $folder/tmp/$MAD_instance_name_3.log
  grep "\[$interval" $MAD_path_3/logs/*$MAD_instance_name_3* > $folder/tmp/$MAD_instance_name_3.log
#  echo "Errors"
  errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
  deadlock="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Deadlock found' | wc -l)"
  failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
  oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
  originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
  wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
  killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
  wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
  jobFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep -i 'Job jobType'  | wc -l)"
  killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
  killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
  python="$(grep 'Traceback (most recent call last)' $folder/tmp/$MAD_instance_name_3.log |  wc -l)"
  noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
  tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_3.log | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

#  echo "Warnings"
  warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | wc -l)"
  failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Worker failed to retrieve proper data' | wc -l)"
  manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Too many timeouts' | wc -l)"
  fallingBehind="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'falling behind' | wc -l)"
  if (( $fallingBehind > 0 ))
  then
    maxFalling="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'falling behind' | awk '{print ($NF)}' | jq -s max)"
  else
    maxFalling=0
  fi
  frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Screen is frozen' | wc -l)"
  wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Timeout, increasing timeout-counter' | wc -l)"
  wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Connection' | grep 'closed' | wc -l)"
  noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Not injected in time - reboot' | wc -l)"
  noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed restarting PoGo - reboot device' | wc -l)"
  failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed retrieving screenshot' | wc -l)"
  noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'No PTC Accounts' | wc -l)"
  failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed getting the topmost app' | wc -l)"
  pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Restarting PoGo failed - reboot device' | wc -l)"
  screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
  failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed clearing box' | wc -l)"
  itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Deletion not confirmed' | wc -l)"
  noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Cannot find any active area defined for current time' | wc -l)"
  noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Could not get to Mainscreen' | wc -l)"
  noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'has not accessed a location in 300 seconds' | wc -l)"
  noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'has not been processed thrice in a row' | wc -l)"
  failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Giving up on this stop after 3 failures in open_pokestop loop' | wc -l)"
  softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Softban' | wc -l)"
  questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed getting quest but got items' | wc -l)"
  foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Tried to open a stop but found a gym instead' | wc -l)"
  noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Failed to find a walker configuration' | wc -l)"
  noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
  dupMac="$(grep 'Duplicate MAC' $folder/tmp/$MAD_instance_name_3.log | wc -l)"
  failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
  noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Could not login again' | wc -l)"
  failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Worker failed running post_move_location_routine' | wc -l)"
  inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'In game error detected' | wc -l)"
  gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'Detected GPS error - reboot device' | wc -l)"
  pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_3.log | grep 'PoGo is not opened! Current topmost app' | wc -l)"

  echo "Insert $MAD_instance_name_3 data into DB"
  echo ""
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  fi
fi


## update db for instance 4
if [ -z "$MAD_path_4" ]
then
  echo ""
  echo "No 4nd instance defined"
else
  echo "Processing MAD logs for $MAD_instance_name_4"
  echo ""
#  mkdir -p $folder/tmp
#  grep "$interval" $MAD_path_4/logs/$MAD_instance_name_4-$process_date.log > $folder/tmp/$MAD_instance_name_4.log
  grep "\[$interval" $MAD_path_4/logs/*$MAD_instance_name_4* > $folder/tmp/$MAD_instance_name_4.log
#  echo "Errors"
  errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
  deadlock="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Deadlock found' | wc -l)"
  failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
  oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
  originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
  wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
  killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
  wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
  jobFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep -i 'Job jobType'  | wc -l)"
  killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
  killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
  python="$(grep 'Traceback (most recent call last)' $folder/tmp/$MAD_instance_name_4.log |  wc -l)"
  noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
  tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_4.log | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

#  echo "Warnings"
  warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | wc -l)"
  failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Worker failed to retrieve proper data' | wc -l)"
  manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Too many timeouts' | wc -l)"
  fallingBehind="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'falling behind' | wc -l)"
  if (( $fallingBehind > 0 ))
  then
    maxFalling="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'falling behind' | awk '{print ($NF)}' | jq -s max)"
  else
    maxFalling=0
  fi
  frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Screen is frozen' | wc -l)"
  wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Timeout, increasing timeout-counter' | wc -l)"
  wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Connection' | grep 'closed' | wc -l)"
  noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Not injected in time - reboot' | wc -l)"
  noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed restarting PoGo - reboot device' | wc -l)"
  failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed retrieving screenshot' | wc -l)"
  noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'No PTC Accounts' | wc -l)"
  failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed getting the topmost app' | wc -l)"
  pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Restarting PoGo failed - reboot device' | wc -l)"
  screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
  failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed clearing box' | wc -l)"
  itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Deletion not confirmed' | wc -l)"
  noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Cannot find any active area defined for current time' | wc -l)"
  noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Could not get to Mainscreen' | wc -l)"
  noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'has not accessed a location in 400 seconds' | wc -l)"
  noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'has not been processed thrice in a row' | wc -l)"
  failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Giving up on this stop after 4 failures in open_pokestop loop' | wc -l)"
  softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Softban' | wc -l)"
  questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed getting quest but got items' | wc -l)"
  foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Tried to open a stop but found a gym instead' | wc -l)"
  noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Failed to find a walker configuration' | wc -l)"
  noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
  dupMac="$(grep 'Duplicate MAC' $folder/tmp/$MAD_instance_name_4.log | wc -l)"
  failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
  noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Could not login again' | wc -l)"
  failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Worker failed running post_move_location_routine' | wc -l)"
  inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'In game error detected' | wc -l)"
  gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'Detected GPS error - reboot device' | wc -l)"
  pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_4.log | grep 'PoGo is not opened! Current topmost app' | wc -l)"

  echo "Insert $MAD_instance_name_4 data into DB"
  echo ""
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  fi
fi

## update db for instance 5
if [ -z "$MAD_path_5" ]
then
  echo ""
  echo "No 5nd instance defined"
else
  echo "Processing MAD logs for $MAD_instance_name_5"
  echo ""
#  mkdir -p $folder/tmp
#  grep "$interval" $MAD_path_5/logs/$MAD_instance_name_5-$process_date.log > $folder/tmp/$MAD_instance_name_5.log
  grep "\[$interval" $MAD_path_5/logs/*$MAD_instance_name_5* > $folder/tmp/$MAD_instance_name_5.log
#  echo "Errors"
  errors="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep -v 'Cannot start job' | grep -v 'Job for' | wc -l)"
  deadlock="$(grep -w \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Deadlock found' | wc -l)"
  failedPogoStop="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed stopping com.nianticlabs.pokemongo' | wc -l)"
  oldConnection="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Old connection open while a new one is attempted to be established' | wc -l)"
  originTimeout="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep '5 consecutive timeouts or origin'  | wc -l)"
  wsLost="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Websocket connection to'  | wc -l)"
  killPogoWait="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for pogo start'  | wc -l)"
  wokerInitFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Failed initializing worker'  | wc -l)"
  jobFail="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep -i 'Job jobType'  | wc -l)"
  killInjection="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Killed while waiting for injection'  | wc -l)"
  killSleep="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'killed while sleeping'  | wc -l)"
  python="$(grep 'Traceback (most recent call last)' $folder/tmp/$MAD_instance_name_5.log |  wc -l)"
  noItemDelete="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Unable to delete any items'  | wc -l)"
  tesseract="$(grep \[E\] $folder/tmp/$MAD_instance_name_5.log | grep -v 'Error while getting response from device - Reason' | grep 'Tesseract Error'  | wc -l)"

#  echo "Warnings"
  warns="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | wc -l)"
  failedData="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Worker failed to retrieve proper data' | wc -l)"
  manyTimeOut="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Too many timeouts' | wc -l)"
  fallingBehind="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'falling behind' | wc -l)"
  if (( $fallingBehind > 0 ))
  then
    maxFalling="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'falling behind' | awk '{print ($NF)}' | jq -s max)"
  else
    maxFalling=0
  fi
  frozenScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Screen is frozen' | wc -l)"
  wsTimeout="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Timeout, increasing timeout-counter' | wc -l)"
  wsConnClosed="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Connection' | grep 'closed' | wc -l)"
  noInject="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Not injected in time - reboot' | wc -l)"
  noPogoStart="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed restarting PoGo - reboot device' | wc -l)"
  failedScreenshot="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed retrieving screenshot' | wc -l)"
  noPTC="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'No PTC Accounts' | wc -l)"
  failedTopApp="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed getting the topmost app' | wc -l)"
  pogoRestartFail="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Restarting PoGo failed - reboot device' | wc -l)"
  screenFailure="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Something wrong with screendetection or pogo failure screen' | wc -l)"
  failedBoxClear="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed clearing box' | wc -l)"
  itemDelUnknown="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Deletion not confirmed' | wc -l)"
  noActiveArea="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Cannot find any active area defined for current time' | wc -l)"
  noMainScreen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Could not get to Mainscreen' | wc -l)"
  noLocAccess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'has not accessed a location in 500 seconds' | wc -l)"
  noStopProcess="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'has not been processed thrice in a row' | wc -l)"
  failStopOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Giving up on this stop after 5 failures in open_pokestop loop' | wc -l)"
  softban="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Softban' | wc -l)"
  questFull="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed getting quest but got items' | wc -l)"
  foundGym="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Tried to open a stop but found a gym instead' | wc -l)"
  noWalkerConfig="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Failed to find a walker configuration' | wc -l)"
  noStop="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'yielding a spinnable stop - likely not standing exactly on top' | wc -l)"
  dupMac="$(grep 'Duplicate MAC' $folder/tmp/$MAD_instance_name_5.log | wc -l)"
  failStopSpin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'giving up spinning after 4 tries in handle_stop loop' | wc -l)"
  noLogin="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Could not login again' | wc -l)"
  failPostMove="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Worker failed running post_move_location_routine' | wc -l)"
  inGameError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'In game error detected' | wc -l)"
  gpsError="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'Detected GPS error - reboot device' | wc -l)"
  pogoNotOpen="$(grep -w \[W\] $folder/tmp/$MAD_instance_name_5.log | grep 'PoGo is not opened! Current topmost app' | wc -l)"

  echo "Insert $MAD_instance_name_5 data into DB"
  echo ""
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (datetime,RPL,instance,errors,deadlock,failedPogoStop,oldConnection,originTimeout,wsLost,killPogoWait,wokerInitFail,jobFail,killInjection,killSleep,python,noItemDelete,tesseract) VALUES ('$process_hour','60','$MAD_instance_name_5','$errors','$deadlock','$failedPogoStop','$oldConnection','$originTimeout','$wsLost','$killPogoWait','$wokerInitFail','$jobFail','$killInjection','$killSleep','$python','$noItemDelete','$tesseract');"
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO warning (datetime,RPL,instance,warns,failedData,manyTimeOut,fallingBehind,maxFalling,frozenScreen,wsTimeout,wsConnClosed,noInject,noPogoStart,failedScreenshot,noPTC,failedTopApp,pogoRestartFail,screenFailure,failedBoxClear,itemDelUnknown,noActiveArea,noMainScreen,noLocAccess,noStopProcess,failStopOpen,softban,questFull,foundGym,noWalkerConfig,noStop,dupMac,failStopSpin,noLogin,failPostMove,inGameError,gpsError,pogoNotOpen) VALUES ('$process_hour','60','$MAD_instance_name_5','$warns','$failedData','$manyTimeOut','$fallingBehind','$maxFalling','$frozenScreen','$wsTimeout','$wsConnClosed','$noInject','$noPogoStart','$failedScreenshot','$noPTC','$failedTopApp','$pogoRestartFail','$screenFailure','$failedBoxClear','$itemDelUnknown','$noActiveArea','$noMainScreen','$noLocAccess','$noStopProcess','$failStopOpen','$softban','$questFull','$foundGym','$noWalkerConfig','$noStop','$dupMac','$failStopSpin','$noLogin','$failPostMove','$inGameError','$gpsError','$pogoNotOpen');"
  fi
fi

echo ""
echo "All done!"
