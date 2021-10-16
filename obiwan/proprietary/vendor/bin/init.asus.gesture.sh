#!/vendor/bin/sh
echo "get zenmotion gesture" > /dev/kmsg
gesture_type=`getprop persist.asus.gesture.type`
echo "gesture_type : $gesture_type" > /dev/kmsg
echo "$gesture_type" > sys/devices/platform/goodix_ts.0/gesture/zenmotion