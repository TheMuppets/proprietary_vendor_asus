#!/vendor/bin/sh

check_audio_calibration=`getprop vendor.audio.calibration.rcv`

echo "[ASUS][ReceiverCalibration] Begin Check Receiver calibration status" > /dev/kmsg
log -p d -t [ASUS][ReceiverCalibration] Begin Check Receiver calibration status

echo "[ASUS][ReceiverCalibration] Check Receiver calibration status vendor.audio.calibration.rcv = $check_audio_calibration" > /dev/kmsg
log -p d -t [ASUS][ReceiverCalibration] Check Receiver calibration status vendor.audio.calibration.rcv = $check_audio_calibration

if [ "${check_audio_calibration}" != "pass" ];
	then
	echo "[ASUS][ReceiverCalibration] Without Receiver calibration property" > /dev/kmsg
	log -p d -t [ASUS][ReceiverCalibration] Without Receiver calibration property

		echo "[ASUS][ReceiverCalibration] Without asusfw Receiver calibration data, begin calibration again" > /dev/kmsg
		log -p d -t [ASUS][ReceiverCalibration] Without Receiver calibration data, begin calibration again
		Temp_data=`climax -d /dev/i2c-7 --slave=0x34 -r 0xf5`
		echo $Temp_data > /mnt/vendor/asusfw/audio/calibration_data/cal_self_receiver0_data_tmp.txt

		echo "[ASUS][ReceiverCalibration] Receiver calibrated result = $Temp_data" > /dev/kmsg
		log -p d -t [ASUS][ReceiverCalibration] Receiver calibrated result = $Temp_data

                numbers=`cat /mnt/vendor/asusfw/audio/calibration_data/cal_self_receiver0_data_tmp.txt | cut -c17-20`

                echo "[ASUS][ReceiverCalibration] parse_rcv_ohm_numbers = 0x$numbers" > /dev/kmsg
                log -p d -t [ASUS][ReceiverCalibration] parse_rcv_ohm_numbers = 0x$numbers

                value=`echo $((16#$numbers))`

                echo "[ASUS][ReceiverCalibration] parse_rcv_ohm_value = $value" > /dev/kmsg
                log -p d -t [ASUS][ReceiverCalibration] parse_rcv_ohm_value = $value

                setprop vendor.audio.calibration.rcv.value $value
else
	echo "[ASUS][ReceiverCalibration] Receiver already calibrated" > /dev/kmsg
	log -p d -t [ASUS][ReceiverCalibration] Receiver already calibrated
fi
