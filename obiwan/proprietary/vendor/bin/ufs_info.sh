
stroage_status=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_status`
stroage_healthA=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_health_A`
stroage_healthB=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_health_B`
storage_preEOL=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_preEOL | cut -d "x" -f 2`
storage_productID=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_productID`
storage_fw_version=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_fw_version`

storage_vendor_name=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_status | cut -d "-" -f 1`


fake_venderid_SAMSUNG="0x1"
fake_venderid_HYNIX="0x2"
fake_venderid_TOSHIBA="0x3"

fake_stroage_status="UNKNOWN"
fake_vendor_id="UNKNOWN"

if [ "x$storage_vendor_name" == "xSAMSUNG" ] ; then
	fake_vendor_id=$fake_venderid_SAMSUNG
	fake_stroage_status="$fake_vendor_id"-"`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_status | cut  -d '-' -f 2-`"
elif [ "x$storage_vendor_name" == "xHYNIX" ] ; then
	fake_vendor_id=$fake_venderid_HYNIX
	fake_stroage_status="$fake_vendor_id"-"`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_status | cut  -d '-' -f 2-`"
fi

date=`date "+%Y%m%d"`
setprop vendor.asus.storage.primary.health "0x$storage_preEOL"
setprop vendor.asus.storage.primary.healthtypeA "$stroage_healthA"
setprop vendor.asus.storage.primary.healthtypeB "$stroage_healthB"
#setprop vendor.asus.storage.primary.status "0x$storage_preEOL"-"$stroage_healthA"-"$stroage_healthB"-"$stroage_status"-"UFS"-"$date"
setprop vendor.asus.storage.primary.status "0x$storage_preEOL"-"$stroage_healthA"-"$stroage_healthB"-"$fake_stroage_status"-"UFS"-"$date"

#setprop asus.storage.primary.pid "$storage_productID"
#setprop asus.storage.primary.fw_ver "$storage_fw_version"

setprop vendor.asus.storage.primary.vendor "$fake_vendor_id"

setprop vendor.asus.storage.primary.type UFS
storage_size=`cat /sys/devices/platform/soc/1d84000.ufshc/ufs_total_size`
setprop vendor.asus.storage.primary.size "$storage_size"GB


vid=`echo $stroage_status |cut -d"-" -f -1`
setprop vendor.asus.storage.primary.ufs_info "$vid $storage_productID $storage_fw_version"

setprop ro.vendor.atd.datafmt "F2FS"