#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`

if [ "$type" != "2" ]; then
	echo "[AURA_STATION] Station didn't exist. Type is type$" > /dev/kmsg
	setprop vendor.station.aura_fwupdate 0
	exit
fi

echo 1 > /sys/class/leds/aura_station/update_state
echo "[AURA_STATION] Enable VDD" > /dev/kmsg
echo 1 > /sys/class/leds/aura_station/VDD
sleep 0.5

FW_PATH="/vendor/asusfw/aura_sync/6K5xxx_Yoda.Bin"
fw_ver=`cat /sys/class/leds/aura_station/fw_ver`
aura_fw=`getprop vendor.asusfw.station.aura_fwver`

echo "[AURA_STATION] aura_fw : ${aura_fw}" > /dev/kmsg
echo "[AURA_STATION] fw_ver : ${fw_ver}" > /dev/kmsg

if [ "${fw_ver}" != "${aura_fw}" ]; then
    echo "[AURA_STATION] Start ENE 6k582 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/aura_station/fw_update
else
	echo "[AURA_STATION] No need update" > /dev/kmsg
	setprop vendor.station.aura_fwupdate 0
	exit
fi

sleep 1
fw_ver=`cat /sys/class/leds/aura_station/fw_ver`
if [ "${fw_ver}" != "${aura_fw}" ]; then
	echo "[AURA_STATION] ENE 6k582 FW update fail" > /dev/kmsg
	setprop vendor.station.aura_fwupdate 2
else
	setprop vendor.station.aura_fwver $fw_ver
	setprop vendor.station.aura_fwupdate 0
fi
echo 0 > /sys/class/leds/aura_station/update_state
#start DongleFWCheck
