#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
update_flag=`getprop vendor.dt.hub1_fwupdate`
fw_status2=`getprop vendor.asus.accy.fw_status2`
LOG_TAG="[DT_HUB1]"
hub1_version=`getprop vendor.dt.hub1_fwver`
lsusb_PATH="/data/vendor/gl_usb_list"
FW_PATH="/vendor/asusfw/DT_hub_fw/DT_6961_HUB1.bin"
FW_VER=`getprop vendor.asusfw.dt.hub1_fwver`

if [ "$update_flag" == "1" ]; then
	if [ "$type" == "3" ];then
		echo 1 > /sys/class/leds/DT_power/pd_switch
		echo 1 > /sys/class/leds/DT_power/pause
		echo "$LOG_TAG:[USB_ACCY] update fw $hub1_version to $FW_VER" > /dev/kmsg
		lsusb | grep 05e3:0610 > $lsusb_PATH
		/vendor/bin/DTHubFwUpdater isp -t single -n 0 -b $FW_PATH
		lsusb | grep 05e3:0610 > $lsusb_PATH

		check_lsusb=`cat $lsusb_PATH`
		echo "$LOG_TAG:[USB_ACCY] lsusb: $check_lsusb" > /dev/kmsg

		INDEX=1
		while [ $INDEX -le 3 ]
		do
			lsusb | grep 05e3:0610 > $lsusb_PATH
			hub1_version=`/vendor/bin/DTHubFwUpdater version |grep "\[0\]" | cut -d ":" -f 2`
			echo "$LOG_TAG:[USB_ACCY] DT hub1 version = $hub1_version" > /dev/kmsg

			if [ "$hub1_version" == "$FW_VER" ]; then
				echo "$LOG_TAG:[USB_ACCY] update success" > /dev/kmsg
				setprop vendor.dt.hub1_fwver $hub1_version
				setprop vendor.dt.hub1_fwupdate 0
				setprop vendor.dt.accy_statusupdate 1

				rm $lsusb_PATH
				echo 0 > /sys/class/leds/DT_power/pause
				echo 0 > /sys/class/leds/DT_power/pd_switch
				exit

			else
				echo "$LOG_TAG:[USB_ACCY] FW version check error, retry $INDEX" > /dev/kmsg
				(( INDEX++ ))
				sleep 1
			fi
		done

		echo "$LOG_TAG:[USB_ACCY] update fail" > /dev/kmsg
		setprop vendor.dt.hub1_fwver $hub1_version
		setprop vendor.dt.hub1_fwupdate 2

		rm $lsusb_PATH
		echo 0 > /sys/class/leds/DT_power/pause
		echo 0 > /sys/class/leds/DT_power/pd_switch
	else
		echo "$LOG_TAG:[USB_ACCY] not connect DT" > /dev/kmsg
		setprop vendor.dt.hub1_fwupdate 2
	fi
fi
