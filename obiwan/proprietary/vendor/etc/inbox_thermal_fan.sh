#!/vendor/bin/sh

dongle_type=`getprop vendor.asus.dongletype`
fan_type=`getprop persist.vendor.asus.userfan`
thermal_type=`getprop vendor.asus.thermalfan`
micfansettings_type=`getprop persist.vendor.asus.micfansettings`
mic_type=`getprop vendor.asus.fan.mic`
COUNT=1

function enable_mic(){
	echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
	PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
	RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
	echo "[INBOX_FAN][AUTO] enable_mic : PWM=$PWM, RPM=$RPM" > /dev/kmsg
}

function disable_mic(){
	fan_type=`getprop persist.vendor.asus.userfan`

	if [ "$fan_type" == "auto" ]; then
#		echo "[INBOX_FAN][AUTO] thermal fan be set to auto" > /dev/kmsg
		if [ "$thermal_type" == "0" ]; then
			echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
			RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
			echo "[INBOX_FAN][AUTO] thermal_type=$thermal_type(0, default low), PWM=$PWM, RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "1" ]; then
			echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
			RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
			echo "[INBOX_FAN][AUTO] thermal_type=$thermal_type(low), PWM=$PWM, RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "2" ]; then
			echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
			RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
			echo "[INBOX_FAN][AUTO] thermal_type=$thermal_type(medium), PWM=$PWM, RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "3" ]; then
			echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
			RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
			echo "[INBOX_FAN][AUTO] thermal_type=$thermal_type(high), PWM=$PWM, RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "4" ]; then
			echo 4 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
			RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
			echo "[INBOX_FAN][AUTO] thermal_type=$thermal_type(turbo), PWM=$PWM, RPM=$RPM" > /dev/kmsg
		fi
	else
		echo "[INBOX_FAN][AUTO] thermal fan will not be set to auto" > /dev/kmsg
	fi
}


if [ "$dongle_type" == "1" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo "[INBOX_FAN][AUTO] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_mic, disable_fan" > /dev/kmsg
		enable_mic
	else
		echo "[INBOX_FAN][AUTO] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_fan, disable_mic" > /dev/kmsg
		disable_mic
	fi

	#CHECK IF vendor.asus.fan.mic changed during running this process+++
	while [ $COUNT != 3 ]
	do
		mic_type_new=`getprop vendor.asus.fan.mic`
#		if [ "$mic_type_new" == "$mic_type" ];then
#			echo "[INBOX_FAN][AUTO] mic_type_new=$mic_type_new mic_type=$mic_type, COUNT=$COUNT" > /dev/kmsg
#		else
		if [ "$mic_type_new" != "$mic_type" ];then
			if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
				echo "[INBOX_FAN][USER] user fan set - $COUNT check : mic_type=$mic_type, mic_type_new=$mic_type_new : enable_mic, disable_fan" > /dev/kmsg
				enable_mic
			else
				echo "[INBOX_FAN][USER] user fan set - $COUNT check : mic_type=$mic_type, mic_type_new=$mic_type_new : enable_fan, disable_mic" > /dev/kmsg
				disable_mic
			fi
		fi
		COUNT=$(($COUNT+1))
	done
	exit 0
	#CHECK IF vendor.asus.fan.mic changed during running this process---
fi

