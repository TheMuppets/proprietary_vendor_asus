#!/vendor/bin/sh

export PATH=/vendor/bin

Grip_Check(){
	RESULT="PASS"
	setprop persist.grip.error_code 0
	sleep 5
	echo "*** START:$GRIP_CAL ***" >> /data/misc/grip/parse_result
	STR1=`cat /data/misc/grip/snt_result | cut -d " " -f 1`
	STR1=`echo $STR1|cut -d " " -f 1`
	echo "====part1====" >> /data/misc/grip/parse_result
	echo $STR1 >> /data/misc/grip/parse_result
	if [ "$STR1" == "FAILED" ]; then
		STR2=`cat /data/misc/grip/snt_result | cut -d " " -f 2`
		STR2=`echo $STR2| cut -d " " -f 1`
		echo "====part2====" >> /data/misc/grip/parse_result
		echo $STR2 >> /data/misc/grip/parse_result
        setprop persist.grip.error_code $STR2
	elif [ "$STR1" == "PASS" ]; then
		echo "====part3====" >> /data/misc/grip/parse_result
		echo $RESULT >> /data/misc/grip/parse_result
		setprop persist.grip.error_code $RESULT
	else
		echo "====part4====" >> /data/misc/grip/parse_result
		echo "STR1=$STR1 No condition meet" >> /data/misc/grip/parse_result
		setprop persist.grip.error_code $RESULT
	fi
	echo "*** END ***" >> /data/misc/grip/parse_result
}
Grip_Check_all(){
        RESULT="PASS"
        setprop persist.grip.error_code 0
        echo "*** START:$GRIP_CAL ***" >> /data/misc/grip/parse_result
        STR1=`cat /data/misc/grip/snt_result | cut -d " " -f 1`
        STR1=`echo $STR1|cut -d " " -f 1`
        echo "====part1====" >> /data/misc/grip/parse_result
        echo $STR1 >> /data/misc/grip/parse_result
        if [ "$STR1" == "FAILED" ]; then
                STR2=`cat /data/misc/grip/snt_result | cut -d " " -f 2`
                STR2=`echo $STR2| cut -d " " -f 1`
		STR3=`cat /data/misc/grip/snt_result | cut -d " " -f 3`
		STR3=`echo $STR3| cut -d " " -f 1`
		STR4="$STR2 $STR3"
                echo "====part2====" >> /data/misc/grip/parse_result
                echo $STR4 >> /data/misc/grip/parse_result
                setprop persist.grip.error_code "$STR4"
        elif [ "$STR1" == "PASS" ]; then
                echo "====part3====" >> /data/misc/grip/parse_result
                echo $RESULT >> /data/misc/grip/parse_result
                setprop persist.grip.error_code $RESULT
        else
                echo "====part4====" >> /data/misc/grip/parse_result
                echo "STR1=$STR1 No condition meet" >> /data/misc/grip/parse_result
                setprop persist.grip.error_code $RESULT
        fi
        echo "*** END ***" >> /data/misc/grip/parse_result
}

Grip_Check_file(){
        COUNT=0
        setprop persist.grip.error_code 0
        FOLDER=/data/misc/grip/snt_result
		while [ ! -f "$FOLDER" ] && [ $COUNT -le 59 ]
		do
		  COUNT=`expr $COUNT + 1`
		  echo "$FOLDER NOT EXIST, COUNT=$COUNT" >> /data/misc/grip/parse_result
		  sleep 1
		done
        echo "START:$GRIP_CAL" >> /data/misc/grip/parse_result
        STR1=`cat /data/misc/grip/snt_result | cut -d " " -f 1`
        STR1=`echo $STR1|cut -d " " -f 1`
        echo "part1" >> /data/misc/grip/parse_result
        echo $STR1 >> /data/misc/grip/parse_result
        if [ "$STR1" == "FAILED" ]; then
                STR2=`cat /data/misc/grip/snt_result | cut -d " " -f 2`
		STR2=`echo $STR2| cut -d " " -f 1`
		STR3=`cat /data/misc/grip/snt_result | cut -d " " -f 3`
		STR3=`echo $STR3| cut -d " " -f 1`
		STR4="$STR2 $STR3"
                echo "part2" >> /data/misc/grip/parse_result
                echo $STR4 >> /data/misc/grip/parse_result
                setprop persist.grip.error_code "$STR4"
        elif [ "$STR1" == "PASS" ]; then
                echo "part3" >> /data/misc/grip/parse_result
                echo "PASS" >> /data/misc/grip/parse_result
                setprop persist.grip.error_code "PASS"
        else
                echo "part4" >> /data/misc/grip/parse_result
                echo "STR1=$STR1 No condition meet" >> /data/misc/grip/parse_result
                setprop persist.grip.error_code "FAIL"
        fi
        echo "END" >> /data/misc/grip/parse_result
}

GRIP_CAL=`getprop debug.grip.calibration`

if [ "$GRIP_CAL" == "65535" ]; then
	exit
fi

if [ "$GRIP_CAL" == "01" ]; then
    setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar1
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "02" ]; then
    setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar2
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "03" ]; then
    setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar3
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "0" ]; then
    setprop persist.grip.calibration_done 0
#    /vendor/bin/SNTMfgUtil -r
#    echo 0x01 1 > /sys/snt8100fsr/set_reg
#    echo 0x2b 0x00ff > /sys/snt8100fsr/set_reg
#    echo 0x3b 0 > /sys/snt8100fsr/set_reg
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar1 bar2
#    mv /data/misc/grip/snt_result /data/misc/grip/snt_result_sb
#    Grip_Check_all
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
setprop persist.grip.test 0
if [ "$GRIP_CAL" == "1" ]; then
    setprop persist.grip.calibration_done 0
    setprop persist.grip.test 111
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -i
    Grip_Check_file
    chown shell:shell /vendor/factory/snt_sensor-pzt-avg
    chmod 666 /vendor/factory/snt_sensor-pzt-avg
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "2" ]; then
    setprop persist.grip.calibration_done 0
    rm /data/misc/grip/snt_result
    echo 0 > /sys/snt8100fsr/register_enable
    /vendor/bin/SNTMfgUtil -c pzt
    echo 0x38 0 > /sys/snt8100fsr/set_reg
    cat /vendor/factory/snt_reg_init > /sys/snt8100fsr/boot_init_reg
    echo 1 > /sys/snt8100fsr/register_enable
    Grip_Check_file
    cat /proc/lcd_unique_id > /vendor/factory/grip_panel_id
    chmod 666 /vendor/factory/grip_panel_id
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "3" ]; then
    setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
#    echo 1 > /sys/snt8100fsr/chip_reset
#    sleep 5
    echo 1 > /sys/snt8100fsr/wake_device
    echo 0x01 1 > /sys/snt8100fsr/set_reg
    echo 0x02 0x0032 > /sys/snt8100fsr/set_reg
    echo 0x2b 0x00ff > /sys/snt8100fsr/set_reg
    echo 0x39 0x0000 0x0000 0x0000 > /sys/snt8100fsr/set_reg
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -g
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "4" ]; then
    setprop persist.grip.calibration_done 0
#    /vendor/bin/SNTMfgUtil -r
    rm /data/misc/grip/snt_result
    sleep 1
    /vendor/bin/SNTMfgUtil -g --name touch --config /vendor/factory/snt_tchwv_configs.txt
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "5" ]; then
    setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -g --name deco --config /vendor/factory/snt_deco_configs.txt
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "6" ]; then
    setprop persist.grip.calibration_done 0
    echo 0x3d 4 > /sys/snt8100fsr/set_reg
    echo 1 > /sys/snt8100fsr/enable_sensor_evt
    echo 0x38 1 > /sys/snt8100fsr/set_reg
    echo 0x3e 1 > /sys/snt8100fsr/set_reg
    echo -1 > /sys/snt8100fsr/log_frames
    sleep 1
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "7" ]; then
    setprop persist.grip.calibration_done 0
    echo 0 > /sys/snt8100fsr/enable_sensor_evt
    echo 0x3e 0 > /sys/snt8100fsr/set_reg
    echo 0 > /sys/snt8100fsr/log_frames
    sleep 1
    cp /data/frame_data.log /data/misc/grip/mfg_ux_test_frame.bin
    setprop persist.grip.calibration_done 1
fi

if [ "$GRIP_CAL" == "101" ]; then
    setprop persist.grip.calibration_done 0
    BAR1_F=`/vendor/bin/busybox awk '/FRC LVL bar1/{print $5}' /vendor/factory/snt_sensor-pzt-avg | /vendor/bin/busybox tail -1`
    setprop persist.grip.error_code "$BAR1_F"
    echo $BAR1_F > /data/misc/grip/Cal_test_bar1
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "102" ]; then
    setprop persist.grip.calibration_done 0
    BAR2_F=`/vendor/bin/busybox awk '/FRC LVL bar2/{print $5}' /vendor/factory/snt_sensor-pzt-avg | /vendor/bin/busybox tail -1`
    setprop persist.grip.error_code "$BAR2_F"
    echo $BAR2_F > /data/misc/grip/Cal_test_bar2
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "103" ]; then
    setprop persist.grip.calibration_done 0
    BAR3_F=`/vendor/bin/busybox awk '/FRC LVL bar3/{print $5}' /vendor/factory/snt_sensor-pzt-avg | /vendor/bin/busybox tail -1`
    setprop persist.grip.error_code "$BAR3_F"
    echo $BAR3_F >> /data/misc/grip/Cal_test_bar3
    setprop persist.grip.calibration_done 1
fi


if [ "$GRIP_CAL" == "601" ]; then
    setprop persist.grip.calibration_done 0
    echo 1 > /sys/snt8100fsr/chip_reset
    sleep 3
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "602" ]; then
    setprop persist.grip.calibration_done 0
    echo 0x3d 4 > /sys/snt8100fsr/set_reg
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "603" ]; then
    setprop persist.grip.calibration_done 0
    echo 1 > /sys/snt8100fsr/enable_sensor_evt
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "604" ]; then
    setprop persist.grip.calibration_done 0
    echo 0x38 1 > /sys/snt8100fsr/set_reg
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "605" ]; then
    setprop persist.grip.calibration_done 0
    echo 0x3e 1 > /sys/snt8100fsr/set_reg
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "606" ]; then
    setprop persist.grip.calibration_done 0
    echo -1 > /sys/snt8100fsr/log_frames
    setprop persist.grip.calibration_done 1
fi

if [ "$GRIP_CAL" == "701" ]; then
    setprop persist.grip.calibration_done 0
    echo 0 > /sys/snt8100fsr/enable_sensor_evt
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "702" ]; then
    setprop persist.grip.calibration_done 0
    echo 0x3e 0 > /sys/snt8100fsr/set_reg
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "703" ]; then
    setprop persist.grip.calibration_done 0
    echo 0 > /sys/snt8100fsr/log_frames
    setprop persist.grip.calibration_done 1
fi


if [ "$GRIP_CAL" == "1000" ]; then
    setprop persist.grip.calibration_done 0
#    echo 1 > /sys/snt8100fsr/chip_reset
    echo 1 > /sys/snt8100fsr/wake_device
    echo 0x01 1 > /sys/snt8100fsr/set_reg
    echo 0x2b 0x00ff > /sys/snt8100fsr/set_reg
    echo 0x3d 4 > /sys/snt8100fsr/set_reg
    echo 0x3d 0 > /sys/snt8100fsr/set_reg
    echo 0x3b 0 > /sys/snt8100fsr/set_reg
    rm /data/misc/grip/snt_result    
    #setprop debug.grip.fpc.status 0
    /vendor/bin/SNTMfgUtil -a 1
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "1001" ]; then
    setprop persist.grip.calibration_done 0
 #   echo 1 > /sys/snt8100fsr/chip_reset
    echo 1 > /sys/snt8100fsr/wake_device
    echo 0x01 1 > /sys/snt8100fsr/set_reg
    echo 0x2b 0x00ff > /sys/snt8100fsr/set_reg
    echo 0x3d 4 > /sys/snt8100fsr/set_reg
    echo 0x3d 0 > /sys/snt8100fsr/set_reg
    rm /data/misc/grip/snt_result    
    #setprop debug.grip.fpc.status 0
    /vendor/bin/SNTMfgUtil -a 2
    Grip_Check_file
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "1002" ]; then
    setprop persist.grip.calibration_done 0
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "1003" ]; then
    setprop persist.grip.calibration_done 0
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "1004" ]; then
    setprop persist.grip.calibration_done 0
    setprop persist.grip.calibration_done 1
fi
