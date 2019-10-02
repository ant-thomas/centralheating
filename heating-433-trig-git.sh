#!/bin/sh
#

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

runcheck="`ps cax | grep heating-433 -c`"
echo $runcheck
if [ $runcheck -ge 3 ];
then
echo "running"
exit
else
:
fi


control="`cat /mnt/server/rpi/heating/control.txt`"
room="`cat /mnt/server/rpi/heating/room.txt`"
targettemp="`cat /mnt/server/rpi/heating/targettemp.txt`"
mintemp=14

echo control - $control


#if off - turn off
if [ "$control" = "off" ];
then
echo "Heating Off"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power OFF"
echo "off" > /mnt/server/rpi/heating/state.txt
exit
else
:
fi

#if on - turn on
if [ "$control" = "on" ];
then
echo "Heating On"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power ON"
echo "on" > /mnt/server/rpi/heating/state.txt
exit
else
:
fi


#AUTO - not needed without LEDs

if [ "$control" = "auto" ];
then
:
else
:
fi

#select which room temp to use and fetch temp from db

if [ "$room" = "bedroom" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from bedroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "living" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from livingroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "box" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from boxroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "front" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from frontroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "kitchen" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from kitchen order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "spare" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from spare order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "attic" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from attic order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "outside" ];
then
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from outside order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
elif [ "$room" = "autoroom" ];
then
currenttempliving=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from livingroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
currenttempbedroom=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from bedroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
currenttemp=$(echo "$currenttempbedroom\n$currenttempliving" | sort -n | tail -1)
elif [ "$room" = "autoaverage" ];
then
currenttempliving=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from livingroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
currenttempbedroom=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from bedroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
currenttempbox=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from boxroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
currenttemp=$(echo $currenttempliving $currenttempbedroom $currenttempbox | awk -v RS=' ' '{sum+=$1; count++} END{print sum/count}')
else
currenttemp=$(mysql --host=SERVERIPADDRESS --user=USERNAME --password=PASSWORD temptest -e"select temperature, unixtime from bedroom order by unixtime desc limit 1" --disable-column-names -B | cut -c 1-4)
fi

echo $room - $currenttemp
echo target - $targettemp
echo mintemp - $mintemp
arpscan="`cat /mnt/server/rpi/heating/arpscan.txt`"
boost="`cat /mnt/server/rpi/heating/boost.txt`"
echo boost - $boost
echo arpscan - $arpscan
#calculate whether current temp is greater than target temp
tempcalc="`echo $currenttemp'>='$targettemp | bc -l`"

currenttempround="`echo 'scale=0;' $currenttemp'/1' | bc`"
#echo $currenttempround


#if current temp is higher turn off - if current temp is lower turn on
if [ "$control" = "auto" ] && [ "$boost" = "1" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power ON"
echo "on" > /mnt/server/rpi/heating/state.txt
exit

elif [ "$control" = "auto" ] && [ "$currenttempround" -lt "$mintemp" ];
then
echo "Heating On"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power ON"
echo "on" > /mnt/server/rpi/heating/state.txt
echo 
exit


elif [ "$control" = "auto" ] && [ "$arpscan" = "1" ];
then
echo "Heating Off"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power OFF"
echo "off" > /mnt/server/rpi/heating/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "1" ];
then
echo "Heating Off"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power OFF"
echo "off" > /mnt/server/rpi/heating/state.txt
exit
elif [ "$control" = "auto" ] && [ "$tempcalc" = "0" ];
then
echo "Heating On"
curl -s -o /dev/null -G "http://192.168.1.45/cm" --data-urlencode "cmnd=Power ON"
echo "on" > /mnt/server/rpi/heating/state.txt
exit

fi

#test
