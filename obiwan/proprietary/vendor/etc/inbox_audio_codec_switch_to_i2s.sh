#!/vendor/bin/sh

##########################################################################
##                                                                      ##
##  This is the tool for Asus ZS661KS Audio Inbox                       ##
##  switch Inbox operation node from USB mode to I2S mode               ##
##                                                                      ##
##########################################################################

function Inbox_audio_switch_to_I2S() {

                inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)

                echo "[ASUS][Inbox_audio_switch_to_I2S] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch

                # Disable inbox 3.3V Vdd
                echo 0 > /sys/class/ec_hid/dongle/device/pogo_detect
                sleep 1
                echo "[ASUS][Inbox_audio_switch_to_I2S] Disable inbox 3.3V Vdd" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Disable inbox 3.3V Vdd


                # Select inbox working mode >  1 : I2S mode ; 0 : USB mode
                echo 1 > /sys/class/ec_hid/dongle/device/inbox_audio_switch

                echo "[ASUS][Inbox_audio_switch_to_I2S] Select inbox_audio_switch to I2S mode" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Select inbox_audio_switch to I2S mode

                # Set inbox select pin >  1 : I2S mode ; 0 : USB mode
                echo 1 > /sys/class/ec_hid/dongle/device/pogo_sleep
                sleep 1
                echo "[ASUS][Inbox_audio_switch_to_I2S] Set inbox select pin to high" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Set inbox select pin to high

                # Enable inbox 3.3V Vdd
                echo 1 > /sys/class/ec_hid/dongle/device/pogo_detect
                echo "[ASUS][Inbox_audio_switch_to_I2S] Enable inbox 3.3V Vdd" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Enable inbox 3.3V Vdd
                
                sleep 2

                # Setting inbox I2S mode irq setting
                rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
                if test $rt5683_get_irq_setting -eq 1
                then
                        echo "[ASUS][Inbox_audio_switch_to_I2S] rt5683_get_irq_setting $rt5683_get_irq_setting already setted" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] rt5683_get_irq_setting $rt5683_get_irq_setting already setted
                else
                        echo "[ASUS][Inbox_audio_switch_to_I2S] Set rt5683_get_irq_setting to 1" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Set rt5683_get_irq_setting to 1
                        # Release inbox I2S mode irq setting
                        echo 1 > /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting
                fi

                sleep 1

                rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)
                if test $rt5683_enable_irq_setting -eq 1
                then
                        echo "[ASUS][Inbox_audio_switch_to_I2S] rt5683_enable_irq_setting $rt5683_enable_irq_setting already enabled " > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] rt5683_enable_irq_setting $rt5683_enable_irq_setting already enabled
                else
                        echo "[ASUS][Inbox_audio_switch_to_I2S] Set rt5683_enable_irq_setting to 1" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Set rt5683_enable_irq_setting to 1
                        # Enable inbox I2S mode irq setting
                        echo 1 > /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting
                fi

        # Switch USB D+D- Back to Inbox side USB port
        echo "[ASUS][Inbox_audio_switch_to_I2S] Set force_usb_mux to 0" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Set force_usb_mux to 0
        echo 0 > /sys/class/power_supply/battery/device/force_usb_mux
}

function Inbox_audio_switch() {

        # Check Switch operation mode
        Switch_mode=`getprop vendor.inbox.audio_switch_mode`
        System_Switch_mode=`sys.inbox.audio_switch_mode`

        echo "[ASUS][Inbox_audio_switch] Get audio_switch_mode=$Switch_mode ,system property=$System_Switch_mode" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch] Get audio_switch_mode=$Switch_mode ,system property=$System_Switch_mode

        if test $Switch_mode -eq 2
        then
                Inbox_audio_switch_to_I2S
        else
                echo "[ASUS][Inbox_audio_switch] Invalid operation=$Switch_mode ,system property=$System_Switch_mode" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch] Get Invalid operation=$Switch_mode ,system property=$System_Switch_mode
        fi
}


pogo_sleep=$(cat /sys/class/ec_hid/dongle/device/pogo_sleep)
inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)
rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)

value=$(expr $pogo_sleep + $inbox_audio_switch + $rt5683_get_irq_setting + $rt5683_enable_irq_setting)

echo "[ASUS][Inbox_audio_switch] Begin check pogo_sleep = $pogo_sleep , inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , value = $value" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch] Begin check pogo_sleep = $pogo_sleep , inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , value = $value


Inbox_audio_switch


pogo_sleep=$(cat /sys/class/ec_hid/dongle/device/pogo_sleep)
inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)
rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)

value=$(expr $pogo_sleep + $inbox_audio_switch + $rt5683_get_irq_setting + $rt5683_enable_irq_setting)

echo "[ASUS][Inbox_audio_switch] After check pogo_sleep = $pogo_sleep , inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , value = $value" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch] After check pogo_sleep = $pogo_sleep , inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , value = $value


if test $value -eq 4
then
        RESULT=1;
else
        RESULT=0;
fi

echo "[ASUS][Inbox_audio_switch_to_I2S] RESULT = $RESULT" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch_to_I2S] RESULT = $RESULT

if [[ $RESULT -eq 1 ]]
then

        echo "[ASUS][Inbox_audio_switch_to_I2S] set current_audio_mode=1" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] set current_audio_mode=1

        setprop vendor.inbox.current_audio_mode 1

        sleep 2

        inbox_audio=`cat /sys/class/rt5683/rt5683_i2s_inbox/rt5683_firmware`
        setprop vendor.inbox.audio_fwver $inbox_audio
        echo "[ASUS][Inbox_audio_switch_to_I2S] Switch I2S mode success, update Inbox audio codec fw version : $inbox_audio" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Switch I2S mode success, update Inbox audio codec fw version : $inbox_audio

        inbox_audio=`getprop vendor.inbox.audio_fwver`
        echo "[ASUS][Inbox_audio_switch_to_I2S] Get Inbox audio codec prop fw version : $inbox_audio" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] Get Inbox audio codec prop fw version : $inbox_audio

	echo "1";
else
        echo "[ASUS][Inbox_audio_switch_to_I2S] set current_audio_mode=0" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_I2S] set current_audio_mode=0

        setprop vendor.inbox.current_audio_mode 0
	echo "0";
fi

exit $RESULT

