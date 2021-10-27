#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo " " >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "#########################          $(date '+%Y-%m-%d')           #########################" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "Start time          Stop time           Duration  Process" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
