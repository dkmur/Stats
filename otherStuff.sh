#!/bin/bash

source config.ini

function View
{
clear
routine1=0

while [[ $routine != "1" ]]
do
echo ""
echo "				SELECT AN OPTION FROM BELOW  "
echo ""
echo ""
echo "					 0 = Pokemon seen"
echo ""
echo "					 1 = SW overview"
echo ""
echo "					 2 = PD setting overview"
echo ""
echo "					 3 = RGC setting overview"
echo ""
echo "					 4 = Temperature details"
echo ""
echo "					 5 = all Device IP"
echo ""
echo "					 6 = all device gmail"
echo ""
echo "					 7 = PD id"
echo ""
echo ""
echo "					 q = QUIT "
echo ""
echo ""

date '+%m%d%y_%H%M' | read -r AUTODATE

read opt
echo $USER $AUTODATE $opt >> $PATH_TO_STATS/Log.txt

clear

# echo ""

case $opt in

	q)	echo""
		routine=1
		exit
		;;
         0)    $PATH_TO_STATS/progs/poke_seen.sh
                ;;
         1)    $PATH_TO_STATS/progs/atv_sw_overview.sh
                ;;
         2)    $PATH_TO_STATS/progs/pd_setting_overview.sh
                ;;
         3)    $PATH_TO_STATS/progs/rgc_setting_overview.sh
                ;;
         4)    $PATH_TO_STATS/progs/temperature_details.sh
                ;;
         5)    $PATH_TO_STATS/progs/ipadresses.sh
                ;;
         6)    $PATH_TO_STATS/progs/gmail.sh
                ;;
         7)    $PATH_TO_STATS/progs/pd_id.sh
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

