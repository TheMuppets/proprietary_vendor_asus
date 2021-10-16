#!/system/bin/sh

# touch fw version
tp_version=`cat sys/devices/platform/goodix_ts.0/chip_info|sed -n '3 p' |awk -F ":" '{print $NF}'`
cfg_version=`cat sys/devices/platform/goodix_ts.0/read_cfg|sed -n '1 p' |awk 'BEGIN{FS=" "}{print $1}'`
echo "touch FW version : $tp_version" > /dev/kmsg
echo "touch CFG version : $((16#$cfg_version))" > /dev/kmsg
setprop vendor.touch.version.driver "$tp_version CFG: $((16#$cfg_version))"
