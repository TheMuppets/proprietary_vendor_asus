#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`

if [ "$type" != "3" ]; then
	echo "[ENE_DT] In accy $type, skip update." > /dev/kmsg
	setprop vendor.dt.power_fwupdate 0
	exit
fi

sleep 0.5

FW_PATH="/vendor/asusfw/DT_power/DT_EC.bin"
fw_ver=`cat /sys/class/leds/DT_power/fw_ver`
dt_fw=`getprop vendor.asusfw.dt.power_fwver`

echo "[ENE_DT] dt_fw : ${dt_fw}" > /dev/kmsg
echo "[ENE_DT] fw_ver : ${fw_ver}" > /dev/kmsg

echo 1 > /sys/class/leds/DT_power/pause

if [ "${fw_ver}" != "${dt_fw}" ]; then
    echo "[ENE_DT] Strat ENE 8K41 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/DT_power/fw_update
else
    echo "[ENE_DT] No need update" > /dev/kmsg
fi

fw_ver=`cat /sys/class/leds/DT_power/fw_ver`
if [ "${fw_ver}" != "${dt_fw}" ]; then
	echo "[ENE_DT] ENE 8K41 FW update fail" > /dev/kmsg
	setprop vendor.dt.power_fwupdate 2
else
	setprop vendor.dt.power_fwupdate 0
fi

echo 0 > /sys/class/leds/DT_power/pause

echo "[ENE_DT] wait AURA_DT power on" > /dev/kmsg
sleep 3

#start DongleFWCheck
setprop vendor.asus.accy.fw_status 000000
