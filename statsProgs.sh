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
echo "				Restarting/upgrading "
echo ""
echo ""
echo "					 1 = Restart MAD scanner"
echo ""
echo "					 6 = Restart Poracle"
echo ""
echo ""
echo "					10 = Update and restart MAD scanner"
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
         1)    $PATH_TO_STATS/progs/madRestart.sh
                ;;
         6)    $PATH_TO_STATS/progs/poracleRestart.sh
                ;;
        10)    $PATH_TO_STATS/progs/madUpdateRestart.sh
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

