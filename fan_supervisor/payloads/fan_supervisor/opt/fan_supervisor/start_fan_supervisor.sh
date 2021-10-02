#!/bin/sh

UPPER_TEMP=55
LOWER_TEMP=50
SENSOR_ID_CPU_1=0Eh
SENSOR_ID_CPU_2=0Fh

# Check for current temp
# If above UPPER_TEMP set controls to iDRAC
# If below LOWER_TEMP set manual controls and lower fans RPM

extract_temp() {
    local cpuTempReport=$(/opt/ipmitool/ipmitool sdr type temperature | grep $1)
    local cpuTempValue=$(echo $cpuTempReport | cut -d "|" -f 5 | cut -d " " -f 2)
    echo $cpuTempValue
}


echo "Starting fan supervisor..."
while :
do
    cpu1Temp=$( extract_temp $SENSOR_ID_CPU_1 )
    cpu2Temp=$( extract_temp $SENSOR_ID_CPU_2 )

    cpuTemp=$(( $cpu1Temp > $cpu2Temp ? $cpu1Temp : $cpu2Temp ))

    echo "Status: Current temperature:" $cpuTemp

    if [ $cpuTemp -gt $UPPER_TEMP ]
    then
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x01 0x01 > /dev/null
        echo "Status: Fan mode set to iDRAC"
    elif [ $cpuTemp -lt $LOWER_TEMP ]
    then
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x01 0x00 > /dev/null
        /opt/ipmitool/ipmitool raw 0x30 0x30 0x02 0xff 0x0F > /dev/null
        echo "Status: Fan mode set to manual low RPM"
    else
        echo "Status: OK"
    fi
    echo

    sleep 1
done
