#!/vendor/bin/sh

driver_log_level_idx=`getprop persist.vendor.asus.wlanfwdbgini`
driver_log_en=`getprop persist.vendor.asus.wlanfwdbg`

log -t WiFiFWTool driver_log_en=$driver_log_en, driver_log_level_idx=$driver_log_level_idx

if [ "$driver_log_en" = "1" ];then
	if [ "$driver_log_level_idx" = "" ];then
		echo -n "disable" > /sys/module/cnss2/parameters/do_wlan_driver_log_level;
	else
		echo -n "$driver_log_level_idx" > /sys/module/cnss2/parameters/do_wlan_driver_log_level;
	fi
elif [ "$driver_log_en" = "0" ];then
	echo -n "disable" > /sys/module/cnss2/parameters/do_wlan_driver_log_level;
else
	log -t WiFiFWTool unknown parameters
fi

