#!/usr/bin/env bash

MONO_VERSION="3.2.3"
MONO_SOURCE_FOLDER="mono-${MONO_VERSION}"
MONO_SOURCE_FILENAME="mono-${MONO_VERSION}.tar.bz2"
MONO_SOURCE="http://download.mono-project.com/sources/mono/${MONO_SOURCE_FILENAME}"


### Install prerequisites ######################################################

apt-get update

apt-get install -y wget
apt-get install -y build-essential
apt-get install -y gettext
apt-get install -y automake

### Download and build Mono ######################################################
cd /home/vagrant
echo "Grabbing: $MONO_SOURCE"
wget $MONO_SOURCE
tar -xvjpf $MONO_SOURCE_FILENAME #tar xk -C "/opt" -f $MONO_SOURCE_FILENAME
cd $MONO_SOURCE_FOLDER
./configure --prefix=/usr/local
make
sudo make install
cd ..
rm -fr $MONO_SOURCE_FOLDER

## TODO: not sure if these lines are needed, most examples don't seem to have them
#echo export PATH="$PATH:/opt/mono/bin" >> /etc/profile.d/mono.sh
#echo export LD_LIBRARY_PATH="/opt/mono/lib" >> /etc/profile.d/mono.sh


### Finishing touches ##################################################################

# Clear the cache to reduce space used when packaging up the box
sudo apt-get clean

# TODO: for production use, we should probably remove the build tools as part of a cleanup script


#cd /vagrant
#echo cd \/vagrant > /home/vagrant/.bashrc
#rm -rf /etc/motd

#echo "> Mono version $MONO_VERSION is installed." >> /etc/motd
#echo >> /etc/motd
#echo The directory you are now in is shared with the host \(the same directory as you copied the vagrantfile into\) - on your local machine clone the source as you would normally then inside this VM type \"cd \[directory name\]\" then \"rake mono\" and observe the output. >> /etc/motd
#echo >> /etc/motd
