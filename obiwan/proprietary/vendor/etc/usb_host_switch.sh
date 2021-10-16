#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
pre_type=`getprop vendor.asus.usb.pre_dongletype`
debug=`getprop vendor.asus.usb.debug`
LOG_TAG="usb_host_switch"

echo 1 > /sys/module/dwc3_msm/parameters/setModefromPOGO
echo "$LOG_TAG:[USB] Change dongletype $pre_type -> $type" > /dev/kmsg
if [ "$type" == "0" ]; then
	echo "$LOG_TAG:[USB] No Dongle. usb2 none" > /dev/kmsg
	echo none > /sys/devices/platform/soc/a800000.ssusb/mode
elif [ "$type" == "1" ]; then
	echo "$LOG_TAG:[USB] InBox. usb2 host" > /dev/kmsg
	echo host > /sys/devices/platform/soc/a800000.ssusb/mode
elif [ "$type" == "2" ]; then
	if [ "$debug" == "1" ]; then
		echo "$LOG_TAG:[USB] Station. debug mode, usb2 peripheral" > /dev/kmsg
		echo peripheral > /sys/devices/platform/soc/a800000.ssusb/mode
	else
		echo "$LOG_TAG:[USB] Station. usb2 none" > /dev/kmsg
		echo none > /sys/devices/platform/soc/a800000.ssusb/mode
	fi
elif [ "$type" == "3" ]; then
	echo "$LOG_TAG:[USB] DT. usb2 host" > /dev/kmsg
	echo host > /sys/devices/platform/soc/a800000.ssusb/mode
else
	echo "$LOG_TAG:[USB] dongle type ERROR. type=$type. no action." > /dev/kmsg
fi
echo 0 > /sys/module/dwc3_msm/parameters/setModefromPOGO

setprop vendor.asus.usb.pre_dongletype "$type"
