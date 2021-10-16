#!/vendor/bin/sh

#prop_type=`getprop vendor.asus.dongletype`

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Inbox_FW | cut -d ':' -f 2`
setprop vendor.asusfw.inbox.aura_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep DT_aura_FW | cut -d ':' -f 2`
setprop vendor.asusfw.dt.aura_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Station_aura_FW | cut -d ':' -f 2`
setprop vendor.asusfw.station.aura_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep DT_Power_FW | cut -d ':' -f 2`
setprop vendor.asusfw.dt.power_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Station2_EC_FW | cut -d ':' -f 2`
setprop vendor.asusfw.station2.ec_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Station3_EC_FW | cut -d ':' -f 2`
setprop vendor.asusfw.station3.ec_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep DT_Hub1_FW | cut -d ':' -f 2`
setprop vendor.asusfw.dt.hub1_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep DT_Hub2_FW | cut -d ':' -f 2`
setprop vendor.asusfw.dt.hub2_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Station_PD_FW | cut -d ':' -f 2`
setprop vendor.asusfw.station.pd_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep DT_PD_FW | cut -d ':' -f 2`
setprop vendor.asusfw.dt.pd_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad_left | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad.left_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad_holder | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad.holder_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad_dongle | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad.wireless_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad3_left | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad3.left_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad3_middle | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad3.middle_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad3_right | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad3.right_fwver $FW_VER

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep gamepad3_bt | cut -d ':' -f 2`
setprop vendor.asusfw.gamepad3.bt_fwver $FW_VER

setprop vendor.dt.updatepdon 1
setprop vendor.station.updatepdon 1

echo "[ACCY] Check Accy AsusFW Ver Done" > /dev/kmsg
