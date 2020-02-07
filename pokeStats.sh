#!/bin/bash

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
         0)    pathToStatsprogsNew/poke_seen.sh
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

