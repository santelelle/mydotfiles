#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

xrandr --query | grep -w 'DP-1' | grep -w connected
external_monitor_connected=$?  # this is 0 if the monitor is connected

if [ $external_monitor_connected -eq 0 ]; then
	polybar top &
	polybar top_external &
else
	polybar top_main &
fi

echo "Polybar launched..."
