#!/bin/sh

echo "Stopping fan supervisor..."
echo "Enabling iDRAC fan control"
/opt/ipmitool/ipmitool raw 0x30 0x30 0x01 0x01
