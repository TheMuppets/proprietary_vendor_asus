#!/vendor/bin/sh

##########################################################################
##                                                                      ##
##  This is the tool for Asus ZS661KS Audio Inbox                       ##
##  switch Inbox operation node from I2S mode to USB mode               ##
##                                                                      ##
##########################################################################

inbox_card_id="U5683"
inbox_card_id_without_headset="JEDI"

function Inbox_audio_switch_to_USB() {

        ## Begin Release I2S gpio and switch inbox_audio_switch flag to USB setting

                inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)

                echo "[ASUS][Inbox_audio_switch_to_USB] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_USB] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch

                # Force Select inbox working mode >  1 : I2S mode ; 0 : USB mode for I2S mode release issue
                echo 1 > /sys/class/ec_hid/dongle/device/inbox_audio_switch

                rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)
                if test $rt5683_enable_irq_setting -eq 0
                then
                        echo "[ASUS][Inbox_audio_switch_to_USB] rt5683_enable_irq_setting $rt5683_enable_irq_setting already disabled " > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] rt5683_enable_irq_setting $rt5683_enable_irq_setting already disabled
                else
                        echo "[ASUS][Inbox_audio_switch_to_USB] Set rt5683_enable_irq_setting to 0" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set rt5683_enable_irq_setting to 0
                        # Disable inbox I2S mode irq setting
                        echo 0 > /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting
                fi

                rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
                if test $rt5683_get_irq_setting -eq 0
                then
                        echo "[ASUS][Inbox_audio_switch_to_USB] rt5683_get_irq_setting $rt5683_get_irq_setting already released " > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] rt5683_get_irq_setting $rt5683_get_irq_setting already released
                else
                        echo "[ASUS][Inbox_audio_switch_to_USB] Set rt5683_get_irq_setting to 0" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set rt5683_get_irq_setting to 0
                        # Release inbox I2S mode irq setting
                        echo 0 > /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting
                fi

                echo "[ASUS][Inbox_audio_switch_to_USB] Set Inbox_audio_switch_to_USB to 0" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set Inbox_audio_switch_to_USB to 0

                # Select inbox working mode >  0 : I2S mode ; 0 : USB mode
                echo 0 > /sys/class/ec_hid/dongle/device/inbox_audio_switch

                InboxHeadset_status=$(cat /sys/bus/i2c/devices/2-001a/InboxHeadset_status)
                if test $InboxHeadset_status -eq 0
                then
                        echo "[ASUS][Inbox_audio_switch_to_USB] InboxHeadset_status $InboxHeadset_status already Unplug " > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] InboxHeadset_status $InboxHeadset_status already Unplug
                else
                        echo "[ASUS][Inbox_audio_switch_to_USB] Set InboxHeadset_status to 0" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set InboxHeadset_status to 0
                        # Release inbox I2S mode irq setting
                        echo 0 > /sys/bus/i2c/devices/2-001a/InboxHeadset_status
                fi


        # Begin change operation mode from I2S to USB mode

        # Trun off Codec Vdd
        echo "[ASUS][Inbox_audio_switch_to_USB] Set pogo_detect to 0" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set pogo_detect to 0
        echo 0 > /sys/class/ec_hid/dongle/device/pogo_detect

        # Switch Codec operation mode switch pin
        echo "[ASUS][Inbox_audio_switch_to_USB] Set pogo_sleep to 0" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set pogo_sleep to 0
        echo 0 > /sys/class/ec_hid/dongle/device/pogo_sleep

        # Switch USB D+D- to down USB port
        echo "[ASUS][Inbox_audio_switch_to_USB] Set force_usb_mux to 2" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set force_usb_mux to 2
        echo 2 > /sys/class/power_supply/battery/device/force_usb_mux

        sleep 1

        # Trun on Codec Vdd back
        echo "[ASUS][Inbox_audio_switch_to_USB] Set pogo_detect to 1" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set pogo_detect to 1
        echo 1 > /sys/class/ec_hid/dongle/device/pogo_detect

        # Switch USB D+D- Back to Inbox specical USB port
        echo "[ASUS][Inbox_audio_switch_to_USB] Set force_usb_mux to 1" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch_to_USB] Set force_usb_mux to 1
        echo 1 > /sys/class/power_supply/battery/device/force_usb_mux
}

function Inbox_audio_switch() {

        # Check Switch operation mode
        Switch_mode=`getprop vendor.inbox.audio_switch_mode`
        System_Switch_mode=`sys.inbox.audio_switch_mode`

        echo "[ASUS][Inbox_audio_switch] Get audio_switch_mode=$Switch_mode ,system property=$System_Switch_mode" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_switch] Get audio_switch_mode=$Switch_mode ,system property=$System_Switch_mode

        if test $Switch_mode -eq 1
        then
                Inbox_audio_switch_to_USB
        else
                echo "[ASUS][Inbox_audio_switch] Invalid operation=$Switch_mode ,system property=$System_Switch_mode" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch] Get Invalid operation=$Switch_mode ,system property=$System_Switch_mode
        fi
}


inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)
rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)
InboxHeadset_status=$(cat /sys/bus/i2c/devices/2-001a/InboxHeadset_status)

value=$(expr $inbox_audio_switch + $rt5683_get_irq_setting + $rt5683_enable_irq_setting + $InboxHeadset_status)

echo "[ASUS][Inbox_audio_switch] Begin check inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , InboxHeadset_status = $InboxHeadset_status , value = $value" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch] Begin check inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , InboxHeadset_status = $InboxHeadset_status , value = $value

Inbox_audio_switch

inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)
rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)
InboxHeadset_status=$(cat /sys/bus/i2c/devices/2-001a/InboxHeadset_status)

value=$(expr $inbox_audio_switch + $rt5683_get_irq_setting + $rt5683_enable_irq_setting + $InboxHeadset_status)

echo "[ASUS][Inbox_audio_switch] After check inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , InboxHeadset_status = $InboxHeadset_status , value = $value" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch] After check inbox_audio_switch = $inbox_audio_switch , rt5683_get_irq_setting = $rt5683_get_irq_setting , rt5683_enable_irq_setting = $rt5683_enable_irq_setting , InboxHeadset_status = $InboxHeadset_status , value = $value


if test $value -eq 0
then

        sleep 3

        # Check USB Sound card if user insert headset
	if [ ! -f "/proc/asound/$inbox_card_id/state" ]; then
        	usb_inbox_state=$(ls /proc/asound/)
		echo "[ASUS][Inbox_audio_switch] /proc/asound/$inbox_card_id/state donot exist, try to check without headset status : $usb_inbox_state" > /dev/kmsg
		log -p d -t [ASUS][Inbox_audio_switch] /proc/asound/$inbox_card_id/state donot exist, try to check without headset status : $usb_inbox_state

                # Check USB Sound card if user not insert headset
	        if [ ! -f "/proc/asound/$inbox_card_id_without_headset/state" ]; then
                	usb_inbox_state=$(ls /proc/asound/)
		        echo "[ASUS][Inbox_audio_switch] /proc/asound/$inbox_card_id_without_headset/state donot exist : $usb_inbox_state" > /dev/kmsg
		        log -p d -t [ASUS][Inbox_audio_switch] /proc/asound/$inbox_card_id_without_headset/state donot exist : $usb_inbox_state

		        RESULT=0;
	        else
                        usb_inbox_state=`cat /proc/asound/$inbox_card_id_without_headset/state`

                        echo "[ASUS][Inbox_audio_switch] USB mode without headset, usb_inbox_state=$usb_inbox_state" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_switch] USB mode without headset, usb_inbox_state=$usb_inbox_state
                        
                        if [ "$usb_inbox_state" == "ONLINE" ]; then
                                RESULT=1;
                        else
                                RESULT=0;
                        fi
                fi

	else
                usb_inbox_state=`cat /proc/asound/$inbox_card_id/state`

                echo "[ASUS][Inbox_audio_switch] USB mode, usb_inbox_state=$usb_inbox_state" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_switch] USB mode, usb_inbox_state=$usb_inbox_state
                
                if [ "$usb_inbox_state" == "ONLINE" ]; then
                        RESULT=1;
                else
                        RESULT=0;
                fi
        fi
else
        RESULT=0;
fi

echo "[ASUS][Inbox_audio_switch_to_USB] RESULT = $RESULT" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_switch_to_USB] RESULT = $RESULT

if [[ $RESULT -eq 1 ]]
then
        setprop vendor.inbox.current_audio_mode 2
	echo "1";
else
        setprop vendor.inbox.current_audio_mode 0
	echo "0";
fi

exit $RESULT

