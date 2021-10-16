#!/vendor/bin/sh

echo "[GAMEPAD] ROGGamepadSwitch entry" > /dev/kmsg

function reset_accy_fw_ver(){
	echo "[GAMEPAD] ROGGamepadSwitch reset_accy_fw_ver" > /dev/kmsg

	tmp=`getprop vendor.asus.tmpVersion | cut -c 1`

	#setprop vendor.asus.accy.fw_status3 000000
	#setprop vendor.gamepad.left_fwupdate 0
	#setprop vendor.gamepad.holder_fwupdate 0
	#setprop vendor.gamepad.wireless_fwupdate 0
	#setprop vendor.gamepad3.left_fwupdate 0
	#setprop vendor.gamepad3.right_fwupdate 0
	#setprop vendor.gamepad3.middle_fwupdate 0

	setprop vendor.gamepad.left_fwver 0
	setprop vendor.gamepad.holder_fwver 0
	setprop vendor.gamepad.wireless_fwver 0

	setprop vendor.gamepad3.left_fwver 0
	setprop vendor.gamepad3.right_fwver 0
	setprop vendor.gamepad3.middle_fwver 0

	setprop vendor.asus.gamepad.type none

	if [ "$tmp" == "v" ]; then
		echo "[GAMEPAD] ROGGamepadSwitch BT connected" > /dev/kmsg
	else
		setprop vendor.asus.gamepad.generation none
	fi
}

function check_accy_fw_ver(){

	echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver type $type" > /dev/kmsg

	# For Kunai I
	if [ "$type" == "left_handle" ]; then
		fw_ver=`getprop vendor.gamepad.left_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.left_fwver`  #verison in phone

		if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver" > /dev/kmsg
			/vendor/bin/gamepad_serialnum_get -a
			sleep 1
			fw_ver=`getprop vendor.gamepad.left_fwver`  #version in ic
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 1st" > /dev/kmsg
			if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
				/vendor/bin/gamepad_serialnum_get -a
				sleep 1
				fw_ver=`getprop vendor.gamepad.left_fwver`  #version in ic
				echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 2nd" > /dev/kmsg
				if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
					setprop vendor.asus.accy.fw_status3 000000
					echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver , do nothing. exit" > /dev/kmsg
					exit 0
				fi
			fi
		fi

		fw_vern_num=${fw_ver:1:1}${fw_ver:3:1}${fw_ver:5:1}
		asus_fw_ver_num=${asus_fw_ver:1:1}${asus_fw_ver:3:1}${asus_fw_ver:5:1}

		if [ "$fw_ver" == "$asus_fw_ver" ]; then
			echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, fw_vern_num=$fw_vern_num no need update "> /dev/kmsg
			setprop vendor.asus.accy.fw_status3 000000
		else
			if [[ "$fw_vern_num" < "$asus_fw_ver_num" ]]; then
				#echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update "> /dev/kmsg
				#setprop vendor.asus.accy.fw_status3 100000
				echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update. But R not support kunai I update."> /dev/kmsg
				setprop vendor.asus.accy.fw_status3 000000
			fi
		fi

	elif [ "$type" == "holder_usb" ]; then
		fw_ver=`getprop vendor.gamepad.holder_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.holder_fwver`  #verison in phone

		if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver" > /dev/kmsg
			/vendor/bin/gamepad_serialnum_get -a
			sleep 1
			fw_ver=`getprop vendor.gamepad.holder_fwver`  #version in ic
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 1st" > /dev/kmsg
			if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
				/vendor/bin/gamepad_serialnum_get -a
				sleep 1
				fw_ver=`getprop vendor.gamepad.holder_fwver`  #version in ic
				echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 2nd" > /dev/kmsg
				if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
					setprop vendor.asus.accy.fw_status3 000000
					echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver , do nothing. exit" > /dev/kmsg
					exit 0
				fi
			fi
		fi

		fw_vern_num=${fw_ver:1:1}${fw_ver:3:1}${fw_ver:5:1}
		asus_fw_ver_num=${asus_fw_ver:1:1}${asus_fw_ver:3:1}${asus_fw_ver:5:1}

		if [ "$fw_ver" == "$asus_fw_ver" ]; then
			echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update "> /dev/kmsg
			setprop vendor.asus.accy.fw_status3 000000
		else
			if [[ "$fw_vern_num" < "$asus_fw_ver_num" ]]; then
				#echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update "> /dev/kmsg
				#setprop vendor.asus.accy.fw_status3 010000
				echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update. But R not support kunai I update."> /dev/kmsg
				setprop vendor.asus.accy.fw_status3 000000
			fi
		fi
	
	elif [ "$type" == "holder_wireless" ]; then

		fw_ver=`getprop vendor.gamepad.wireless_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.wireless_fwver`  #verison in phone

		if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver" > /dev/kmsg
			/vendor/bin/gamepad_serialnum_get -a
			sleep 1
			fw_ver=`getprop vendor.gamepad.wireless_fwver`  #version in ic
			echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 1st" > /dev/kmsg
			if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
				/vendor/bin/gamepad_serialnum_get -a
				sleep 1
				fw_ver=`getprop vendor.gamepad.wireless_fwver`  #version in ic
				echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver fw_ver=$fw_ver after retry check 2nd" > /dev/kmsg
				if [ "$fw_ver" == ""  -o "$fw_ver" == "0" ]; then
					setprop vendor.asus.accy.fw_status3 000000
					echo "[GAMEPAD] ROGGamepadSwitch, check_accy_fw_ver , do nothing. exit" > /dev/kmsg
					exit 0
				fi
			fi
		fi

		fw_vern_num=${fw_ver:1:1}${fw_ver:3:1}${fw_ver:5:1}
		asus_fw_ver_num=${asus_fw_ver:1:1}${asus_fw_ver:3:1}${asus_fw_ver:5:1}


		if [ "$fw_ver" == "$asus_fw_ver" ]; then
			echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update "> /dev/kmsg
			setprop vendor.asus.accy.fw_status3 000000
		else
			if [[ "$fw_vern_num" < "$asus_fw_ver_num" ]]; then
				#echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update "> /dev/kmsg
				#setprop vendor.asus.accy.fw_status3 001000
				echo "[GAMEPAD] fw_gamepad_update fw_ver=$fw_vern_num asus_fw_ver=$asus_fw_ver_num need update. But R not support kunai I update."> /dev/kmsg
				setprop vendor.asus.accy.fw_status3 000000
			fi
		fi
	fi

	# For Kunai III
	if [ "$generation" == "3" ]; then
		# Get Left FW version
		fw_ver=`getprop vendor.gamepad3.left_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.left_fwver`  #verison in phone
		echo "[GAMEPAD_III] Left FW version : $fw_ver" > /dev/kmsg

		if [ "$fw_ver" == "$asus_fw_ver" ]; then
			#echo "[GAMEPAD_III][Left] fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update Left FW" > /dev/kmsg
			kunai3_left_update="0"
		else
			kunai3_left_update="1"
		fi

		sleep 1

		# Get Right FW version
		fw_ver=`cat /sys/class/leds/aura_gamepad/right_fw_ver`
		setprop vendor.gamepad3.right_fwver "$fw_ver"

		fw_ver=`getprop vendor.gamepad3.right_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.right_fwver`  #verison in phone

		if [ "$fw_ver" == "Vff.ff.ff" ]; then
			#echo "[GAMEPAD_III][Right] fw_ver=$fw_ver, no need update Right FW" > /dev/kmsg
			kunai3_right_update="0"
		elif [ "$fw_ver" == "$asus_fw_ver" ]; then
			#echo "[GAMEPAD_III][Right] fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update Right FW" > /dev/kmsg
			kunai3_right_update="0"
		else
			kunai3_right_update="1"
		fi

		if [ "$type" == "KunaiIII_Holder" ]; then
			# Get Middle FW version
			fw_ver=`cat /sys/class/leds/aura_gamepad/middle_fw_ver`
			setprop vendor.gamepad3.middle_fwver "$fw_ver"

			fw_ver=`getprop vendor.gamepad3.middle_fwver`  #version in ic
			asus_fw_ver=`getprop vendor.asusfw.gamepad3.middle_fwver`  #verison in phone

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				#echo "[GAMEPAD_III][Middle] fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update Middle FW" > /dev/kmsg
				kunai3_middle_update="0"
			else
				kunai3_middle_update="1"
			fi
		else
			# Only Holder mode has Middle device
			kunai3_middle_update="0"
		fi

		# Get BT FW version
		fw_ver=`cat /sys/class/leds/aura_gamepad/bt_fw_ver`
		setprop vendor.gamepad3.bt_fwver "$fw_ver"

		fw_ver=`getprop vendor.gamepad3.bt_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.bt_fwver`  #verison in phone

		if [ "$fw_ver" == "$asus_fw_ver" ]; then
			#echo "[GAMEPAD_III][BT] fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver no need update BT FW" > /dev/kmsg
			kunai3_bt_update="0"
		else
			kunai3_bt_update="1"
		fi

		#setprop vendor.asus.accy.fw_status3 000"$kunai3_left_update""$kunai3_middle_update""$kunai3_right_update""$kunai3_bt_update"
		setprop vendor.asus.accy.fw_status3 000"$kunai3_left_update""$kunai3_middle_update""$kunai3_right_update"
		#setprop vendor.asus.accy.fw_status4 "$kunai3_bt_update"00000
		setprop vendor.asus.accy.fw_status4 000000
	fi

	fw_status3=`getprop vendor.asus.accy.fw_status3`
	fw_status4=`getprop vendor.asus.accy.fw_status4`

	echo "[GAMEPAD] ACCY FW status fw_status3:$fw_status3, fw_status4:$fw_status4" > /dev/kmsg
	echo "[GAMEPAD] Get Gamepad FW Version done." > /dev/kmsg
}

#check if it is the update time switch+++++++++++
wireless_fwupdate=`getprop vendor.gamepad.wireless_fwupdate`
left_fwupdate=`getprop vendor.gamepad.left_fwupdate`
holder_fwupdate=`getprop vendor.gamepad.holder_fwupdate`
if [ "$left_fwupdate" == "1" ]; then
	echo "[GAMEPAD] ROGGamepadSwitch it is left update, exit" > /dev/kmsg
	exit 0
fi
if [ "$wireless_fwupdate" == "1" ]; then
	echo "[GAMEPAD] ROGGamepadSwitch it is wireless dongle update, exit" > /dev/kmsg
	exit 0
fi
if [ "$holder_fwupdate" == "1" ]; then
	echo "[GAMEPAD] ROGGamepadSwitch it is holder update, exit" > /dev/kmsg
	exit 0
fi

update_process=`getprop vendor.asus.gamepad.update_ongoing`
if [ "$update_process" == "1" ]; then
	echo "[GAMEPAD] ROGGamepadSwitch it is Kunai III updating, exit" > /dev/kmsg
	exit 0
fi
#check if it is the update time switch-----------

reset_accy_fw_ver

/vendor/bin/gamepad_serialnum_get -a
sleep 1
type=`getprop vendor.asus.gamepad.type`
generation=`getprop vendor.asus.gamepad.generation`

#check if it is the loader mode,and fwupdate!=1 +++++++++++
ld_check=`lsusb |grep 2e2c:7900`
if [ "$ld_check" != "" ];then
	echo "[GAMEPAD] ROGGamepadSwitch left LD mode " > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 100000
	exit 0
fi
ld_check=`lsusb |grep 2e2c:7901`
if [ "$ld_check" != "" ];then
	echo "[GAMEPAD] ROGGamepadSwitch holder LD mode " > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 010000
	exit 0
fi
ld_check=`lsusb |grep 040b:6875`
if [ "$ld_check" != "" ];then
	echo "[GAMEPAD] ROGGamepadSwitch wireless LD mode " > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 001000
	exit 0
fi

ld_check=`lsusb |grep 2e2c:7904`
if [ "$ld_check" != "" ];then
	echo "[GAMEPAD] ROGGamepadSwitch Kunai III Left LD mode 2e2c:7904" > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 000100
	exit 0
fi
ld_check=`lsusb |grep 040b:6821`
if [ "$ld_check" != "" ];then
	echo "[GAMEPAD] ROGGamepadSwitch Kunai III Left LD mode 040b:6821" > /dev/kmsg
	setprop vendor.asus.accy.fw_status3 000100
	exit 0
fi
#check if it is the loader mode-----------

#setprop vendor.asus.accy.fw_status3 000000

if [ "$type" == "none" ]; then
	echo "[GAMEPAD] ROGGamepadSwitch none " > /dev/kmsg
else
	echo "[GAMEPAD] ROGGamepadSwitch, type $type" > /dev/kmsg
	check_accy_fw_ver
fi
