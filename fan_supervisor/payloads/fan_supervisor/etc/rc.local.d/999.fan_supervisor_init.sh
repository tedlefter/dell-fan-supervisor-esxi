#!/bin/sh
# chkconfig: 2345 20 80
# description: Start the fan supervisor

start() {
   /opt/fan_supervisor/start_fan_supervisor.sh &
   FAN_SUPERVISOR_PID=$!
   echo $FAN_SUPERVISOR_PID > /opt/fan_supervisor/fan_supervisor_pid
}

stop() {
   read FAN_SUPERVISOR_PID < /opt/fan_supervisor/fan_supervisor_pid
   kill $FAN_SUPERVISOR_PID
   rm /opt/fan_supervisor/fan_supervisor_pid
   /opt/fan_supervisor/stop_fan_supervisor.sh
}

case "$1" in 
   start)
      start
      ;;
   stop)
      stop
      ;;
   restart)
      stop
      start
      ;;
   status)
      echo "No status"
      ;;
   *)
      start
esac

exit 0
