#!/vendor/bin/sh

type=`getprop vendor.asus.dongletype`
LOG_TAG="usb_pd_rt1715"

if [ "$type" == "0" ]; then
	echo "$LOG_TAG:[USB] No Dongle. usb1 none(by charger id notify), usb2 none" > /dev/kmsg
	echo 11 > /sys/bus/i2c/devices/6-004e/tcpc/type_c_port0/pd_test
	sleep 1
	echo 10 > /sys/bus/i2c/devices/6-004e/tcpc/type_c_port0/pd_test
elif [ "$type" == "1" ]; then
	echo "$LOG_TAG:[USB] InBox. usb2 no action" > /dev/kmsg
elif [ "$type" == "2" ]; then
	echo "$LOG_TAG:[USB] Station. usb1 host(by charger id notify), usb2 none" > /dev/kmsg
	echo 11 > /sys/bus/i2c/devices/6-004e/tcpc/type_c_port0/pd_test
	sleep 1
	echo 10 > /sys/bus/i2c/devices/6-004e/tcpc/type_c_port0/pd_test
elif [ "$type" == "3" ]; then
	echo "$LOG_TAG:[USB] DT. usb2 host" > /dev/kmsg
	echo 12 > /sys/bus/i2c/devices/6-004e/tcpc/type_c_port0/pd_test
else
	echo "$LOG_TAG:[USB] dongle type ERROR. type=$type. no action." > /dev/kmsg
fi
