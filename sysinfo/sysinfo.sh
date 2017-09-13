#!/bin/bash

# *****************************************************************************
# **				Dmitry Onishko	2017			     **
# *****************************************************************************
# ***                               Config                                   **
# *****************************************************************************

SystemMountPoint="/";
LinesPrefix="  ";
b=$(tput bold); n=$(tput sgr0);

# *****************************************************************************
# ***                            END Config                                  **
# *****************************************************************************
Hostname=$(hostname -a)
lsb_release=$(lsb_release -a | grep Description | cut -f2);
SystemLoad=$(cat /proc/loadavg | cut -d" " -f1);
ProcessesCount=$(cat /proc/loadavg | cut -d"/" -f2 | cut -d" " -f1);

MountPointInfo=$(/bin/df -Th $SystemMountPoint 2>/dev/null | tail -n 1);
MountPointFreeSpace=( \
  $(echo $MountPointInfo | awk '{ print $6 }') \
  $(echo $MountPointInfo | awk '{ print $3 }') \
);

InodePointInfo=$(/bin/df -Ti $SystemMountPoint 2>/dev/null | tail -n 1);
InodePointFreeSpace=( \
  $(echo $InodePointInfo | awk '{ print $6 }') \
  $(echo $InodePointInfo | awk '{ print $3 }') \
);

UsersOnlineCount=$(users | wc -w);

UsedRAMsize=$(free | awk 'FNR == 2 {printf("%.0f", $3/($3+$4)*100);}');

UpTime=$(uptime | awk '{print $3" "$4}' |tr '\n' ' ' | tr -d , ; echo);

Interfaces=$(for i in `ip link list | awk '/eth/ {print $2}' |grep eth | awk -F@ '{print $1}' |tr -d ':' `; do addr=`ip addr show $i | awk '/inet / {print $2}'`; if [ ! -z $addr  ]; then echo $i $addr; fi ;done);

# loading xakep mode :)) >>>>>> apt install pv
#echo  -e "\033[37;1;41m Loading ${Hostname}............. \033[0m" | pv -qL 25
#
  echo -e "---------------------------------------------------------------------"
  echo -ne "${LinesPrefix}${b}UpTime:${n}\t${UpTime}\t";
  echo -e "${LinesPrefix}\t${b}Version:${n}${lsb_release}";

if [ ! -z "${LinesPrefix}" ] && [ ! -z "${SystemLoad}" ]; then
  echo -e "${LinesPrefix}${b}System load:${n}\t${SystemLoad}\t\t\t${b}Processes:${n}\t\t${ProcessesCount}";
fi;

if [ ! -z "${MountPointFreeSpace[0]}" ] && [ ! -z "${MountPointFreeSpace[1]}" ]; then
  echo -ne "${LinesPrefix}${b}HDD $SystemMountPoint:${n}\t${MountPointFreeSpace[0]} of ${MountPointFreeSpace[1]}\t\t";
fi;

 echo -e "${b}Users logged in:${n}\t${UsersOnlineCount}";

if [ ! -z "${InodePointFreeSpace[0]}" ] && [ ! -z "${InodePointFreeSpace[1]}" ]; then
  echo -ne "${LinesPrefix}${b}Inode $SystemMountPoint:${n}\t${InodePointFreeSpace[0]} of ${InodePointFreeSpace[1]}\t\t";
fi;

if [ ! -z "${UsedRAMsize}" ]; then
  echo -e "${b}Memory usage:${n}\t\t${UsedRAMsize}%\t";
fi;

#
 echo -e "${LinesPrefix}${b}Interfaces:${n}\n${Interfaces}"
 echo -e "---------------------------------------------------------------------"
