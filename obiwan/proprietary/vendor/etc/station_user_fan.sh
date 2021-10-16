#!/vendor/bin/sh

dongle_type=`getprop vendor.asus.dongletype`
fan_type=`getprop persist.vendor.asus.userfan`
micfansettings_type=`getprop persist.vendor.asus.micfansettings`
mic_type=`getprop vendor.asus.fan.mic`
setprop vendor.fan.rpm "none"
COUNT=1

function enable_mic(){
	echo 0 > /sys/class/ec_i2c/dongle/device/duty
	RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
	echo "[STATION_FAN][USER] enable_mic : RPM=$RPM" > /dev/kmsg
}

function disable_mic(){
	fan_type=`getprop persist.vendor.asus.userfan`

	if [ "$fan_type" == "0" ]; then
		echo 0 > /sys/class/ec_i2c/dongle/device/duty
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		echo "[STATION_FAN][USER] disable fan : userfan_type=$fan_type(off), RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "1" ]; then
		echo 42 >  /sys/class/ec_i2c/dongle/device/duty
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		echo "[STATION_FAN][USER] enable fan : userfan_type=$fan_type(low), RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "2" ]; then
		echo 50 > /sys/class/ec_i2c/dongle/device/duty
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		echo "[STATION_FAN][USER] enable fan : userfan_type=$fan_type(medium), RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "3" ]; then
		echo 55 > /sys/class/ec_i2c/dongle/device/duty
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		echo "[STATION_FAN][USER] enable fan : userfan_type=$fan_type(high), RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "4" ]; then
		echo 70 > /sys/class/ec_i2c/dongle/device/duty
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		echo "[STATION_FAN][USER] enable fan : userfan_type=$fan_type(turbo), RPM=$RPM" > /dev/kmsg
	elif [ "$fan_type" == "csc_test" ]; then
		echo 70 > /sys/class/ec_i2c/dongle/device/duty
		sleep 2
		RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
		setprop vendor.fan.rpm "$RPM"
		echo "[STATION_FAN][USER] csc_test fan : userfan_type=$fan_type(csc_test), RPM=$RPM" > /dev/kmsg
	fi
}


if [ "$dongle_type" == "2" ]; then
	i2c_trigger=`getprop vendor.asus.ec_i2c_trigger`
	if [ "$i2c_trigger" == "100" ] || [ "$i2c_trigger" == "200" ]; then 
		exit 0
	fi
	fan_type=`getprop persist.vendor.asus.userfan`
	if [ "$fan_type" == "auto" ]; then
		setprop persist.vendor.asus.tempfan 1
		echo "[STATION_FAN][USER] enable thermal fan : fan_type=$fan_type" > /dev/kmsg
		exit 0
	fi 
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo "[STATION_FAN][USER] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_mic, disable_fan" > /dev/kmsg
		enable_mic
	else
		echo "[STATION_FAN][USER] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_fan, disable_mic" > /dev/kmsg
		disable_mic
	fi

	#CHECK IF vendor.asus.fan.mic changed during running this process+++
	while [ $COUNT != 3 ]
	do
		mic_type_new=`getprop vendor.asus.fan.mic`
#		if [ "$mic_type_new" == "$mic_type" ];then
#			echo "[STATION_FAN][USER] mic_type_new=$mic_type_new mic_type=$mic_type, COUNT=$COUNT" > /dev/kmsg
#		else
		if [ "$mic_type_new" != "$mic_type" ];then
			if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
				echo "[STATION_FAN][USER] user fan set - $COUNT check mic_type=$mic_type, mic_type_new=$mic_type_new : enable_mic, disable_fan" > /dev/kmsg
				enable_mic
			else
				echo "[STATION_FAN][USER] user fan set - $COUNT check mic_type=$mic_type, mic_type_new=$mic_type_new : enable_fan, disable_mic" > /dev/kmsg
				disable_mic
			fi
		fi
		COUNT=$(($COUNT+1))
	done
	exit 0
	#CHECK IF vendor.asus.fan.mic changed during running this process---
fi

