#!/bin/bash

source config.ini

function View
{
clear
routine1=0

while [[ $routine != "1" ]]
do
echo ""
echo "                          SELECT A SQL OPTION FROM BELOW  "
echo ""
echo ""
echo "                          Network Level Statistics"
echo ""
echo "                                    0 = Mons scanned (from pokemon)"
echo ""
echo "                                    1 = Spawnpoints"
echo ""
echo "                                    2 = Spawn time left"
echo ""
echo "                                    3 = Area overview"
echo ""
echo "                                    4 = Mons scanned (worker based)"
echo ""
echo "                                    5 = Location handling (worker based)"
echo ""
echo "                                    6 = Reboot/restart data"
echo ""
echo "                                    7 = Quests scanned"
echo ""
echo "                          Area Level Statistics"
echo ""
echo "                                   10 = Mons scanned (from pokemon) "
echo ""
echo "                                   11 = Spawnpoints "
echo ""
echo "                                   12 = Spawn time left "
echo ""
echo "                                   13 = Worker overview "
echo ""
echo "                                   14 = Mons scanned (Worker based) "
echo ""
echo "                                   15 = Location handling (Worker based)"
echo ""
echo "                                   16 = Reboot/restart data"
echo ""
echo "                                   17 = Quests scanned"
echo ""
echo "                          Worker Level Statistics "
echo ""
echo "                                   20 = Mons scanned "
echo ""
echo "                                   21 = Location handling "
echo ""
echo "                                   22 = Reboot/restart data "
echo ""
echo "                                   23 = Quests scanned "
echo "                                      23a All wokers Quest scanned summed by date"
echo ""
echo "                          Poke stats "
echo ""
echo "                                   30 = Goto Poke stats menu "
echo ""
echo "                          Own stuff "
echo ""
echo "                                   40 = Goto own stuff "
echo ""
echo ""
echo ""
echo "                                   q = QUIT "
echo ""
echo ""

date '+%m%d%y_%H%M' | read -r AUTODATE

read opt
echo $USER $AUTODATE $opt >> Log.txt

clear

# echo ""

case $opt in

        q)      echo""
                routine=1
                exit
                ;;
         0)     $PATH_TO_STATS/progs/n_mons_scanned.sh
                ;;
         1)     $PATH_TO_STATS/progs/n_spawnpoints.sh
                ;;
         2)     $PATH_TO_STATS/progs/n_timeleft.sh
                ;;
         3)     $PATH_TO_STATS/progs/n_area_overview.sh
                ;;
         4)     $PATH_TO_STATS/progs/n_mons_scanned_w.sh
                ;;
         5)     $PATH_TO_STATS/progs/n_location.sh
                ;;
         6)     $PATH_TO_STATS/progs/n_rebres.sh
                ;;
         7)     $PATH_TO_STATS/progs/n_quests.sh
                ;;
         10)    $PATH_TO_STATS/progs/mons_scanned.sh
                ;;
         11)    $PATH_TO_STATS/progs/spawnpoints.sh
                ;;
         12)    $PATH_TO_STATS/progs/timeleft.sh
                ;;
         13)    $PATH_TO_STATS/progs/worker_overview.sh
                ;;
         14)    $PATH_TO_STATS/progs/mons_scanned_w.sh
                ;;
         15)    $PATH_TO_STATS/progs/location.sh
                ;;
         16)    $PATH_TO_STATS/progs/rebres.sh
                ;;
         17)    $PATH_TO_STATS/progs/quests.sh
                ;;
         20)    $PATH_TO_STATS/progs/mons_scanned_worker.sh
                ;;
         21)    $PATH_TO_STATS/progs/location_worker.sh
                ;;
         22)    $PATH_TO_STATS/progs/rebres_worker.sh
                ;;
         23)    $PATH_TO_STATS/progs/quests_worker.sh
                ;;
         23a)   $PATH_TO_STATS/progs/quests_all_worker_summed.sh
                ;;
         30)    $PATH_TO_STATS/pokeStats.sh
                ;;
         40)    $PATH_TO_STATS/statsOwnStuff.sh
                ;;

esac
# echo ""
echo "                          Press ENTER to return to main menu"
read hold
clear
done
clear
}

View
