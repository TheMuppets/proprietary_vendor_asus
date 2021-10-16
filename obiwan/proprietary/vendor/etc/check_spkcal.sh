#!/vendor/bin/sh

check_audio_calibration=`getprop vendor.audio.calibration.spk`

echo "[ASUS][SpeakerCalibration] Begin Check Speaker calibration status" > /dev/kmsg
log -p d -t [ASUS][SpeakerCalibration] Begin Check Speaker calibration status
echo "[ASUS][SpeakerCalibration] Check Speaker calibration status vendor.audio.calibration.spk = $check_audio_calibration" > /dev/kmsg
log -p d -t [ASUS][SpeakerCalibration] Check Speaker calibration status vendor.audio.calibration.spk = $check_audio_calibration

if [ "${check_audio_calibration}" != "pass" ];
	then
	echo "[ASUS][SpeakerCalibration] Without Speaker calibration property" > /dev/kmsg
	log -p d -t [ASUS][SpeakerCalibration] Without Speaker calibration property

	if [ ! -f "/mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt" ];then
		echo "[ASUS][SpeakerCalibration] Original /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt does not exist" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Original /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt does not exist
	else
		check_audio_calibration_data=$(cat /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt)
		echo "[ASUS][SpeakerCalibration] Original /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt = $check_audio_calibration_data" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Original /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt = $check_audio_calibration_data
	fi

		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/0x34_aftercalmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/0x34_origmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/0x35_aftercalmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/0x35_origmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/spkcal_save_0x34_aftercalmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/spkcal_save_0x34_origmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/spkcal_save_0x35_aftercalmtp.txt
		echo 0 > /mnt/vendor/asusfw/audio/calibration_data/spkcal_save_0x35_origmtp.txt


		echo "[ASUS][SpeakerCalibration] Speaker Begin calibrated step" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Speaker Begin calibrated step

		Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --resetmtpex -b`
		echo "$Temp_data" > /mnt/vendor/asusfw/audio/calibration_data/cal_self_recal_speaker0_log_tmp.txt

		echo "[ASUS][SpeakerCalibration] Speaker Begin resetmtpex = $Temp_data" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Speaker Begin resetmtpex = "$Temp_data"

		sleep 1

		Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --calibrate=once -b`
		echo "$Temp_data" > /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_log.txt.txt

		echo "[ASUS][SpeakerCalibration] Speaker Begin calibrated = $Temp_data" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Speaker Begin calibrated = "$Temp_data"

		sleep 1

		Temp_data=`climax -d /dev/i2c-7 --slave=0x35 -r 0xf5`
		echo $Temp_data > /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_data_tmp.txt

		echo "[ASUS][SpeakerCalibration] Speaker calibrated result = $Temp_data" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Speaker calibrated result = $Temp_data


                numbers=`cat /mnt/vendor/asusfw/audio/calibration_data/cal_self_speaker0_data_tmp.txt | cut -c17-20`
                
                echo "[ASUS][SpeakerCalibration] parse_spk_ohm_numbers = 0x$numbers" > /dev/kmsg
                log -p d -t [ASUS][SpeakerCalibration] parse_spk_ohm_numbers = 0x$numbers
                
                value=`echo $((16#$numbers))`
                
                echo "[ASUS][SpeakerCalibration] parse_spk_ohm_numbers = $value" > /dev/kmsg
                log -p d -t [ASUS][SpeakerCalibration] parse_spk_ohm_numbers = $value
                
                setprop vendor.audio.calibration.spk.value $value

		/vendor/bin/sh /vendor/etc/check_rcvcal.sh

else
	echo "[ASUS][SpeakerCalibration] Speaker already calibrated" > /dev/kmsg
	log -p d -t [ASUS][SpeakerCalibration] Speaker already calibrated
fi
