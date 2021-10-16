#/system/bin/sh

echo 1 > /sys/fs/selinux/log
sleep 1
disksize=`getprop persist.vendor.zram.disksize`
zram_enable=`getprop persist.vendor.zram.enable`

if test "$disksize" = ""; then
	disksize="4096M"	
fi
if test "$zram_enable" = "1"; then
	swapoff /dev/block/zram0 2>/dev/kmsg
	echo 1 > sys/block/zram0/reset 2>/dev/kmsg
	sleep 1
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo $disksize > /sys/block/zram0/disksize 2>/dev/kmsg
	mkswap /dev/block/zram0 2>/dev/kmsg
	swapon /dev/block/zram0 -p 32758 2>/dev/kmsg
fi
if test "$zram_enable" = "0"; then
	swapoff /dev/block/zram0 2>/dev/kmsg
fi

sleep 5
echo 0 > /sys/fs/selinux/log
