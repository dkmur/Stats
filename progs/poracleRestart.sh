echo "Stopping PoracleJS, 2sec"
sudo -u dkmur /usr/bin/screen -X -S Poracle stuff "^C"
sleep 2s
echo "Killing PoracleJS, 2sec"
sudo -u dkmur /usr/bin/screen -X -S Poracle quit
sleep 2s
echo "Starting PoracleJS, 5sec"
sudo -u dkmur /home/dkmur/poracle.sh
sleep 5s
sudo -u dkmur /usr/bin/screen -ls Poracle
