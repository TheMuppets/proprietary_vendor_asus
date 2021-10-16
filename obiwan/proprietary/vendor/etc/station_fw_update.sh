#!/vendor/bin/sh

type=`getprop vendor.station.ec_fwupdate`
pd_is_need_update=`getprop vendor.asus.accy.fw_status2`

if [ "$type" == "0" ]; then
	echo "[EC_HID] No need update EC FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	echo "[EC_HID] Start EC FW update " > /dev/kmsg
fi
echo 0 > /sys/class/ec_i2c/dongle/device/duty

echo 1 > /sys/class/ec_hid/dongle/device/lock

/vendor/bin/eneEcUpdate > /dev/kmsg
result="$?"
echo "[EC_HID] EC FW update result: $result." > /dev/kmsg

if [ "$result" != 0 ]; then
	echo "[EC_HID] Retry FW update." > /dev/kmsg
	sleep 3
	/vendor/bin/eneEcUpdate > /dev/kmsg
fi

echo 0 > /sys/class/ec_hid/dongle/device/lock

# wait HID reconnect
sleep 10

echo "[EC_HID] Finish EC FW update" > /dev/kmsg

uart_state=`getprop persist.vendor.asus.audbg_station`
if [ "$uart_state" == "1" ]; then
	echo 1 > /sys/class/ec_i2c/dongle/device/uart
else
	echo 0 > /sys/class/ec_i2c/dongle/device/uart
fi

generation=`getprop vendor.station.generation`
if [ "$generation" == "2" ]; then
	ec_fw=`getprop vendor.asusfw.station2.ec_fwver`
elif [ "$generation" == "3" ]; then
	ec_fw=`getprop vendor.asusfw.station3.ec_fwver`
else
	ec_fw=`getprop vendor.asusfw.station2.ec_fwver`
fi

fw_ver=`cat /sys/class/ec_i2c/dongle/device/fw_ver`
if [ "${fw_ver}" != "${ec_fw}" ]; then
	echo "[EC_HID] EC FW update fail, $fw_ver != $ec_fw" > /dev/kmsg
	if [ "$pd_is_need_update" != "100000" ];then
		echo 1 > /sys/class/ec_i2c/dongle/device/restore_display_config
		echo 1 > /sys/class/ec_i2c/dongle/device/reconnect_dp
	fi
	setprop vendor.station.ec_fwupdate  2
else
	if [ "$pd_is_need_update" != "100000" ];then
		echo "[EC_HID] Update EC FW only" > /dev/kmsg
		echo 1 > /sys/class/ec_i2c/dongle/device/restore_display_config
		echo 1 > /sys/class/ec_i2c/dongle/device/reconnect_dp
	else
		echo "[EC_HID] Update EC FW and PD FW" > /dev/kmsg
		echo 1 > /sys/class/ec_i2c/dongle/device/restore_display_config
	fi
	setprop vendor.station.ec_fwupdate  0

	if [ "$generation" == "2" ]; then
		setprop vendor.station2.ec_fwver $fw_ver
	elif [ "$generation" == "3" ]; then
		setprop vendor.station3.ec_fwver $fw_ver
	else
		setprop vendor.station2.ec_fwver $fw_ver
	fi
fi

#start DongleFWCheck
setprop vendor.asus.accy.fw_status 000000
echo 1 > /sys/class/leds/aura_station/VDD
