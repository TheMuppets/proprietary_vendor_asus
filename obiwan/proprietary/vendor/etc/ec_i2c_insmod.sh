#!/vendor/bin/sh

insmod /vendor/lib/modules/ec_i2c_interface.ko
echo 13 > /sys/class/ec_hid/dongle/device/sync_state

uart_state=`getprop persist.vendor.asus.audbg_station`
echo "[EC_I2C] station uart state : $uart_state" > /dev/kmsg
if [ "$uart_state" == "0" ]; then
	echo "[EC_I2C] turn off station uart." > /dev/kmsg
	echo 0 > /sys/class/ec_i2c/dongle/device/uart
elif [ "$uart_state" == "1" ]; then
	echo "[EC_I2C] turn on station uart." > /dev/kmsg
	echo 1 > /sys/class/ec_i2c/dongle/device/uart
fi

hwid=`cat /sys/class/ec_i2c/dongle/device/hw_id`
setprop vendor.station.hwid	$hwid
