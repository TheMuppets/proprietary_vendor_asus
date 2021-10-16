#!/vendor/bin/sh
rotation_type=`getprop sys.screen.rotation`
echo "rotation_type : $rotation_type" > /dev/kmsg

echo $rotation_type> sys/devices/platform/goodix_ts.0/rotation_type



