#!/vendor/bin/sh

tmp=`getprop vendor.asus.tmpVersion | cut -c 1`

if [ "$tmp" == "v" ]; then
	bt_version=`getprop vendor.asus.tmpVersion | cut -c 2-6`
	setprop vendor.gamepad3.bt_fwver "V$bt_version"
	setprop vendor.asus.gamepad.generation "3"
else
	setprop vendor.gamepad3.bt_fwver "0"
	setprop vendor.asus.gamepad.generation "none"
fi
