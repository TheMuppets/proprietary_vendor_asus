
dis_flag=`getprop persist.vendor.disable.vib`

if [ $dis_flag -eq 1 ] ; then
setprop persist.vendor.disable.vib 0
else
setprop vendor.asus.boot.vib 1
fi
