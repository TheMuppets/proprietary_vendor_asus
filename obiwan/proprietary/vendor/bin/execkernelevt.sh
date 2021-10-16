#!/system/vendor/bin/sh

EXEC_REASON=`getprop vendor.asus.kernelevent`
DUMP_PID=`getprop vendor.asus.dumppid`
UTS_ENABLE=`getprop persist.vendor.asus.mupload.enable`
ROTATION_NUMBER=3
DUMPSYS_PATH="/asdf/dumpsys_meminfo"


if [ "$EXEC_REASON" == "dumpmem" ]; then
	echo "[Debug][execkernelevt]dumpmem: lowmemorykiller kill process adj < 100, dumpsys meminfo" > /dev/kmsg

	mkdir -p $DUMPSYS_PATH

	file_list=(`ls $DUMPSYS_PATH | grep dumpsys_meminfo | sort`)
	echo "[Debug][execkernelevt]dumpmem: file list number: ${#file_list[@]}" > /dev/kmsg

	if [ ${#file_list[@]} -gt 5 ]; then
		#
		# This should not be execute, just for sepolicy error to cause storage full
		#
		rm -rf rm $DUMPSYS_PATH
		mkdir $DUMPSYS_PATH
	fi

	if [ ${#file_list[@]} -ge $ROTATION_NUMBER ]; then
		echo "[Debug][execkernelevt]umpmem: file list >= $ROTATION_NUMBER" > /dev/kmsg
		i=0
		end_number=$((${#file_list[@]}-$ROTATION_NUMBER))
		echo "[Debug][execkernelevt]dumpmem: end_number: $end_number" > /dev/kmsg
		while [ $i -le $end_number ]; do
			echo "[Debug][execkernelevt]dumpmem: Delete ${file_list[$i]}" > /dev/kmsg
			rm $DUMPSYS_PATH/${file_list[$i]}
			i=$(($i+1))
		done
	fi
	current_time=`date +%Y_%m_%d_%H_%M_%S`
	dumpsys meminfo -a > $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt

        echo "                                                            " >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        echo "cmdline: " >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        cat /proc/$DUMP_PID/cmdline  >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        echo "***************Dump smaps start ****************************" >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        cat /proc/$DUMP_PID/smaps >> $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        echo "***************Dump smaps end*******************************" >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        echo "***************Dump maps start ****************************" >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        cat /proc/$DUMP_PID/maps >> $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt
        echo "***************Dump maps end*******************************" >>  $DUMPSYS_PATH/${current_time}_dumpsys_meminfo.txt

	echo "[Debug][execkernelevt]dumpmem: end"  > /dev/kmsg
	
elif [ "$EXEC_REASON" == "savelogmtp" ]; then
	echo "[Debug][execkernelevt]savelogmtp: start savelogmtp service" > /dev/kmsg

	setprop ctl.start "savelogmtp"
	echo 3000 > /sys/class/timed_output/vibrator/enable		

elif [ "$EXEC_REASON" == "dumpbusythread" ]; then
	echo "[Debug][execkernelevt]dumpBusyThread+++ " > /dev/kmsg
	top  -t -m 5 -n 1 > /dev/kmsg
	vmstat 1 5 > /dev/kmsg
	echo "[Debug][execkernelevt]dumpBusyThread--- " > /dev/kmsg

elif [ "$EXEC_REASON" == "slowlog" ]; then
	if [ "$UTS_ENABLE" == "1" ]; then
		echo "[Debug][execkernelevt]slowlog+++ " > /dev/kmsg
		echo slowlog > /proc/asusdebug
		echo "[Debug][execkernelevt]slowlog--- " > /dev/kmsg
	fi

fi



setprop vendor.asus.kernelevent ""


