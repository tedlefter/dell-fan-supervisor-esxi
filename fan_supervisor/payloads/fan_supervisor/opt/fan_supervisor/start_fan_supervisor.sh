#!/bin/sh

UPPER_TEMP=55
LOWER_TEMP=50
SENSOR_ID=0Eh

# Check for current temp
# If above UPPER_TEMP set controls to iDRAC
# If below LOWER_TEMP set manual controls and lower fans RPM

echo "Starting fan supervisor..."
while :
do
    CPU_TEMP_STRING=$(/opt/ipmitool/ipmitool sdr type temperature | grep $SENSOR_ID)
    CPU_TEMP_VALUE=$(echo $CPU_TEMP_STRING | cut -d "|" -f 5 | cut -d " " -f 2)
    echo "Status: Current temperature:" $CPU_TEMP_VALUE

    if [ $CPU_TEMP_VALUE -gt $UPPER_TEMP ]
    then
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x01 0x01 > /dev/null
        echo "Status: Fan mode set to iDRAC"
    elif [ $CPU_TEMP_VALUE -lt $LOWER_TEMP ]
    then
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x01 0x00 > /dev/null
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x02 0xff 0x0F > /dev/null
        echo "Status: Fan mode set to manual low RPM"
    else
        echo "Status: OK"
    fi
    echo

    sleep 2
done
