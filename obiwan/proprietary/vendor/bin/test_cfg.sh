#!/system/bin/sh

#check boot_complete
boot_complete=`getprop sys.boot_completed`
if [ "$boot_complete" == "1" ]; then
  sleep 2
  # touch fw version
  tp_version=`cat sys/devices/platform/goodix_ts.0/chip_info|sed -n '3 p' |awk -F ":" '{print $NF}'`
  cfg_version=`cat sys/devices/platform/goodix_ts.0/read_cfg|sed -n '1 p' |awk 'BEGIN{FS=" "}{print $1}'`
  echo "update test touch FW version : $tp_version" > /dev/kmsg
  echo "update test touch CFG version : $((16#$cfg_version))" > /dev/kmsg
  setprop vendor.touch.version.driver "$tp_version & $((16#$cfg_version))"
fi
