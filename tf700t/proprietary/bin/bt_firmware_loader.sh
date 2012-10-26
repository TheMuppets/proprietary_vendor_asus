#!/system/bin/sh
logi ()
{
    /system/bin/log -t "hciattach" -p i "$@"
}
project=`getprop wifi.module.type`

if [ $project -eq 0 ]; then
	logi "AZW_NH660 BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4330B1_002.001.003.0379.0390.hcd --enable_lpm --no2bytes --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 1 ]; then
	logi "AZW_NH615 BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4329B1_002.002.023.0797.0863.hcd --enable_lpm --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 2 ]; then
	logi "AZW_NH665 BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4330B1_002.001.003.0750.0820.hcd --enable_lpm --no2bytes --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 3 ]; then
	logi "MURATA_LBEH19UQJC BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4329B1_002.002.023.0797.0879.hcd --enable_lpm --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 4 ]; then
	logi "AZW_NH669 BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4330B1_002.001.003.0609.0636.hcd --enable_lpm --no2bytes --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 5 ]; then
	logi "MURATA_LBEH5UEVVC BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM4334B0_002.001.013.0258.0306.hcd --enable_lpm --no2bytes --tosleep=5000 /dev/ttyHS2
elif [ $project -eq 6 ]; then
	logi "AZW_NH691 BT_HCD_FILE"
	brcm_patchram_plus --enable_hci --scopcm=0,2,0,0,0,0,0,0,0,0 --baudrate 3000000 --use_baudrate_for_download --patchram /etc/firmware/BCM43241B0_002.001.013.0024.0027.hcd --enable_lpm --no2bytes --tosleep=5000 /dev/ttyHS2
fi
