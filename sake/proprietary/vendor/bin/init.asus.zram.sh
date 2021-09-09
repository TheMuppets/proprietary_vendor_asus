lahaina_set=`getprop vendor.asus.zram_setting`
if test "$lahaina_set" != "1"; then
	echo  "[asus_zram] init.kernel.post_boot-lahaina.sh not finished yet!"> /dev/kmsg
	exit 0
fi
disksize=`getprop vendor.zram.disksize`
zram_enable=`getprop vendor.zram.enable`

MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}
let RamSizeGB="( $MemTotal / 1048576 ) + 1"

if test "$disksize" = ""; then
	disksize="4096M"
fi
echo "[asus_zram]RamSizeGB=${RamSizeGB}" > /dev/kmsg
if test "$zram_enable" = "1"; then
	if [ $RamSizeGB -le 7 ]; then  #this is for 6G; or the value will be 4G(8G,12G,16G,18G,etc)
		disksize="( $RamSizeGB * 1024 ) / 2""M"
	fi
	swapoff /dev/block/zram0 2>/dev/kmsg
	echo 1 > sys/block/zram0/reset 2>/dev/kmsg
	sleep 1
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo $disksize > /sys/block/zram0/disksize 2>/dev/kmsg
	mkswap /dev/block/zram0 2>/dev/kmsg
	swapon /dev/block/zram0 -p 32758 2>/dev/kmsg
	echo "[asus_zram]write zram disksize=${disksize}" > /dev/kmsg
fi
if test "$zram_enable" = "0"; then
	swapoff /dev/block/zram0 2>/dev/kmsg
	echo "[asus_zram]turn off the zram" > /dev/kmsg
fi


