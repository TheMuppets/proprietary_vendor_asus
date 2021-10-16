#!/vendor/bin/sh

type=`getprop vendor.asus.gamepad.type`
update_process=`getprop vendor.asus.gamepad.update_ongoing`

if [ "$update_process" == "1" ]; then
	echo "[GAMEPAD] ROGGamepadRemove, type $type, updating $update_process" > /dev/kmsg
else
	echo "[GAMEPAD] ROGGamepadRemove, type $type, no updating" > /dev/kmsg
fi

stop ROGGamepadSwitch

# Skip Remove process if updating.
if [ "$update_process" != "1" ]; then
	setprop vendor.asus.accy.fw_status3 000000
	setprop vendor.asus.accy.fw_status4 000000
else
	fw_status3=`getprop vendor.asus.accy.fw_status3`
	echo "[GAMEPAD] ROGGamepadRemove, Update process $update_process, fw_status3 $fw_status3," > /dev/kmsg

	fw_status4=`getprop vendor.asus.accy.fw_status4`
	echo "[GAMEPAD] ROGGamepadRemove, Update process $update_process, fw_status4 $fw_status4," > /dev/kmsg

	exit
fi

# Update FW will trigger USB disconnect, so can not do reset/stop fw udpate property/process here.
#stop ROGGamepadFWupdate
#setprop vendor.asus.accy.fw_status3 000000
#setprop vendor.gamepad.left_fwupdate 0
#setprop vendor.gamepad.holder_fwupdate 0
#setprop vendor.gamepad.wireless_fwupdate 0
#setprop vendor.gamepad3.left_fwupdate 0
#setprop vendor.gamepad3.right_fwupdate 0
#setprop vendor.gamepad3.middle_fwupdate 0

echo "[GAMEPAD] ROGGamepadRemove, reset_accy_fw_ver" > /dev/kmsg
setprop vendor.gamepad.left_fwver 0
setprop vendor.gamepad.holder_fwver 0 
setprop vendor.gamepad.wireless_fwver 0
setprop vendor.gamepad3.left_fwver 0
setprop vendor.gamepad3.right_fwver 0
setprop vendor.gamepad3.middle_fwver 0
setprop vendor.gamepad3.bt_fwver 0
setprop vendor.asus.gamepad.type none
setprop vendor.asus.gamepad.generation none

#for case set fw_status3 already but remove+++++
wireless_fwupdate=`getprop vendor.gamepad.wireless_fwupdate`
left_fwupdate=`getprop vendor.gamepad.left_fwupdate`
holder_fwupdate=`getprop vendor.gamepad.holder_fwupdate`

kunai3_left_fwupdate=`getprop vendor.gamepad.left_fwupdate`
kunai3_middle_fwupdate=`getprop vendor.gamepad.middle_fwupdate`
kunai3_right_fwupdate=`getprop vendor.gamepad.right_fwupdate`

fw_status3=`getprop vendor.asus.accy.fw_status3`

if [ "$fw_status3" == "100000" -a "$left_fwupdate" != "1" ]; then
	echo "[GAMEPAD] fw_status3 $fw_status3, left_fwupdate $left_fwupdate" > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 000000
fi

if [ "$fw_status3" == "010000" -a "$holder_fwupdate" != "1" ]; then
	echo "[GAMEPAD] fw_status3 $fw_status3, holder_fwupdate $holder_fwupdate" > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 000000
fi

if [ "$fw_status3" == "001000" -a "$wireless_fwupdate" != "1" ]; then
	echo "[GAMEPAD] fw_status3 $fw_status3, wireless_fwupdate $wireless_fwupdate" > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 000000
fi
#for case set fw_status3 already but remove+++++
