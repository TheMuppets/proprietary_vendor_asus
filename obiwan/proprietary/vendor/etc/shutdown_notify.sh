#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`

if [ "$type" == "2" ]; then
    echo "[shutdown_notify][DP]Do not disconnect dp for station" > /dev/kmsg
elif [ "$type" == "3" ]; then
    echo "[shutdown_notify][DP]Do not disconnect dp for DT" > /dev/kmsg
else
    echo 0 > /sys/class/drm/dp_connect
    echo "[shutdown_notify][DP]disconnect dp" > /dev/kmsg
fi

if [ "$type" == "0" ]; then
	exit

elif [ "$type" == "1" ]; then
	echo "[shutdown_notify] Inbox" > /dev/kmsg

elif [ "$type" == "2" ]; then
	echo "[shutdown_notify] Station" > /dev/kmsg
	echo 0 > /sys/class/ec_i2c/dongle/device/duty
	echo "[shutdown_notify][STATION_FAN]disable fan" > /dev/kmsg
	echo 0 > /sys/class/leds/aura_station/mode
	echo 1 > /sys/class/leds/aura_station/apply
	echo "[shutdown_notify]disable AURA(6K582) by set mode 0" > /dev/kmsg

elif [ "$type" == "3" ]; then
	echo "[shutdown_notify] DT" > /dev/kmsg

elif [ "$type" == "4" ]; then
	echo "[shutdown_notify]Type Error!!" > /dev/kmsg

else
	echo "[shutdown_notify]Error Type $type" > /dev/kmsg
fi


