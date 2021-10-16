#!/vendor/bin/sh


function remove_mod(){

	if [ -n "$1" ]; then
		echo "[EC_HID] remove_mod $1" > /dev/kmsg
	else
		exit
	fi

	test=1
	retry=1
	while [ "$test" == 1 -a "$retry" -le "5" ]
	do
		rmmod $1
		ret=`lsmod | grep $1`
		if [ "$ret" == "" ]; then
			echo "[EC_HID] rmmod $1 success" > /dev/kmsg
			test=0
		else
			echo "[EC_HID] rmmod $1 fail" > /dev/kmsg
			test=1
			sleep 0.5
		fi
		((retry++))
	done
}

echo 1 > /sys/class/ec_hid/dongle/device/pogo_sync_key

echo 0 > /sys/class/ec_i2c/dongle/device/duty
echo "[EC_HID][ec_i2c_rmmod][STATION_FAN]disable fan" > /dev/kmsg

#remove_mod station_focaltech_touch
remove_mod station_goodix_touch
remove_mod station_key
remove_mod ene_6k582_station

setprop vendor.station2.ec_fwver 0
setprop vendor.station3.ec_fwver 0
setprop vendor.station.aura_fwver 0
setprop vendor.station.tp_fwver 0
setprop vendor.station.dp_fwver 0
setprop vendor.station.pd_fwver 0
setprop vendor.asusfw.station.tp_fwver ""

setprop vendor.asus.accy.fw_status 000000
setprop vendor.asus.accy.fw_status2 000000

echo 13 > /sys/class/ec_hid/dongle/device/sync_state

echo 0 > /sys/class/ec_hid/dongle/device/pogo_sync_key

echo 1 > /sys/class/ec_hid/dongle/device/is_ec_has_removed
