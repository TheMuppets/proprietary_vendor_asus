#!/vendor/bin/sh

BATTERY=`cat /sys/class/extcon/battery/name`
setprop vendor.battery.version.driver "$BATTERY"
