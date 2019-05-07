#!/bin/bash
################################################################################
#                  iroffer-dinoex auto-install script v1.0                     #
# This is a simple iroffer auto-install script based off of the original       #
# guide by dinoex, with a few changes to help automate my own laziness         #
# it'll also help anyone who wants to setup a bot but doesn't know how.        #
# This will fully install iroffer-dinoex (https://iroffer.net/) and all        #
# dependencies, as well as setup a basic crontab to start on server boot.      #
#                                                                              #
# The following packages will be installed: nano                               #
#                                           make                               #
#                                           gcc                                #
#                                           curl                               #
#                                           cron                               #
#                                           libgeoip-dev                       #
#                                           openssl libssl-dev                 #
#                                           libcurl4-openssl-dev               #
#                                           ruby rails ruby-dev libruby        #
#                                                                              #
# This script was made for use with Debian 8/9 and Ubuntu 17/18                #
# Older distro's haven't been tested but should work, and tbh why the hell     #
# are you using something ancient in the first place? Get your shit together.  #
#                                                                              #
# We'll be installing this via a user account and in the /home/ directory just #
# for ease of use, I highly recommend you change the installation folder.      #
################################################################################

echo "We're about to install iroffer..."
read -rsn1 -p"Press any key to continue";echo

#First we install the dependencies
sudo apt-get install nano make gcc cron openssl libssl-dev libcurl4-openssl-dev ruby rails ruby-dev libruby curl libgeoip-dev libc-dev libminiupnpc-dev libmaxminddb-dev -y

#Now we download the source and make the folders
#We are using the latest 3.32 beta version (Snap) for this
#If you want to use a stable release, visit https://iroffer.net/dinoex and replace files accordingly
cd ~/
sudo mkdir iroffer
cd iroffer
sudo wget https://iroffer.net/iroffer-dinoex-snap.tar.gz

#Configuring and compiling the iroffer source
sudo tar -xvzf iroffer-dinoex-snap.tar.gz
cd iroffer-dinoex-snap
sudo ./Configure -curl -geoip -ruby
make

#Now we're going to be copying the required files to your iroffer directory
sudo cp -p iroffer ..

sudo cp *.html ..
sudo cp -r htdocs ../
sudo wget --no-check-certificate https://raw.githubusercontent.com/NIBLCO/iroffer/master/bot.config
sudo cp bot.config ..

#Setting permissions
cd ..
sudo chmod 600 sample.config
sudo chmod 600 basic.config
sudo chmod 700.

#Cleaning up a little
sudo rm -rf iroffer-dinoex-snap.tar.gz
sudo rm -rf iroffer-dinoex-snap/

#Now we set a password for admin chat access.
./iroffer -c bot.config

#Now we create a folder for your log files and the files the bot will serve
sudo mkdir logs
sudo chmod -R 775 logs/
cd ..
sudo mkdir files/
sudo chmod -R 775 files/

#Now we create the auto-start script and set it to be executable
echo "Creating autostart.sh now...."

echo >> autostart.sh
echo "#!/bin/sh" >> autostart.sh
echo "cd $HOME/iroffer" >> autostart.sh
echo "./iroffer -b bot.config" >> autostart.sh

echo "iroffer.sh has been created - Please edit this to suit your needs."

sudo chmod +x iroffer.sh

#Now we're going to echo an incredibly simple crontab to start iroffer whenever the server boots up
#Expect something better in the next version, such as an init or just modifying rc.local but eh.
( crontab -l ; echo "@reboot sh /$HOME/iroffer/iroffer.sh" ) | crontab -

#Everything is done, just edit your bot config and start it up!
read -rsn1 -p"Installation finished, get your ass in #NIBL";echo
