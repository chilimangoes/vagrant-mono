#!/usr/bin/env bash

#################################################################
# WARNING: This script will fil up your left over disk space.
#
# DO NOT RUN THIS WHEN YOUR VIRTUAL HD IS RAW!!!!!!
#
# You should NOT do this on a running system.
# This is purely for making vagrant boxes damn small.
#
# http://vstone.eu/reducing-vagrant-box-size/
#################################################################

sudo apt-get clean

echo 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && sudo rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history
 
echo 'Cleanup log files'
sudo find /var/log -type f | while read f; do echo -ne '' > $f; done;
 
echo 'Whiteout root'
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`; 
let count--
sudo dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
sudo rm /tmp/whitespace;
 
echo 'Whiteout /boot'
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
sudo dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
sudo rm /boot/whitespace;
 
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
sudo swapoff $swappart;
sudo dd if=/dev/zero of=$swappart;
sudo mkswap $swappart;
sudo swapon $swappart;