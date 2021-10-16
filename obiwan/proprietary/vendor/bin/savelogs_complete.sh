#!/system/bin/sh
uts=`getprop persist.vendor.asus.uts`
savelogs_prop=`getprop persist.vendor.asus.savelogs`
am broadcast -a $uts -n com.asus.loguploader/.logtool.LogtoolReceiver --ei logtype $savelogs_prop
echo "savelogs_complete Done"
