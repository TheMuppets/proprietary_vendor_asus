#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
hubdetect=`getprop vendor.dt.hubdetect`
LOG_TAG="DT_hub_Detect"
hub1_version=''
hub2_version=''
HUB1_FW_VER=`getprop vendor.asusfw.dt.hub1_fwver`
HUB2_FW_VER=`getprop vendor.asusfw.dt.hub2_fwver`

echo "$LOG_TAG:[USB_ACCY] DT hub detected = $hubdetect" > /dev/kmsg
if [ "$type" == "3" ]; then
	if [ "$hubdetect" == "1" ];then
		sleep 4
		type=`getprop vendor.asus.dongletype`
		if [ "$type" == "3" ]; then
			hub1_version=`cat /sys/module/usbcore/parameters/DT_hub1_ver`
			if [ "$hub1_version" == "ffff" -o -z "$hub1_version" ];then
				hub1_version='0'
			fi
			echo "$LOG_TAG:[USB_ACCY] DT hub1 version = $hub1_version" > /dev/kmsg
			setprop vendor.dt.hub1_fwver $hub1_version
			hub2_version=`cat /sys/module/usbcore/parameters/DT_hub2_ver`
			if [ "$hub2_version" == "ffff" -o -z "$hub2_version" ];then
				hub2_version='0'
			fi
			echo "$LOG_TAG:[USB_ACCY] DT hub2 version = $hub2_version" > /dev/kmsg
			setprop vendor.dt.hub2_fwver $hub2_version
			setprop vendor.dt.accy_statusupdate 1
		else
			echo "$LOG_TAG:[USB_ACCY] DT is disconnect, ignore" > /dev/kmsg
			setprop vendor.dt.hub1_fwver ''
			setprop vendor.dt.hub2_fwver ''
		fi
	fi
else
	echo "$LOG_TAG:[USB_ACCY] not connect DT" > /dev/kmsg
	setprop vendor.dt.hub1_fwver ''
	setprop vendor.dt.hub2_fwver ''
fi


