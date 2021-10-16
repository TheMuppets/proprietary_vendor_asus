#!/vendor/bin/sh
#waiting sepolicy
setprop debug.vendor.vib.cali.state running...
sleep 5

rm -f /mnt/vendor/persist/aw_cali.bin
rm -f /mnt/vendor/persist/aw_rtp_cali.bin

echo 1 > /sys/class/leds/vibrator/cali
sleep 1
echo 1 > /sys/class/leds/vibrator/osc_cali
sleep 1

cali_r=`cat /sys/class/leds/vibrator/load_cali`
#echo 1:$cali_r
len1=`expr ${#cali_r}`
#echo len1:$len

r=`echo $cali_r |grep fail`
#echo 2:$r
len2=`expr ${#r}`
#echo len2:$len

if [ $len2 -eq 0 ] && [ $len1 -ne 0 ]; then
  setprop debug.vendor.vib.cali.state PASS
  echo PASS
elif [ $len1 -eq 0 ]; then
  setprop debug.vendor.vib.cali.state Fail1
  echo Fail. Permission denied
else
  setprop debug.vendor.vib.cali.state Fail2
  echo $cali_r
fi
