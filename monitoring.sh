#!/bin/bash

uram=$(free -m | awk '$1 == "Mem:" {print $3}')
tram=$(free -m | awk '$1 == "Mem:" {print $2}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
udisk=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{ud += $3} END {print ud}')
tdisk=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{td += $2} END {print td}')
pdisk=$(df --total | grep total | awk '{print $5}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)

wall "
#Architecture: $(uname -a)
#CPU physical : $(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
#vCPU : $(grep "^processor" /proc/cpuinfo | wc -l)
#Memory Usage: $uram/${tram}MB ($pram%)
#Disk Usage: $udisk/${tdisk}Gb ($pdisk)
#CPU load: $(top -bn1 | grep "^%Cpu" | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
#Last boot: $(who -b | awk '{print $3 " " $4}')
#LVM use: $lvmu
#Connexions TCP : $(grep TCP /proc/net/sockstat | awk '{print $3}') ESTABLISHED
#User log: $(users | wc -l)
#Network: IP $(hostname -I)($(ip link show | awk '$1 == "link/ether" {print $2}'))
#sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd
"
