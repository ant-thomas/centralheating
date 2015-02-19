#!/bin/sh
#

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

control="`cat /location/to/control/files/control.txt`"
room="`cat /location/to/control/files/room.txt`"
targettemp="`cat /location/to/control/files/targettemp.txt`"

echo control - $control


#if off - turn off
if [ "$control" = "off" ];
then
echo "Heating Off"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=0
echo "off" > /location/to/control/files/state.txt
exit
else
:
fi

#if on - turn on
if [ "$control" = "on" ];
then
echo "Heating On"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=1
echo "on" > /location/to/control/files/state.txt
exit
else
:
fi


#select which room temp to use and fetch temp from db

if [ "$room" = "bedroom" ];
then
currenttemp=$(mysql --host=xxx.xxx.xxx.xxx --user=temperature --password=temperature temptest -e"select temperature, unixtime from bedroomtemp order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "living" ];
then
currenttemp=$(mysql --host=xxx.xxx.xxx.xxx --user=temperature --password=temperature temptest -e"select temperature, unixtime from livingroomtemp order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "box" ];
then
currenttemp=$(mysql --host=xxx.xxx.xxx.xxx --user=temperature --password=temperature temptest -e"select temperature, unixtime from boxroomtemp order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "outside" ];
then
currenttemp=$(mysql --host=xxx.xxx.xxx.xxx --user=temperature --password=temperature temptest -e"select temperature, unixtime from outsidetemp order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
else
currenttemp=$(mysql --host=xxx.xxx.xxx.xxx --user=temperature --password=temperature temptest -e"select temperature, unixtime from livingroomtemp order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
fi

echo $room - $currenttemp
echo target - $targettemp
arpscan="`cat /location/to/control/files/arpscan.txt`"
boost="`cat /location/to/control/files/boost.txt`"
echo boost - $boost
#calculate whether current temp is greater than target temp
tempcalc="`echo $currenttemp'>='$targettemp | bc -l`"

#if current temp is higher turn off - if current temp is lower turn on
#also check if house is occupied
if [ "$control" = "auto" ] && [ "$boost" = "1" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=1
echo "on" > /location/to/control/files/state.txt
exit
elif [ "$control" = "auto" ] && [ "$arpscan" = "1" ];
then
echo "Heating Off"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=0
echo "off" > /location/to/control/files/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "1" ];
then
echo "Heating Off"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=0
echo "off" > /location/to/control/files/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
pihat --brand=5 --id=123456 --repeats=10 --channel=7 --state=1
echo "on" > /location/to/control/files/state.txt
exit

fi
