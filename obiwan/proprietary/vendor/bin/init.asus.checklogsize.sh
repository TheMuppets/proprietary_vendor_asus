#!/system/bin/sh
checklogsize_prop=`getprop persist.vendor.asus.checklogsize`

#===========getdirsize==============#
g_dirsize=0
function getdirsize()
{
  size=0
  for file in `ls $1`
  do  
    local path=$1"/"$file  
    if [ -d $path ]  
     then  
      echo "DIR $path"  
      getdirsize $path  
    else  
      size=`stat -c%s $path`
#      echo "size of $path is ===> $size"
      g_dirsize=`expr $g_dirsize + $size`
#      echo "g_dirsize is ===> $g_dirsize"
    fi  
  done
}
#=========getfilesizewithkeyword=========#
g_filesize=0
function getfilesizewithkeyword()
{
	size=0
	if [ -d $1 ]; then
		for x in `ls -a $1 |grep $2`
		do
			size=`stat -c%s $1/$x`
#			echo "size of $x is ===> $size"
			g_filesize=`expr $g_filesize + $size`
#			echo "g_filesize is ===> $g_filesize"
		done
	fi
}
#============check_general_log_size=============#
general_log_size=0
function check_general_log_size() 
{
	#check data/tombstones
	g_dirsize=0
	getdirsize /data/tombstones
	echo "/data/tombstones size ===> $g_dirsize"
	general_log_size=`expr $general_log_size + $g_dirsize`
	#check /d/ion
	g_dirsize=0
	getdirsize /d/ion
	echo "/d/ion size ===> $g_dirsize"
	general_log_size=`expr $general_log_size + $g_dirsize`
	#check /asdf
	g_dirsize=0
	getdirsize /asdf
	echo "/asdf size ===> $g_dirsize"
	general_log_size=`expr $general_log_size + $g_dirsize`
	#check /data/anr
	g_dirsize=0
	getdirsize /data/anr
	echo "/data/anr size ===> $g_dirsize"
	general_log_size=`expr $general_log_size + $g_dirsize`
	#check /data/logcat_log/logcat*
	g_filesize=0
	getfilesizewithkeyword /data/logcat_log logcat
	echo "/data/logcat_log/logcat* size ===> $g_filesize"
	general_log_size=`expr $general_log_size + $g_filesize`
	#echo "check_general_log_size size ===> $general_log_size"
}
#============check_modem_log_size=============#
modem_log_size=0
function check_modem_log_size() 
{
	#check /sdcard/diag_logs/QXDM_logs
	g_dirsize=0
	getdirsize /sdcard/diag_logs/QXDM_logs
	echo "/sdcard/diag_logs/QXDM_logs is ===> $g_dirsize"
	modem_log_size=$g_dirsize
}
#============check_tcpdump_log_size=============#
tcpdump_log_size=0
function check_tcpdump_log_size() 
{
	#check /data/logcat_log/capture.pcap.*
	g_filesize=0
	getfilesizewithkeyword /data/logcat_log capture.pcap
	echo "/data/logcat_log/capture.pcap.* is ===> $g_filesize"
	tcpdump_log_size=$g_filesize
}

#============main=============#
if [ ".$checklogsize_prop" == ".1" ]; then
	setprop persist.vendor.asus.logsize 0
	general_log_size=0
	check_general_log_size
	echo "check_general_log_size is ===> $general_log_size"
	setprop persist.vendor.asus.logsize $general_log_size
	am broadcast -a "com.asus.checklogsize.completed"
elif [ ".$checklogsize_prop" == ".2" ]; then
	setprop persist.vendor.asus.logsize 0
	modem_log_size=0
	check_modem_log_size
	echo "check_modem_log_size is ===> $modem_log_size"
	setprop persist.vendor.asus.logsize $modem_log_size
	am broadcast -a "com.asus.checklogsize.completed"
elif [ ".$checklogsize_prop" == ".3" ]; then
	setprop persist.vendor.asus.logsize 0
	tcpdump_log_size=0
	check_tcpdump_log_size
	echo "check_tcpdump_log_size is ===> $tcpdump_log_size"
	setprop persist.vendor.asus.logsize $tcpdump_log_size
	am broadcast -a "com.asus.checklogsize.completed"
elif [ ".$checklogsize_prop" == ".4" ]; then
	setprop persist.vendor.asus.logsize 0
	totallogsize=0
	general_log_size=0
	check_general_log_size
	totallogsize=`expr $totallogsize + $general_log_size`
	echo "totallogsize is ===> $totallogsize"
	
	modem_log_size=0
	check_modem_log_size
	totallogsize=`expr $totallogsize + $modem_log_size`
	echo "totallogsize is ===> $totallogsize"
	
	tcpdump_log_size=0
	check_tcpdump_log_size
	totallogsize=`expr $totallogsize + $tcpdump_log_size`
	echo "totallogsize is ===> $totallogsize"
	
	setprop persist.vendor.asus.logsize $totallogsize
	am broadcast -a "com.asus.checklogsize.completed"
fi
