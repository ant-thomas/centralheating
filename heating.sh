#!/bin/sh
#

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

control="`cat /mnt/server/rpi/heating/control.txt`"
room="`cat /mnt/server/rpi/heating/room.txt`"
targettemp="`cat /mnt/server/rpi/heating/targettemp.txt`"
arpscan="`cat /mnt/server/rpi/heating/arpscan.txt`"
boost="`cat /mnt/server/rpi/heating/boost.txt`"

echo control - $control

#ensure gpio activated
if [ `ls /sys/class/gpio | grep -i 22 -c` -eq 0 ];
then
gpio export 22 out
else
:
fi

#if off - turn off
if [ "$control" = "off" ];
then
echo "Heating Off"
echo "0" > /sys/class/gpio/gpio22/value
echo "off" > /mnt/server/rpi/heating/state.txt
exit
else
:
fi

#if on - turn on
if [ "$control" = "on" ];
then
echo "Heating On"
echo "1" > /sys/class/gpio/gpio22/value
echo "on" > /mnt/server/rpi/heating/state.txt
exit
else
:
fi

#select which room temp to use and fetch temp from db

if [ "$room" = "bedroom" ];
then
currenttemp=$(mysql --host=192.168.1.64 --user=temperature --password=temperature temptest -e"select temperature, unixtime from livingsensor order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "living" ];
then
currenttemp=$(mysql --host=192.168.1.64 --user=temperature --password=temperature temptest -e"select temperature, unixtime from bedroomsensor order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "box" ];
then
currenttemp=$(mysql --host=192.168.1.64 --user=temperature --password=temperature temptest -e"select temperature, unixtime from boxroomsensor order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "outside" ];
then
currenttemp=$(mysql --host=192.168.1.64 --user=temperature --password=temperature temptest -e"select temperature, unixtime from outsidesensor order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
else
currenttemp=$(mysql --host=192.168.1.64 --user=temperature --password=temperature temptest -e"select temperature, unixtime from livingsensor order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
fi

echo $room - $currenttemp
echo target - $targettemp
echo boost - $boost

#calculate whether current temp is greater than target temp
tempcalc="`echo $currenttemp'>='$targettemp | bc -l`"

#if current temp is higher turn off - if current temp is lower turn on
#if boost is on arpscan is ignored
if [ "$control" = "auto" ] && [ "$boost" = "1" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
echo "1" > /sys/class/gpio/gpio22/value
echo "on" > /mnt/server/rpi/heating/state.txt
exit
elif [ "$control" = "auto" ] && [ "$arpscan" = "1" ];
then
echo "Heating Off"
echo "0" > /sys/class/gpio/gpio22/value
echo "off" > /mnt/server/rpi/heating/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "1" ];
then
echo "Heating Off"
echo "0" > /sys/class/gpio/gpio22/value
echo "off" > /mnt/server/rpi/heating/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
echo "1" > /sys/class/gpio/gpio22/value
echo "on" > /mnt/server/rpi/heating/state.txt
exit

fi
