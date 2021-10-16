#!/system/bin/sh

dongle_type=`getprop vendor.asus.dongletype`
echo $dongle_type > sys/devices/platform/goodix_ts.0/dongle_state

#check boot_complete
boot_complete=`getprop sys.boot_completed`
if [ "$boot_complete" == "1" ]; then
  if [ "$dongle_type" == "2" ]; then
    echo 1 > sys/devices/platform/goodix_ts.0/load_station_cfg 
  else
    echo 0 > sys/devices/platform/goodix_ts.0/load_station_cfg 
  fi
  # touch fw version
  tp_version=`cat sys/devices/platform/goodix_ts.0/chip_info|sed -n '3 p' |awk -F ":" '{print $NF}'`
  cfg_version=`cat sys/devices/platform/goodix_ts.0/read_station_cfg`
  echo "update station mode touch FW version : $tp_version" > /dev/kmsg
  echo "update station mode touch CFG version : $((16#$cfg_version))" > /dev/kmsg
  setprop vendor.touch.version.driver "$tp_version CFG:$((16#$cfg_version))"
fi
