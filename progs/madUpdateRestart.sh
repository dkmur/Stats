echo "Stopping scanner, 60sec"
sudo -u dkmur /usr/bin/screen -X -S MAD stuff "^C"
sleep 60s
echo "Killing scanner, 2sec"
sudo -u dkmur /usr/bin/screen -X -S MAD quit
sleep 2s
echo "Updating scanner"
cd /home/dkmur/MAD/ && sudo -u dkmur git pull
echo "Starting scanner, 5sec"
sudo -u dkmur /home/dkmur/mad.sh
sleep 5s
sudo -u dkmur /usr/bin/screen -ls MAD
