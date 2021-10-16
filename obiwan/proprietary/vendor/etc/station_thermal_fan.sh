#!/vendor/bin/sh

dongle_type=`getprop vendor.asus.dongletype`
fan_type=`getprop persist.vendor.asus.userfan`
thermal_type=`getprop vendor.asus.thermalfan`
micfansettings_type=`getprop persist.vendor.asus.micfansettings`
mic_type=`getprop vendor.asus.fan.mic`
COUNT=1

function enable_mic(){
	echo 0 > /sys/class/ec_i2c/dongle/device/duty
	RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
	echo "[STATION_FAN][AUTO] enable_mic : RPM=$RPM" > /dev/kmsg
}

function disable_mic(){
	fan_type=`getprop persist.vendor.asus.userfan`

	if [ "$fan_type" == "auto" ]; then
#		echo "[STATION_FAN][AUTO] thermal fan be set to auto" > /dev/kmsg
		if [ "$thermal_type" == "0" ]; then
			echo 42 >  /sys/class/ec_i2c/dongle/device/duty
			RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
			echo "[STATION_FAN][AUTO] thermal_type=$thermal_type(0: default:low),  RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "1" ]; then
			echo 42 >  /sys/class/ec_i2c/dongle/device/duty
			RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
			echo "[STATION_FAN][AUTO] thermal_type=$thermal_type(low), RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "2" ]; then
			echo 50 > /sys/class/ec_i2c/dongle/device/duty
			RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
			echo "[STATION_FAN][AUTO] thermal_type=$thermal_type(medium), RPM=$RPM" > /dev/kmsg 
		elif [ "$thermal_type" == "3" ]; then
			echo 55 > /sys/class/ec_i2c/dongle/device/duty
			RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
			echo "[STATION_FAN][AUTO] thermal_type=$thermal_type(high), RPM=$RPM" > /dev/kmsg
		elif [ "$thermal_type" == "4" ]; then
			echo 70 > /sys/class/ec_i2c/dongle/device/duty
			RPM=`cat /sys/class/ec_i2c/dongle/device/rpm`
			echo "[STATION_FAN][AUTO] thermal_type=$thermal_type(turbo), RPM=$RPM" > /dev/kmsg
		fi
	else
		echo "[STATION_FAN][AUTO] thermal fan will not be set to auto" > /dev/kmsg 
	fi
}


if [ "$dongle_type" == "2" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo "[STATION_FAN][AUTO] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_mic, disable_fan" > /dev/kmsg
		enable_mic
	else
		echo "[STATION_FAN][AUTO] micfansettings_type=$micfansettings_type, mic_type=$mic_type : enable_fan, disable_mic" > /dev/kmsg
		disable_mic
	fi

	#CHECK IF vendor.asus.fan.mic changed during running this process+++
	while [ $COUNT != 3 ]
	do
		mic_type_new=`getprop vendor.asus.fan.mic`
#		if [ "$mic_type_new" == "$mic_type" ];then
#			echo "[STATION_FAN][AUTO] mic_type_new=$mic_type_new mic_type=$mic_type, COUNT=$COUNT" > /dev/kmsg
#		else
		if [ "$mic_type_new" != "$mic_type" ];then
			if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
				echo "[STATION_FAN][AUTO]thermal fan set - $COUNT check mic_type=$mic_type, mic_type_new=$mic_type_new : enable_mic, disable_fan" > /dev/kmsg
				enable_mic
			else
				echo "[STATION_FAN][AUTO]thermal fan set - $COUNT check mic_type=$mic_type, mic_type_new=$mic_type_new : enable_fan, disable_mic" > /dev/kmsg
				disable_mic
			fi
		fi
		COUNT=$(($COUNT+1))
	done
	exit 0
	#CHECK IF vendor.asus.fan.mic changed during running this process---
fi

