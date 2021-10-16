#!/vendor/bin/sh
kernelmessage_flag=`getprop persist.vendor.asus.kernelmessage`
is_oemuartlog_exist=`cat /proc/cmdline | grep userdebug`

if test "$is_oemuartlog_exist"; then
    echo 7 > /proc/sys/kernel/printk
else
    echo "$kernelmessage_flag" > /proc/sys/kernel/printk
fi
