#!/vendor/bin/sh
echo "[EC_HID][TPFW] check fw update" > /dev/kmsg

device_PATH="/sys/devices/platform/goodix_ts_station.0/"
phone_PATH="/sys/devices/platform/goodix_ts.0/"
IC_init=`cat $device_PATH/goodix_init`
hwid=`getprop vendor.station.hwid`

if [ "$IC_init" == "" ]; then
	echo "[EC_HID][TPFW] station init not complete" > /dev/kmsg
	sleep 2
	IC_init=`cat $device_PATH/goodix_init`
	echo "[EC_HID][TPFW] Check init state :$IC_init!!" > /dev/kmsg
	if [ "$IC_init" == "" ]; then
	    echo "[EC_HID][TPFW] station init fail" > /dev/kmsg
	    station_tp_fw="version_wrong"
	    exit
	fi
else
	echo "[EC_HID][TPFW] station init complete" > /dev/kmsg
fi

phone_tp=`cat $phone_PATH/chip_info`
phone_tp_chip=`echo $phone_tp |awk -F " " '{print $3}'`
phone_tp_chip_ver=`echo $phone_tp_chip |awk -F ":" '{print $2}'`
phone_tp_fw_info=`echo $phone_tp |awk -F " " '{print $4}'`
phone_tp_fw=`echo $phone_tp_fw_info |awk -F ":" '{print $2}'`
echo "[EC_HID][Touch] phone tp :$phone_tp chip version:$phone_tp_chip_ver fw ver :$phone_tp_fw" >/dev/kmsg

station_tp=`cat $device_PATH/chip_info`
station_tp_chip=`echo $station_tp |awk -F " " '{print $3}'`
station_tp_chip_ver=`echo $station_tp_chip |awk -F ":" '{print $2}'`
station_tp_fw_info=`echo $station_tp |awk -F " " '{print $4}'`
station_tp_fw=`echo $station_tp_fw_info |awk -F ":" '{print $2}'`
echo "[EC_HID][Touch] station tp :$station_tp chip version:$station_tp_chip_ver fw ver :$station_tp_fw" >/dev/kmsg

station_tp_cfg=`cat $device_PATH/read_cfg|sed -n '1 p'|awk 'BEGIN{FS=" "}{print $1}'`
tp_fw_9886=`cat $device_PATH/fw_9886_info`

echo "[EC_HID][TPFW] hwid $hwid station TP fw:$station_tp_fw phone TP fw:$phone_tp_fw" > /dev/kmsg

if [ "$hwid" == "0x3" ]; then
    if [ $station_tp_chip_ver == "9886" ];then
        echo "[EC_HID][TPFW] unreliable hwid skip update fw , touch ic is $station_tp_chip_ver " > /dev/kmsg
        setprop vendor.station.tp_fwupdate 2
        exit
    fi
    
    if [ "$station_tp_fw" = "$phone_tp_fw" ];then
	echo "[EC_HID][TPFW] FW is new didn't upgrade!" > /dev/kmsg
    else
	echo "[EC_HID][TPFW] FW ver $station_tp_fw need upgrade to $phone_tp_fw !" > /dev/kmsg
	echo 1 > $device_PATH/fw_update
	sleep 1
	echo 2 > $device_PATH/fwupdate/update_en
	
	fw_upgrate_progress=`cat $device_PATH/fw_progress`
	echo "[EC_HID][TPFW] fw updating... $fw_upgrate_progress" > /dev/kmsg

	if [ "$fw_upgrate_progress" != "100" ]; then
	    echo "[EC_HID][TPFW] update fail!!" > /dev/kmsg
	    setprop vendor.station.tp_fwupdate 2
	    exit
	else
	    echo "[EC_HID][TPFW] update complete!!" > /dev/kmsg
	    echo 0 > $device_PATH/fw_update
	fi
    fi
else
    if [ $station_tp_chip_ver != "9886" ];then
	echo "[EC_HID][TPFW] unreliable hwid skip update fw , touch ic is $station_tp_chip_ver " > /dev/kmsg
	setprop vendor.station.tp_fwupdate 2
	exit
    fi
	
    if [ "$station_tp_fw" = "$tp_fw_9886" ];then
	echo "[EC_HID][TPFW] FW is new didn't upgrade!" > /dev/kmsg
    else
	echo "[EC_HID][TPFW] FW ver $station_tp_fw need upgrade to $tp_fw_9886 !" > /dev/kmsg
	echo 1 > $device_PATH/fw_update
	sleep 1
	echo 2 > $device_PATH/fwupdate/update_en
	
	fw_upgrate_progress=`cat $device_PATH/fw_progress`
	echo "[EC_HID][TPFW] fw updating... $fw_upgrate_progress" > /dev/kmsg

	if [ "$fw_upgrate_progress" != "100" ]; then
	    echo "[EC_HID][TPFW] update fail!!" > /dev/kmsg
	    setprop vendor.station.tp_fwupdate 2
	    exit
	else
	    echo "[EC_HID][TPFW] update complete!!" > /dev/kmsg
	    echo 0 > $device_PATH/fw_update
	fi
    fi
fi

sleep 1

fw_verion_now=`cat $device_PATH/chip_info|sed -n '3 p' |awk -F ":" '{print $NF}'`
if [ "$station_tp_chip_ver" == "9886" ]; then
    fw_verion_new=$tp_fw_9886
else
    fw_verion_new=$phone_tp_fw
fi

if [ "$fw_verion_now" = "$fw_verion_new" ];then
	echo "[EC_HID][TPFW] update to $fw_verion_new successfully" > /dev/kmsg
	station_tp_cfg=`cat $device_PATH/read_cfg|sed -n '1 p'|awk 'BEGIN{FS=" "}{print $1}'`
	setprop vendor.station.tp_fwver "$fw_verion_now CFG:$((16#$station_tp_cfg))"
	setprop vendor.station.tp_fwupdate 0
else
	echo "[EC_HID][TPFW] update to $fw_verion_new fail!!" > /dev/kmsg
	setprop vendor.station.tp_fwupdate 2
fi
