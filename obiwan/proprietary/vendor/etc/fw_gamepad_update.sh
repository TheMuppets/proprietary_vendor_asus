#!/vendor/bin/sh

/vendor/bin/gamepad_serialnum_get -a
type=`getprop vendor.asus.gamepad.type`
echo "[GAMEPAD] fw_gamepad_update entry.  get type=$type & ver first" > /dev/kmsg
retry=0

DONGLE_FW_PATH="/vendor/asusfw/gamepad/LBA1008_dongle.bin"
HOLDER_FW_PATH="/vendor/asusfw/gamepad/LBA1008_holder.bin"
LEFT_FW_PATH="/vendor/asusfw/gamepad/LBA1008_left.bin"

function fw_update(){
	echo "[GAMEPAD] fw_gamepad_update, fw_update type $type" > /dev/kmsg

	if [ "$type" == "left_handle" ]; then
		fw_ver=`getprop vendor.gamepad.left_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.left_fwver`  #verison in phone
		echo "[GAMEPAD] fw_gamepad_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		/vendor/bin/gamepad_fw_update  -s 0b05:7900 -u 2e2c:7900 -f "$LEFT_FW_PATH"
		result="$?"
		echo "[GAMEPAD] fw_gamepad_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 1
			/vendor/bin/gamepad_serialnum_get -a
			fw_ver=`getprop vendor.gamepad.left_fwver` 
			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 1
				/vendor/bin/gamepad_serialnum_get -a
				fw_ver=`getprop vendor.gamepad.left_fwver`
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD] fw_gamepad_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				setprop vendor.gamepad.left_fwupdate 0
			else
				echo "[GAMEPAD] fw_gamepad_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver $type update fail" > /dev/kmsg
				setprop vendor.gamepad.left_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after left update result is 1, update failed." > /dev/kmsg
			setprop vendor.gamepad.left_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after left update result is 2, the update was interrupted." > /dev/kmsg
			setprop vendor.gamepad.left_fwupdate 3
		else
			echo "[GAMEPAD] fw_gamepad_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			setprop vendor.gamepad.left_fwupdate 2
		fi

	elif [ "$type" == "holder_usb" ]; then
		fw_ver=`getprop vendor.gamepad.holder_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.holder_fwver`  #verison in phone
		echo "[GAMEPAD] fw_gamepad_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		/vendor/bin/gamepad_fw_update -s 0b05:7901 -u 2e2c:7901  -f "$HOLDER_FW_PATH"
		result="$?"
		echo "[GAMEPAD] fw_gamepad_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 1
			/vendor/bin/gamepad_serialnum_get -a

			fw_ver=`getprop vendor.gamepad.holder_fwver`
			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 1
				/vendor/bin/gamepad_serialnum_get -a
				fw_ver=`getprop vendor.gamepad.holder_fwver`
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD] fw_gamepad_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				setprop vendor.gamepad.holder_fwupdate 0
			else
				echo "[GAMEPAD] fw_gamepad_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver  $type update fail" > /dev/kmsg
				setprop vendor.gamepad.holder_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after host update result is 1, update failed." > /dev/kmsg
			setprop vendor.gamepad.holder_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after host update result is 2, the update was interrupted." > /dev/kmsg
			setprop vendor.gamepad.holder_fwupdate 3
		else
			echo "[GAMEPAD] fw_gamepad_update,after update,the result is not 0,1,2, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			setprop vendor.gamepad.holder_fwupdate 2
		fi
	
	elif [ "$type" == "holder_wireless" ]; then
		fw_ver=`getprop vendor.gamepad.wireless_fwver`  #version in ic
		asus_fw_ver=`getprop vendor.asusfw.gamepad.wireless_fwver`  #verison in phone
		echo "[GAMEPAD] fw_gamepad_update,fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver, need update." > /dev/kmsg

		/vendor/bin/gamepad_fw_update -s 0b05:7903 -u 040b:6875 -e 6575 -f "$DONGLE_FW_PATH"
		result="$?"
		echo "[GAMEPAD] fw_gamepad_update after update cmd ,result=$result." > /dev/kmsg
		if [ "$result" == 0 ]; then
			sleep 1
			/vendor/bin/gamepad_serialnum_get -a

			fw_ver=`getprop vendor.gamepad.wireless_fwver`
			while [ "$retry" -lt 5 ]
			do
				retry=$(($retry+1))
				if [ "$fw_ver" == "$asus_fw_ver" ]; then
					break;
				fi
				sleep 1
				/vendor/bin/gamepad_serialnum_get -a
				fw_ver=`getprop vendor.gamepad.wireless_fwver`
			done

			if [ "$fw_ver" == "$asus_fw_ver" ]; then
				echo "[GAMEPAD] fw_gamepad_update,after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
				setprop vendor.gamepad.wireless_fwupdate 0
			else
				echo "[GAMEPAD] fw_gamepad_update, after update, fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver  $type update fail" > /dev/kmsg
				setprop vendor.gamepad.wireless_fwupdate 2
			fi
		elif [ "$result" == "1" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after dongle update result is 1, update failed." > /dev/kmsg
			setprop vendor.gamepad.wireless_fwupdate 2
		elif [ "$result" == "2" ]; then
			echo "[GAMEPAD] fw_gamepad_update, after dongle update result is 2, the update was interrupted." > /dev/kmsg
			setprop vendor.gamepad.wireless_fwupdate 3
		else
			echo "[GAMEPAD] fw_gamepad_update,after update,the result is not 0,1,2. fw_ver=$fw_ver asus_fw_ver=$asus_fw_ver " > /dev/kmsg
			setprop vendor.gamepad.wireless_fwupdate 2
		fi
	fi

	#fix TT#1337172--remove the device before select "update".
	if [ "$type" == "none" ]; then
		echo "[GAMEPAD] fw_gamepad_update, trigger update after remove." > /dev/kmsg
		setprop vendor.gamepad.left_fwupdate 2
		setprop vendor.gamepad.holder_fwupdate 2
		setprop vendor.gamepad.wireless_fwupdate 2
	fi
	echo "[GAMEPAD] fw_gamepad_update done." > /dev/kmsg
}

fw_update
setprop vendor.asus.accy.fw_status3 000000

