#!/vendor/bin/sh

LOG_TAG="update_accy_status2"
DT_PD_FW_VER=`getprop vendor.asusfw.dt.pd_fwver`
DT_HUB1_FW_VER=`getprop vendor.asusfw.dt.hub1_fwver`
DT_HUB2_FW_VER=`getprop vendor.asusfw.dt.hub2_fwver`

pd_version=`getprop vendor.dt.pd_fwver`
cc_status=`cat /sys/class/dual_role_usb/otg_default/mode`
hub1_version=`getprop vendor.dt.hub1_fwver`
hub2_version=`getprop vendor.dt.hub2_fwver`


if [ "$pd_version" != "$DT_PD_FW_VER" -a "$cc_status" != "none" ]; then
	echo "$LOG_TAG:[USB_ACCY] pd fw is $pd_version, need update to $DT_PD_FW_VER" > /dev/kmsg
	dt_pd_status=1
else
	echo "$LOG_TAG:[USB_ACCY] pd fw is $pd_version typec is $cc_status, no need to update to $DT_PD_FW_VER" > /dev/kmsg
	dt_pd_status=0
fi
if [ "$hub1_version" != "$DT_HUB1_FW_VER" ]; then
	echo "$LOG_TAG:[USB_ACCY] hub1 fw is $hub1_version, need update to $DT_HUB1_FW_VER" > /dev/kmsg
	hub1_update=1
else
	echo "$LOG_TAG:[USB_ACCY] hub1 fw is newest, no need to update" > /dev/kmsg
	hub1_update=0
fi
if [ "$hub2_version" != "$DT_HUB2_FW_VER" ]; then
	echo "$LOG_TAG:[USB_ACCY] hub2 fw is $hub2_version, need update to $DT_HUB2_FW_VER" > /dev/kmsg
	hub1_update=1
	hub2_update=1
else
	echo "$LOG_TAG:[USB_ACCY] hub2 fw is newest, no need to update" > /dev/kmsg
	hub2_update=0
fi

type=`getprop vendor.asus.dongletype`
if [ "$type" == "3" ]; then
	echo "$LOG_TAG:[USB_ACCY] vendor.asus.accy.fw_status2 = 000$dt_pd_status$hub1_update$hub2_update" > /dev/kmsg
	setprop vendor.asus.accy.fw_status2 000"$dt_pd_status""$hub1_update""$hub2_update"
	setprop vendor.dt.accy_statusupdate 0
else
	echo "$LOG_TAG:[USB_ACCY] DT is disconnect, ignore" > /dev/kmsg
	setprop vendor.dt.accy_statusupdate 2
fi

