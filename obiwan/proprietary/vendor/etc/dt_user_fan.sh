#!/vendor/bin/sh

dongle_type=`getprop vendor.asus.dongletype`
fan_type=`getprop persist.vendor.asus.userfan`
micfansettings_type=`getprop persist.vendor.asus.micfansettings`
mic_type=`getprop vendor.asus.fan.mic`
setprop vendor.fan.rpm "none"
COUNT=1

function enable_mic(){
	echo 0 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
	PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
	RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
	echo "[DT_FAN][USER] enable_mic : PWM=$PWM, RPM=$RPM" > /dev/kmsg
}

function disable_mic(){
	fan_type=`getprop persist.vendor.asus.userfan`

	if [ "$fan_type" == "0" ]; then
		echo 0 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		echo "[DT_FAN][USER] userfan_type=$fan_type(off), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "1" ]; then
		echo 1 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		echo "[DT_FAN][USER] userfan_type=$fan_type(low), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "2" ]; then
		echo 2 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		echo "[DT_FAN][USER] userfan_type=$fan_type(medium), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "3" ]; then
		echo 3 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		echo "[DT_FAN][USER] userfan_type=$fan_type(high), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "4" ]; then
		echo 4 > /sys/class/hwmon/Inbox_Fan/device/dt_user_type
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		echo "[DT_FAN][USER] userfan_type=$fan_type(turbo), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "csc_test" ]; then
		echo 4 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
		sleep 1.5
		PWM=`cat /sys/class/hwmon/Inbox_Fan/device/PWM`
		RPM=`cat /sys/class/hwmon/Inbox_Fan/device/RPM`
		setprop vendor.fan.rpm "$RPM"
		echo "[DT_FAN][USER] csc_test fan : userfan_type=$fan_type(csc_test), PWM=$PWM, RPM=$RPM" > /dev/kmsg
	fi
}


if [ "$dongle_type" == "3" ]; then
	fan_type=`getprop persist.vendor.asus.userfan`
	if [ "$fan_type" == "auto" ]; then
		setprop persist.vendor.asus.tempfan 1
		echo "[DT_FAN][USER] enable thermal fan : fan_type=$fan_type" > /dev/kmsg
		exit 0
	fi
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo "[DT_FAN][USER] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_mic, disable_fan" > /dev/kmsg
		enable_mic
	else
		echo "[DT_FAN][USER] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_fan, disable_mic" > /dev/kmsg
		disable_mic
	fi

	#CHECK IF vendor.asus.fan.mic changed during running this process+++
	while [ $COUNT != 3 ]
	do
		mic_type_new=`getprop vendor.asus.fan.mic`
#		if [ "$mic_type_new" == "$mic_type" ];then
#			echo "[DT_FAN][USER] mic_type_new=$mic_type_new, mic_type=$mic_type, COUNT=$COUNT" > /dev/kmsg
#		else
		if [ "$mic_type_new" != "$mic_type" ];then
			if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
				echo "[DT_FAN][USER] user fan set - $COUNT check : mic_type=$mic_type, mic_type_new=$mic_type_new : enable_mic, disable_fan" > /dev/kmsg
				enable_mic
			else
				echo "[DT_FAN][USER] user fan set - $COUNT check : mic_type=$mic_type, mic_type_new=$mic_type_new : enable_fan, disable_mic" > /dev/kmsg
				disable_mic
			fi
		fi
		COUNT=$(($COUNT+1))
	done
	exit 0
	#CHECK IF vendor.asus.fan.mic changed during running this process---
fi

