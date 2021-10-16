#!/system/vendor/bin/sh

# Set selinux
echo 1 > /sys/fs/selinux/log
sleep 5
echo 1 > /sys/fs/selinux/log

echo "Start clear csc log"
LOG_LOGCAT_FOLDER='/data/logcat_log'
LOG_MODEM_FOLDER='/sdcard/diag_logs'

#rm logcat logs
startLogProp=`getprop persist.vendor.asus.startlog`
if [ "${startLogProp}" = "1" ]; then
	rm -rf $LOG_LOGCAT_FOLDER/kernel.log.*
	rm -rf $LOG_LOGCAT_FOLDER/logcat.txt.*
	rm -rf $LOG_LOGCAT_FOLDER/logcat-radio.txt.*
	rm -rf $LOG_LOGCAT_FOLDER/logcat-events.txt.*
	sleep 3
else
	rm -rf $LOG_LOGCAT_FOLDER/kernel.log*
	rm -rf $LOG_LOGCAT_FOLDER/logcat.txt*
	rm -rf $LOG_LOGCAT_FOLDER/logcat-radio.txt*
	rm -rf $LOG_LOGCAT_FOLDER/logcat-events.txt*
	sleep 3
fi

#rm wlan_logs log
wait_cmd=`rm -rf /data/vendor/wifi/wlan_logs/*`
sync
echo "rm -rf /data/vendor/wifi/wlan_logs/*"

if [ -d "/data/media/0/diag_logs/" ]; then
	#add to stop and then capture modem log problem
	enableQXDM=`getprop persist.vendor.asus.qxdmlog.enable`
	if [ "${enableQXDM}" = "1" ]; then
		wait_cmd=`setprop persist.vendor.asus.qxdmlog.enable 0`
		echo "Turn off QXDM log for clear log"
		sleep 3
		sync
		QXDM_turn_off=1
	fi
		
	#rm QXDM log
	wait_cmd=`rm -rf /data/media/0/diag_logs`
	sync

	#add to stop and then capture modem log problem
	if [ "${QXDM_turn_off}" = "1" ]; then
		wait_cmd=`setprop persist.vendor.asus.qxdmlog.enable 1`
		echo "Turn on QXDM log for clear log"
		QXDM_turn_off=0
	fi
fi
# Delete logcat log & tcp dump

setprop vendor.asus.clearlog 0

# Set selinux
startlog_flag=`getprop persist.vendor.asus.startlog`
if test "$startlog_flag" -eq 0; then
	echo 0 > /sys/fs/selinux/log
else
	echo 1 > /sys/fs/selinux/log
fi
