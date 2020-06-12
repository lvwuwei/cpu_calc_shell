#!/bin/sh
# get the free memory
freemem=$(head -n 2 /proc/meminfo | tail -n 1 | awk '{print $2}')
echo $freemem
echo $freemem >> resout
##echo user nice system idle iowait irq softirq
CPULOG_1=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
SYS_IDLE_1=$(echo $CPULOG_1 | awk '{print $4}')
Total_1=$(echo $CPULOG_1 | awk '{print $1+$2+$3+$4+$5+$6+$7}')
sleep 5
CPULOG_2=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
CPULOG_3=$(echo "$CPULOG_1 $CPULOG_2" | awk '{print $8-$1" "$9-$2" "$10-$3" "$11-$4" "$12-$5" "$13-$6" "$14-$7}')
SYS_IDLE_2=$(echo $CPULOG_2 | awk '{print $4}')
Total_2=$(echo $CPULOG_2 | awk '{print $1+$2+$3+$4+$5+$6+$7}')
#echo $SYS_IDLE_2
#echo $SYS_IDLE_1
SYS_IDLE=`expr $SYS_IDLE_2 - $SYS_IDLE_1`
Total=$(echo "$CPULOG_3" | awk '{print $1+$2+$3+$4+$5+$6+$7}')
echo $SYS_IDLE
echo $SYS_IDLE >> resout
echo $Total
echo $Total  >> resout
#SYS_USAGE=`expr $SYS_IDLE/$Total*100`
#SYS_Rate=`expr 100-$SYS_USAGE`
#Disp_SYS_Rate=`expr "scale=3; $SYS_Rate/1"`
#echo $Disp_SYS_Rate%
