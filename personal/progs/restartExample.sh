echo "Stopping scanner 1, 90sec"
sudo -u dkmur /usr/bin/screen -X -S mad1 stuff "^C"
sleep 90s
echo "Killing scanner 1, 2sec"
sudo -u dkmur /usr/bin/screen -X -S mad1 quit
sleep 2s
echo "Starting scanner 1, 5sec"
sudo -u dkmur /usr/local/bin/mad1
sleep 5s
sudo -u dkmur /usr/bin/screen -ls mad1
