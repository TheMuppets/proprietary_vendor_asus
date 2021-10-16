type=`getprop vendor.asus.dongletype`
if [ "$type" == "3" ]; then
	dt_mac=`cat /sys/class/net/eth0/address`
	#echo "[GetDtMAC] dt_mac = $dt_mac"
	setprop vendor.oem.asus.dtid $dt_mac
else
	exit 0
fi
