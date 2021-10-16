#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`

if [ "$type" != "3" ]; then
	echo "[AURA_DT] DT didn't exist. Type is type$" > /dev/kmsg
	setprop vendor.dt.aura_fwupdate 0
    exit
fi

echo "[AURA_DT] Enable VDD" > /dev/kmsg
echo 1 > /sys/class/leds/aura_dock/VDD
sleep 0.5

FW_PATH="/vendor/asusfw/aura_sync/ENE-8K41-aura-dt.bin"
fw_ver=`cat /sys/class/leds/aura_dock/fw_ver`
aura_fw=`getprop vendor.asusfw.dt.aura_fwver`

echo "[AURA_DT] aura_fw : ${aura_fw}" > /dev/kmsg
echo "[AURA_DT] fw_ver : ${fw_ver}" > /dev/kmsg

if [ "$type" == "3" ]; then
    echo 1 > /sys/class/leds/DT_power/pause
fi

if [ "${fw_ver}" != "${aura_fw}" ]; then
    echo "[AURA_DT] Start ENE 8K41 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/aura_dock/fw_update
else
    echo "[AURA_DT] No need update" > /dev/kmsg
fi

fw_ver=`cat /sys/class/leds/aura_dock/fw_ver`
if [ "${fw_ver}" != "${aura_fw}" ]; then
	echo "[AURA_DT] ENE 8K41 FW update fail" > /dev/kmsg
	echo 0 > /sys/class/leds/DT_power/pause
	setprop vendor.dt.aura_fwupdate 2
else
	echo 0 > /sys/class/leds/DT_power/pause
	setprop vendor.dt.aura_fwver $fw_ver
	setprop vendor.dt.aura_fwupdate 0
fi

#start DongleFWCheck
