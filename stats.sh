#!/bin/bash

function View
{
clear
routine1=0

while [[ $routine != "1" ]]
do
echo ""
echo "				SELECT A SQL OPTION FROM BELOW  "
echo ""
echo ""
echo "				Network Level Statistics"
echo ""
echo "					  0 = Mons scanned (from pokemon)"
echo ""
echo "					  1 = Spawnpoints"
echo ""
echo "					  2 = Area overview"
echo ""
echo "					  3 = Mons scanned (worker based)"
echo ""
echo "					  4 = Location handling (worker based)"
echo ""
echo "					  5 = Reboot/restart data"
echo ""
echo "					  6 = Quests scanned"
echo ""
echo "				Area Level Statistics"
echo ""
echo "					 10 = Mons scanned (from pokemon) "
echo ""
echo "					 11 = Spawnpoints "
echo ""
echo "					 12 = Worker overview "
echo ""
echo "					 13 = Mons scanned (Worker based) "
echo ""
echo "					 14 = Location handling (Worker based)"
echo ""
echo "					 15 = Reboot/restart data"
echo ""
echo "					 16 = Quests scanned"
echo ""
echo "				Worker Level Statistics "
echo ""
echo "					 20 = Mons scanned "
echo ""
echo "					 21 = Location handling "
echo ""
echo "					 22 = Reboot/restart data "
echo ""
echo "					 23 = Quests scanned "
echo "					    23a All wokers Quest scanned summed by date"
echo ""
echo "				PoracleJS "
echo ""
echo "					 30 = Goto Poracle menu "
echo ""
echo "				Program restart/update "
echo ""
echo "					 40 = Goto restart/update menu "
echo ""
echo "				Poke stats "
echo ""
echo "					 50 = Goto Poke stats menu "
echo ""
echo ""
echo "					 q = QUIT "
echo ""
echo ""

date '+%m%d%y_%H%M' | read -r AUTODATE

read opt
echo $USER $AUTODATE $opt >> pathToStatsLog.txt

clear

# echo ""

case $opt in

	q)	echo""
		routine=1
		exit
		;;
         0)    pathToStatsprogs/n_mons_scanned.sh
                ;;
         0a)    pathToStatsprogs/n_mons_scanned_ndal.sh
                ;;
         1)    pathToStatsprogs/n_spawnpoints.sh
                ;;
         2)    pathToStatsprogs/n_area_overview.sh
                ;;
         3)    pathToStatsprogs/n_mons_scanned_w.sh
                ;;
         4)    pathToStatsprogs/n_location.sh
                ;;
         5)    pathToStatsprogs/n_rebres.sh
                ;;
         6)    pathToStatsprogs/n_quests.sh
                ;;
	 10)	pathToStatsprogs/mons_scanned.sh
		;;
	 11)	pathToStatsprogs/spawnpoints.sh
		;;
	 12)	pathToStatsprogs/worker_overview.sh
		;; 
	 13)	pathToStatsprogs/mons_scanned_w.sh
		;;
	 14)	pathToStatsprogs/location.sh
		;;
         15)     pathToStatsprogs/rebres.sh
                ;;
         16)     pathToStatsprogs/quests.sh
                ;;
	 20)	pathToStatsprogs/mons_scanned_worker.sh
		;;
	 21)	pathToStatsprogs/location_worker.sh
		;;
	 22)	pathToStatsprogs/rebres_worker.sh
		;;
	 23)	pathToStatsprogs/quests_worker.sh
		;;
         23a)   pathToStatsprogs/quests_all_worker_summed.sh
                ;;
         30)    pathToStatsstatsPoracle.sh
                ;;
         40)    pathToStatsstatsProgs.sh
                ;;
         50)    pathToStatspokeStats.sh
                ;;
         60)    pathToStatsstatsOld.sh
                ;;
esac
# echo ""
echo "				Press ENTER to return to main menu"
read hold
clear
done
clear
}

View 

