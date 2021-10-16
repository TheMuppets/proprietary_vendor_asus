#!/vendor/bin/sh

KUNAI3_LEFT_FW_PATH="/vendor/asusfw/gamepad/LBA1136_left.bin"
KUNAI3_MIDDLE_FW_PATH="/vendor/asusfw/gamepad/LBA1136_middle.bin"
KUNAI3_RIGHT_FW_PATH="/vendor/asusfw/gamepad/LBA1136_right.bin"
KUNAI3_BT_FW_PATH="/vendor/asusfw/gamepad/LBA1136_BT.bin"

if [ -n "$1" ]; then
	export UPDATE_TYPE=$1
else
	echo "[GAMEPAD_III] kunaiIII_fw_update.sh, miss parameter1" > /dev/kmsg
	exit
fi

type=`getprop vendor.asus.gamepad.type`
echo "[GAMEPAD_III] kunaiIII_fw_update entry.  GamePad Type is $type" > /dev/kmsg
retry=0

# Check assign device
if [ "$UPDATE_TYPE" == "left" ]; then
	echo "[GAMEPAD_III] kunaiIII_fw_update, update $UPDATE_TYPE" > /dev/kmsg
elif [ "$UPDATE_TYPE" == "right" ]; then
	echo "[GAMEPAD_III] kunaiIII_fw_update, update $UPDATE_TYPE" > /dev/kmsg
elif [ "$UPDATE_TYPE" == "middle" ]; then
	echo "[GAMEPAD_III] kunaiIII_fw_update, update $UPDATE_TYPE" > /dev/kmsg
elif [ "$UPDATE_TYPE" == "bluetooth" ]; then
	echo "[GAMEPAD_III] kunaiIII_fw_update, update $UPDATE_TYPE" > /dev/kmsg
else
	echo "[GAMEPAD_III] kunaiIII_fw_update, unknow device $UPDATE_TYPE" > /dev/kmsg
	exit
fi

# Check Kunai III type
if [ "$type" != "KunaiIII_Bumper" -a "$type" != "KunaiIII_Holder" -a "$type" != "KunaiIII_LD" ]; then
	echo "[GAMEPAD_III] kunaiIII_fw_update, type error:$type , skip update" > /dev/kmsg

	if [ "$UPDATE_TYPE" == "left" ]; then
		setprop vendor.gamepad3.left_fwupdate 2
	elif [ "$UPDATE_TYPE" == "right" ]; then
		setprop vendor.gamepad3.right_fwupdate 2
	elif [ "$UPDATE_TYPE" == "middle" ]; then
		setprop vendor.gamepad3.middle_fwupdate 2
	elif [ "$UPDATE_TYPE" == "bluetooth" ]; then
		setprop vendor.gamepad3.bt_fwupdate 2
	fi
	exit
fi

kunaiIII_left_status=`getprop vendor.asus.accy.fw_status3 | cut -c 4`
kunaiIII_middle_status=`getprop vendor.asus.accy.fw_status3 | cut -c 5`
kunaiIII_right_status=`getprop vendor.asus.accy.fw_status3 | cut -c 6`

#kunaiIII_bt_status=`getprop vendor.asus.accy.fw_status3 | cut -c 7`
kunaiIII_bt_status=`getprop vendor.asus.accy.fw_status4 | cut -c 1`

function fw_update(){
	#echo "[GAMEPAD_III] kunaiIII_fw_update, type $type, update $UPDATE_TYPE device." > /dev/kmsg

	if [ "$UPDATE_TYPE" == "left" ]; then
		fw_ver=`getprop vendor.gamepad3.left_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.left_fwver `  #verison in phone
		echo "[GAMEPAD_III] kunaiIII_fw_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		minor=`getprop vendor.gamepad3.left_fwver | cut -c 6`
		major=`getprop vendor.gamepad3.left_fwver | cut -c 4`

		if [ "$type" == "KunaiIII_LD" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, KunaiIII_LD use new bootload VID/PID." > /dev/kmsg
			/vendor/bin/kunai3_left_fw_update -s 0b05:7904 -u 040B:6821 -f "$KUNAI3_LEFT_FW_PATH"
		elif [ $major -gt 2 ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, new bootload VID/PID." > /dev/kmsg
			if [ "$type" == "KunaiIII_Bumper" ]; then
				/vendor/bin/kunai3_left_fw_update -s 0b05:7904 -u 040B:6821 -f "$KUNAI3_LEFT_FW_PATH"
			elif [ "$type" == "KunaiIII_Holder" ]; then
				/vendor/bin/kunai3_left_fw_update -s 0b05:7905 -u 040B:6821 -f "$KUNAI3_LEFT_FW_PATH"
			fi
		elif [ $minor -lt 7 ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, old bootload VID/PID." > /dev/kmsg
			if [ "$type" == "KunaiIII_Bumper" ]; then
				/vendor/bin/gamepad_fw_update -s 0b05:7904 -u 2e2c:7904 -f "$KUNAI3_LEFT_FW_PATH"
			elif [ "$type" == "KunaiIII_Holder" ]; then
				/vendor/bin/gamepad_fw_update -s 0b05:7905 -u 2e2c:7904 -f "$KUNAI3_LEFT_FW_PATH"
			fi
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update, new bootload VID/PID." > /dev/kmsg
			if [ "$type" == "KunaiIII_Bumper" ]; then
				/vendor/bin/kunai3_left_fw_update -s 0b05:7904 -u 040B:6821 -f "$KUNAI3_LEFT_FW_PATH"
			elif [ "$type" == "KunaiIII_Holder" ]; then
				/vendor/bin/kunai3_left_fw_update -s 0b05:7905 -u 040B:6821 -f "$KUNAI3_LEFT_FW_PATH"
			fi
		fi

		result="$?"
		echo "[GAMEPAD_III] kunaiIII_fw_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 3
			/vendor/bin/gamepad_serialnum_get -a
			fw_ver=`getprop vendor.gamepad3.left_fwver`

			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 3
				/vendor/bin/gamepad_serialnum_get -a
				fw_ver=`getprop vendor.gamepad3.left_fwver`
				echo "[GAMEPAD_III] kunaiIII_fw_update, re-check FW $retry, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD_III] kunaiIII_fw_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.left_fwupdate 0
			else
				echo "[GAMEPAD_III] kunaiIII_fw_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver $type update fail" > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.left_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after right update result is 1, update failed." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.left_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after right update result is 2, the update was interrupted." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.left_fwupdate 3
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.left_fwupdate 2
		fi

	elif [ "$UPDATE_TYPE" == "right" ]; then
		fw_ver=`getprop vendor.gamepad3.right_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.right_fwver `  #verison in phone
		echo "[GAMEPAD_III] kunaiIII_fw_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		if [ "$type" == "KunaiIII_Bumper" ]; then
			/vendor/bin/kunai3_fw_update -s 0b05:7904 -f "$KUNAI3_RIGHT_FW_PATH" -k -D DEVC
		elif [ "$type" == "KunaiIII_Holder" ]; then
			/vendor/bin/kunai3_fw_update -s 0b05:7905 -f "$KUNAI3_RIGHT_FW_PATH" -k -D DEVC
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update, type error:$type , skip update" > /dev/kmsg
			setprop vendor.gamepad3.right_fwupdate 2
			setprop vendor.asus.gamepad.update_ongoing 0
			echo "[GAMEPAD_III] kunaiIII_fw_update, set vendor.asus.gamepad.update_ongoing 0" > /dev/kmsg
			exit
		fi

		result="$?"
		echo "[GAMEPAD_III] kunaiIII_fw_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 3

			fw_ver=`cat /sys/class/leds/aura_gamepad/right_fw_ver`
			setprop vendor.gamepad3.right_fwver "$fw_ver"

			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 3
				fw_ver=`cat /sys/class/leds/aura_gamepad/right_fw_ver`
				setprop vendor.gamepad3.right_fwver "$fw_ver"

				echo "[GAMEPAD_III] kunaiIII_fw_update, re-check FW $retry, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD_III] kunaiIII_fw_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.right_fwupdate 0
			else
				echo "[GAMEPAD_III] kunaiIII_fw_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver $type update fail" > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.right_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after right update result is 1, update failed." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.right_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after right update result is 2, the update was interrupted." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.right_fwupdate 3
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.right_fwupdate 2
		fi

	elif [ "$UPDATE_TYPE" == "middle" ]; then
		fw_ver=`getprop vendor.gamepad3.middle_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.middle_fwver `  #verison in phone
		echo "[GAMEPAD_III] kunaiIII_fw_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		if [ "$type" == "KunaiIII_Bumper" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, $type no need update $UPDATE_TYPE !!!" > /dev/kmsg
			setprop vendor.gamepad3.middle_fwupdate 2
			setprop vendor.asus.gamepad.update_ongoing 0
			echo "[GAMEPAD_III] kunaiIII_fw_update, set vendor.asus.gamepad.update_ongoing 0" > /dev/kmsg
			exit
		elif [ "$type" == "KunaiIII_Holder" ]; then
			/vendor/bin/kunai3_fw_update -s 0b05:7905 -f "$KUNAI3_MIDDLE_FW_PATH" -k -D DEVB
		fi

		result="$?"
		echo "[GAMEPAD_III] kunaiIII_fw_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 3

			fw_ver=`cat /sys/class/leds/aura_gamepad/middle_fw_ver`
			setprop vendor.gamepad3.middle_fwver "$fw_ver"

			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 3
				fw_ver=`cat /sys/class/leds/aura_gamepad/middle_fw_ver`
				setprop vendor.gamepad3.middle_fwver "$fw_ver"

				echo "[GAMEPAD_III] kunaiIII_fw_update, re-check FW $retry, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD_III] kunaiIII_fw_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.middle_fwupdate 0
			else
				echo "[GAMEPAD_III] kunaiIII_fw_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver $type update fail" > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.middle_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after middle update result is 1, update failed." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.middle_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after middle update result is 2, the update was interrupted." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.middle_fwupdate 3
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.middle_fwupdate 2
		fi
	elif [ "$UPDATE_TYPE" == "bluetooth" ]; then
		fw_ver=`getprop vendor.gamepad3.bt_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad3.bt_fwver `  #verison in phone
		echo "[GAMEPAD_III] kunaiIII_fw_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		if [ "$type" == "KunaiIII_Bumper" ]; then
			/vendor/bin/kunai3_fw_update -s 0b05:7904 -f "$KUNAI3_BT_FW_PATH" -k -D DEVBT
		elif [ "$type" == "KunaiIII_Holder" ]; then
			/vendor/bin/kunai3_fw_update -s 0b05:7905 -f "$KUNAI3_BT_FW_PATH" -k -D DEVBT
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update, type error:$type , skip update" > /dev/kmsg
			setprop vendor.gamepad3.bt_fwupdate 2
			setprop vendor.asus.gamepad.update_ongoing 0
			echo "[GAMEPAD_III] kunaiIII_fw_update, set vendor.asus.gamepad.update_ongoing 0" > /dev/kmsg
			exit
		fi

		result="$?"
		echo "[GAMEPAD_III] kunaiIII_fw_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 3

			fw_ver=`cat /sys/class/leds/aura_gamepad/bt_fw_ver`
			setprop vendor.gamepad3.bt_fwver "$fw_ver"

			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 3
				fw_ver=`cat /sys/class/leds/aura_gamepad/bt_fw_ver`
				setprop vendor.gamepad3.bt_fwver "$fw_ver"

				echo "[GAMEPAD_III] kunaiIII_fw_update, re-check FW $retry, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD_III] kunaiIII_fw_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.bt_fwupdate 0
			else
				echo "[GAMEPAD_III] kunaiIII_fw_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver $type update fail" > /dev/kmsg
				sleep 3
				setprop vendor.gamepad3.bt_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after bt update result is 1, update failed." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.bt_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD_III] kunaiIII_fw_update, after bt update result is 2, the update was interrupted." > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.bt_fwupdate 3
		else
			echo "[GAMEPAD_III] kunaiIII_fw_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			sleep 3
			setprop vendor.gamepad3.bt_fwupdate 2
		fi
	fi

	#fix TT#1337172--remove the device before select "update".
	if [ "$type" == "none" ]; then
		echo "[GAMEPAD_III] kunaiIII_fw_update, trigger update after remove." > /dev/kmsg
		setprop vendor.gamepad3.left_fwupdate 2
		setprop vendor.gamepad3.middle_fwupdate 2
		setprop vendor.gamepad3.right_fwupdate 2
		setprop vendor.gamepad3.bt_fwupdate 2
	fi

	echo "[GAMEPAD_III] kunaiIII_fw_update done." > /dev/kmsg
}

function reset_fw_status(){
	if [ "$UPDATE_TYPE" == "left" ]; then
		kunaiIII_left_status=0
	elif [ "$UPDATE_TYPE" == "right" ]; then
		kunaiIII_right_status=0
	elif [ "$UPDATE_TYPE" == "middle" ]; then
		kunaiIII_middle_status=0
	elif [ "$UPDATE_TYPE" == "bluetooth" ]; then
		kunaiIII_bt_status=0
	fi
	#setprop vendor.asus.accy.fw_status3 000"$kunaiIII_left_status""$kunaiIII_middle_status""$kunaiIII_right_status""$kunaiIII_bt_status"
	setprop vendor.asus.accy.fw_status3 000"$kunaiIII_left_status""$kunaiIII_middle_status""$kunaiIII_right_status"
	setprop vendor.asus.accy.fw_status4 "$kunaiIII_bt_status"00000
}

echo "[GAMEPAD_III] kunaiIII_fw_update START, set vendor.asus.gamepad.update_ongoing 1" > /dev/kmsg
setprop vendor.asus.gamepad.update_ongoing 1

fw_update
reset_fw_status
sleep 3

setprop vendor.asus.gamepad.update_ongoing 0
echo "[GAMEPAD_III] kunaiIII_fw_update END. set vendor.asus.gamepad.update_ongoing 0" > /dev/kmsg

