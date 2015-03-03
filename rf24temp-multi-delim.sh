#!/bin/sh
#
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
currdate="`date +%Y-%m-%d_%H-%M-%S`"

curryear="`date +%Y`"
currmonth="`date +%m`"
currday="`date +%d`"
currhour="`date +%H`"
currmin="`date +%M`"
currsec="`date +%S`"
unixtime="`date +%s`"



# 01
if [ -f /dev/shm/rf24weather01.txt ];
then

STR="`cat /dev/shm/rf24weather01.txt`"
node=$(echo $STR | cut -f1 -d,)
temp=$(echo $STR | cut -f2 -d,)
time=$(echo $STR | cut -f3 -d,)

temp1=$(echo "scale=2;$temp/100" | bc)

mysql --host=xxx.xxx.xxx.xxx --user=username --password=password temptest -e"insert into rf24test (fulldate, unixtime, year, month, day, hour, minute, second, temperature) values ('$currdate', '$time', '$curryear', '$currmonth', '$currday', '$currhour', '$currmin', '$currsec', '$temp1')"
rm /dev/shm/rf24weather01.txt
else
:
fi

# 02

if [ -f /dev/shm/rf24weather02.txt ];
then

STR="`cat /dev/shm/rf24weather02.txt`"
node=$(echo $STR | cut -f1 -d,)
temp=$(echo $STR | cut -f2 -d,)
time=$(echo $STR | cut -f3 -d,)

temp1=$(echo "scale=2;$temp/100" | bc)

mysql --host=xxx.xxx.xxx.xxx --user=username --password=password temptest -e"insert into rf24test02 (fulldate, unixtime, year, month, day, hour, minute, second, temperature) values ('$currdate', '$time', '$curryear', '$currmonth', '$currday', '$currhour', '$currmin', '$currsec', '$temp1')"
rm /dev/shm/rf24weather02.txt

else
:
fi

# 03

if [ -f /dev/shm/rf24weather03.txt ];
then

STR="`cat /dev/shm/rf24weather03.txt`"
node=$(echo $STR | cut -f1 -d,)
temp=$(echo $STR | cut -f2 -d,)
time=$(echo $STR | cut -f3 -d,)

temp1=$(echo "scale=2;$temp/100" | bc)

mysql --host=xxx.xxx.xxx.xxx --user=username --password=password temptest -e"insert into rf24test03 (fulldate, unixtime, year, month, day, hour, minute, second, temperature) values ('$currdate', '$time', '$curryear', '$currmonth', '$currday', '$currhour', '$currmin', '$currsec', '$temp1')"
rm /dev/shm/rf24weather03.txt

else
:
fi

# 04

if [ -f /dev/shm/rf24weather04.txt ];
then

STR="`cat /dev/shm/rf24weather04.txt`"
node=$(echo $STR | cut -f1 -d,)
temp=$(echo $STR | cut -f2 -d,)
time=$(echo $STR | cut -f3 -d,)

temp1=$(echo "scale=2;$temp/100" | bc)

mysql --host=xxx.xxx.xxx.xxx --user=username --password=password temptest -e"insert into rf24test04 (fulldate, unixtime, year, month, day, hour, minute, second, temperature) values ('$currdate', '$time', '$curryear', '$currmonth', '$currday', '$currhour', '$currmin', '$currsec', '$temp1')"
rm /dev/shm/rf24weather04.txt

else
:
fi
