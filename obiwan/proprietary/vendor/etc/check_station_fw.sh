#!/vendor/bin/sh
hwid=0
hwid=`getprop vendor.station.hwid`
tp_status=3
setprop vendor.asusfw.station.tp_status $tp_status
if [ "$hwid" == "" ]; then
     hwid=0
fi

if [ "$hwid" == "none" ]; then
     hwid=0
fi

echo "[EC_HID][Touch] station hw id $hwid" > /dev/kmsg

while [ "$hwid" == "0" -a "$retry" -lt 20 ]
do
    retry=$(($retry+1))
    sleep 0.5
    hwid=`getprop vendor.station.hwid`
    if [ "$hwid" == "none" ]; then
	hwid=0
    fi
    echo "[EC_HID][Touch]retry check hwid $retry station hw id $hwid" > /dev/kmsg
done

device_PATH="/sys/devices/platform/goodix_ts_station.0/"
phone_PATH="/sys/devices/platform/goodix_ts.0/"
IC_init=`cat $device_PATH/goodix_init`

phone_tp=`cat $phone_PATH/chip_info`
phone_tp_chip=`echo $phone_tp |awk -F " " '{print $3}'`
phone_tp_chip_ver=`echo $phone_tp_chip |awk -F ":" '{print $2}'`
phone_tp_fw_info=`echo $phone_tp |awk -F " " '{print $4}'`
phone_tp_fw=`echo $phone_tp_fw_info |awk -F ":" '{print $2}'`
echo "[EC_HID][Touch] phone tp :$phone_tp chip version:$phone_tp_chip_ver fw ver :$phone_tp_fw" >/dev/kmsg

while [ "$IC_init" == "" -a "$retry" -lt 20 ]
do
    retry=$(($retry+1))
    sleep 0.5
    IC_init=`cat $device_PATH/goodix_init`
    echo "[EC_HID][Touch]retry check init state $retry Check init state :$IC_init" > /dev/kmsg
done

if [ "$IC_init" == "" ]; then
    echo "[EC_HID][Touch] station init fail" > /dev/kmsg
    station_tp_fw="version_wrong"
    exit
else
    echo "[EC_HID][Touch] station init complete" > /dev/kmsg
fi

station_tp=`cat $device_PATH/chip_info`
station_tp_chip=`echo $station_tp |awk -F " " '{print $3}'`
station_tp_chip_ver=`echo $station_tp_chip |awk -F ":" '{print $2}'`
station_tp_fw_info=`echo $station_tp |awk -F " " '{print $4}'`
station_tp_fw=`echo $station_tp_fw_info |awk -F ":" '{print $2}'`
echo "[EC_HID][Touch] station tp :$station_tp chip version:$station_tp_chip_ver fw ver :$station_tp_fw" >/dev/kmsg

tp_fw_9886=`cat $device_PATH/fw_9886_info`

echo "[EC_HID][Touch]station hw id $hwid station TP fw:$station_tp_fw phone TP fw:$phone_tp_fw" > /dev/kmsg

if [ "$hwid" != "0x3" ]; then
    if [ "$hwid" == "0x2" ]; then
         setprop vendor.asusfw.station.tp_fwver $tp_fw_9886
        if [ "$station_tp_fw" == "$tp_fw_9886" ]; then
	    echo "[EC_HID][Touch] Station TP FW Ver $station_tp_fw is the newest" > /dev/kmsg
	    tp_status=0
        elif [ "$station_tp_fw" == "i2c_error" ] || [ "$station_tp_fw" == "version_wrong" ]; then
	    echo "[EC_HID][Touch] Station TP FW Ver Error" > /dev/kmsg
 	    tp_status=0
        else
	    echo "[EC_HID][Touch] Station TP FW Ver update" > /dev/kmsg
	    tp_status=1
        fi		
    else
        echo "[EC_HID][Touch] Unable read HW version, try check chip version" > /dev/kmsg
	if [ $station_tp_chip_ver == "9886" ]; then
	    setprop vendor.asusfw.station.tp_fwver $tp_fw_9886
	    if [ "$station_tp_fw" == "$tp_fw_9886" ]; then
		echo "[EC_HID][Touch] Station TP FW Ver $station_tp_fw is the newest" > /dev/kmsg
		tp_status=0
	    elif [ "$station_tp_fw" == "i2c_error" ] || [ "$station_tp_fw" == "version_wrong" ]; then
		echo "[EC_HID][Touch] Station TP FW Ver Error" > /dev/kmsg
		tp_status=0
	    else
		echo "[EC_HID][Touch] Station TP FW Ver update" > /dev/kmsg
		tp_status=1
	    fi		
	elif [ $station_tp_chip_ver == "9896" ]; then
	    setprop vendor.asusfw.station.tp_fwver $phone_tp_fw
	    if [ "$station_tp_fw" == "$phone_tp_fw" ]; then
		echo "[EC_HID][Touch] Station TP FW Ver $station_tp_fw is the newest" > /dev/kmsg
		tp_status=0
	    elif [ "$station_tp_fw" == "i2c_error" ] || [ "$station_tp_fw" == "version_wrong" ]; then
		echo "[EC_HID][Touch] Station TP FW Ver Error" > /dev/kmsg
		tp_status=0
	    else
		echo "[EC_HID][Touch] Station TP FW Ver update" > /dev/kmsg
		tp_status=1
	    fi    
	else
	    echo "[EC_HID][Touch] Unable read tp chip version" > /dev/kmsg
	    tp_status=0
	fi
    fi
else
    if [ $station_tp_chip_ver == "9886" ]; then
	echo "[EC_HID][Touch] unreliable hwid skip update fw , touch ic is $station_tp_chip_ver " > /dev/kmsg
        setprop vendor.asusfw.station.tp_status 0
        exit
    fi
    
    setprop vendor.asusfw.station.tp_fwver $phone_tp_fw
    if [ "$station_tp_fw" == "$phone_tp_fw" ]; then
	echo "[EC_HID][Touch] Station TP FW Ver $station_tp_fw is the newest" > /dev/kmsg
	tp_status=0
    elif [ "$station_tp_fw" == "i2c_error" ] || [ "$station_tp_fw" == "version_wrong" ]; then
        echo "[EC_HID][Touch] Station TP FW Ver Error" > /dev/kmsg
	tp_status=0
    else
	echo "[EC_HID][Touch] Station TP FW Ver update" > /dev/kmsg
	tp_status=1
    fi
fi

station_tp_cfg=`cat $device_PATH/read_cfg|sed -n '1 p'|awk 'BEGIN{FS=" "}{print $1}'`

echo "[EC_HID][Touch] set station tp_fw $station_tp_fw CFG:$((16#$station_tp_cfg))" > /dev/kmsg
setprop vendor.station.tp_fwver "$station_tp_fw CFG:$((16#$station_tp_cfg))"
setprop vendor.asusfw.station.tp_status $tp_status
exit