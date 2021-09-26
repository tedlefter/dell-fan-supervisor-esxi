# dell-fan-supervisor-esxi
Custom silent fan profile

The script will check the CPU temperature ever 2 seconds.
Fans will be set to manual and low RPM unless the temperature reaches the UPPER_TEMP value.
Upon reaching the upper value, the iDRAC settings kick in, manual mode is disabled.

## Prerequisite
For this to work, the script relies on the ipmitool binary.
Make sure to install the ipmitool.vib provided in the repository.
The ipmitool.vib was compiled and packaged by: [vsswitchzero](https://vswitchzero.com/ipmitool-vib/)
Follow the above link for tutorials.

## Build and Install
Customizations can be applied to the scripts.
To build a new vib package, follow these steps

1. Update the `SENSOR_ID` value in the `start_fan_supervisor.sh` script.
To get your sensor id run this after installing the ipmitool.
```/opt/ipmitool/ipmitool sdr type temperature```
Sample output:
```
Inlet Temp       | 04h | ok  |  7.1 | 26 degrees C
Temp             | 0Eh | ok  |  3.1 | 49 degrees C
Temp             | 0Fh | ok  |  3.2 | 52 degrees C
```
Select the sensor id to be monitored and update the `SENSOR_ID` value.

2. Modify the scripts to your needs.

3. Increment the version in `stage/descriptor.xml`

4. Run docker with vibauthor while mounting the code path in docker.
```sudo docker run --rm -it -v '<path_to>/dell-fan-supervisor-esxi':'/data' lamw/vibauthor```

5. Change directory to the mounted one from above (i.e data)
```cd /data```

6. Run the vibauthor tool to create the package
```
vibauthor -C -t fan_supervisor -v fan_supervisor.vib -O fan_supervisor-offline-bundle.zip -f
exit
```

7. Enable SSH on the ESXI instance and copy the vib package.
```scp fan_supervisor.vib <user>@<esxi_ip>:/tmp```

8. Install the package
```esxcli software vib install -v /tmp/fan_supervisor.vib -f```