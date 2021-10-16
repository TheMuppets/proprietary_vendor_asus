#!/vendor/bin/sh

declare -i retry

type=`getprop vendor.station.pd_fwupdate`
updateon=`getprop vendor.station.updatepdon`

echo "[PD_Station] PD FW update" > /dev/kmsg

if [ "$type" == "0" ]; then
	echo "[PD_Station] No need update PD FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	FW_PATH="/vendor/asusfw/station/IT5213.bin"
fi

if [ "$updateon" != "1" ]; then
	echo "[PD_Station] PD update trun off" > /dev/kmsg
	setprop vendor.station.pd_fwupdate 0
	exit
fi

lsusb > /dev/kmsg

while [ "$(lsusb | grep -E "048d:5212|048d:52db")" == "" -a "$retry" -lt 3 ]
do
	retry=$(($retry+1))

	if [ "$retry" -eq 3 ]; then
		echo "[PD_Station] can't find pdhid device" > /dev/kmsg
		setprop vendor.station.pd_fwupdate 2
		exit
	fi

	sleep 1
done

echo "[PD_Station] Start PD FW update : $FW_PATH" > /dev/kmsg

/vendor/bin/StationPDFwUpdater /vendor/asusfw/station/IT5213.bin > /dev/kmsg

if [ "$?" != "1" ]; then
	echo "[PD_Station] PD FW update fail" > /dev/kmsg
	setprop vendor.station.pd_fwupdate 2
else
	echo "[PD_Station] PD FW update OK" > /dev/kmsg
	setprop vendor.station.pd_fwupdate 0
fi

sleep 2

st_pdfw=`cat /sys/class/ec_i2c/dongle/device/PD_FW`
if [ "$st_pdfw" == "FF" ]; then
	st_pdfw=""
fi

setprop vendor.station.pd_fwver $st_pdfw

setprop vendor.asus.accy.fw_status2 000000

#echo 1 > /sys/class/ec_i2c/dongle/device/set_prota_cc
