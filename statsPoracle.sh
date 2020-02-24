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
echo "				PoracleJS "
echo ""
echo "					 0 = High level users "
echo "					 1 = User overview"
echo "					 2 = User mons"
echo "					 3 = User quests"
echo "					 4 = User incident"
echo "					 5 = User raids"
echo "					 6 = User eggs"
echo ""
echo "					 7 = Delete user settings"
echo "					 8 = Stop user from receiving notifications"
echo "					 9 = REMOVE user from databse (requires #7 to be ran in advance!!)"
echo ""
echo ""
echo "					 q = QUIT "
echo ""
echo ""

date '+%m%d%y_%H%M' | read -r AUTODATE

read opt
echo $USER $AUTODATE $opt >> $PATH_TO_STATSLog.txt

clear

# echo ""

case $opt in

	q)	echo""
		routine=1
		exit
		;;
         0)    $PATH_TO_STATS/progs/poracle_users.sh
                ;;
         1)    $PATH_TO_STATS/progs/poracle_user_details.sh
                ;;
         2)    $PATH_TO_STATS/progs/poracle_user_mon.sh
                ;;
         3)    $PATH_TO_STATS/progs/poracle_user_quest.sh
                ;;
         4)    $PATH_TO_STATS/progs/poracle_user_incident.sh
                ;;
         5)    $PATH_TO_STATS/progs/poracle_user_raid.sh
                ;;
         6)    $PATH_TO_STATS/progs/poracle_user_egg.sh
                ;;
         7)    $PATH_TO_STATS/progs/poracle_user_delete.sh
                ;;
         8)    $PATH_TO_STATS/progs/poracle_user_stop.sh
                ;;
         9)    $PATH_TO_STATS/progs/poracle_user_remove.sh
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

