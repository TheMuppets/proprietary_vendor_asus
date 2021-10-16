a=`cat /proc/cmdline`
test="androidboot.id.ddr="
pos=`awk -v a="$a" -v b="$test" 'BEGIN{print index(a,b)}'`
pos=`expr $pos - 1`
len=`echo ${#test}`
len=`expr $len + 5`
#echo $pos
#echo $len
#echo $a

target=${a:$pos:$len}
#echo $target

target=`echo $target|cut -d " " -f 1`
#echo $target

id=`echo $target|cut -d "=" -f 2`
#echo id=$id

case $id in
	1 )
		vid="SAMSUNG"
		fake_id="0x01"
;;
	6 )
		vid="HYNIX"
		fake_id="0x06"
;;
	255 )
		vid="MICRON"
		fake_id="0x0F"
;;
	* )
		vid="unknown_vendor"
		fake_id="unknown_fake_id"
;;

esac
echo vid=$vid fake_id=$fake_id


sizeK=`cat /proc/meminfo  |grep -i MemTotal |awk '{print $2}'`
sizeM=`expr $sizeK / 1024`
sizeG=`expr $sizeM / 1024`
echo $sizeK KB
echo $sizeM MB
echo $sizeG GB
unit=GB

#setprop asus.ddr_info "$vid $type $sizeG$unit"
setprop vendor.asus.ddr_info "$vid"

setprop ro.vendor.atd.memvendor "$fake_id"
