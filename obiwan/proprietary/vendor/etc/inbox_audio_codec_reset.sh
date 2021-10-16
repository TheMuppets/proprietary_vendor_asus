1#!/vendor/bin/sh

##########################################################################
##                                                                      ##
##  This is the tool for Asus ZS661KS Audio Inbox                       ##
##  switch Inbox operation node from USB mode to I2S mode               ##
##                                                                      ##
##########################################################################

function Inbox_audio_switch_to_I2S() {

                inbox_audio_switch=$(cat /sys/class/ec_hid/dongle/device/inbox_audio_switch)

                echo "[ASUS][Inbox_audio_reset_to_I2S] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Work on vendor mode, inbox_audio_switch=$inbox_audio_switch

                # Disable inbox 3.3V Vdd
                echo 0 > /sys/class/ec_hid/dongle/device/pogo_detect
                sleep 1
                echo "[ASUS][Inbox_audio_reset_to_I2S] Disable inbox 3.3V Vdd" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Disable inbox 3.3V Vdd


                # Select inbox working mode >  1 : I2S mode ; 0 : USB mode
                echo 1 > /sys/class/ec_hid/dongle/device/inbox_audio_switch

                echo "[ASUS][Inbox_audio_reset_to_I2S] Select inbox_audio_switch to I2S mode" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Select inbox_audio_switch to I2S mode

                # Set inbox select pin >  1 : I2S mode ; 0 : USB mode
                echo 1 > /sys/class/ec_hid/dongle/device/pogo_sleep
                sleep 1
                echo "[ASUS][Inbox_audio_reset_to_I2S] Set inbox select pin to high" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Set inbox select pin to high

                # Enable inbox 3.3V Vdd
                echo 1 > /sys/class/ec_hid/dongle/device/pogo_detect
                echo "[ASUS][Inbox_audio_reset_to_I2S] Enable inbox 3.3V Vdd" > /dev/kmsg
                log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Enable inbox 3.3V Vdd

                # Setting inbox I2S mode irq setting
                rt5683_get_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting)
                if test $rt5683_get_irq_setting -eq 1
                then
                        echo "[ASUS][Inbox_audio_reset_to_I2S] rt5683_get_irq_setting $rt5683_get_irq_setting already setted" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_reset_to_I2S] rt5683_get_irq_setting $rt5683_get_irq_setting already setted
                else
                        echo "[ASUS][Inbox_audio_reset_to_I2S] Set rt5683_get_irq_setting to 1" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Set rt5683_get_irq_setting to 1
                        # Release inbox I2S mode irq setting
                        echo 1 > /sys/bus/i2c/devices/2-001a/rt5683_get_irq_setting
                fi

                sleep 1

                rt5683_enable_irq_setting=$(cat /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting)
                if test $rt5683_enable_irq_setting -eq 1
                then
                        echo "[ASUS][Inbox_audio_reset_to_I2S] rt5683_enable_irq_setting $rt5683_enable_irq_setting already enabled " > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_reset_to_I2S] rt5683_enable_irq_setting $rt5683_enable_irq_setting already enabled
                else
                        echo "[ASUS][Inbox_audio_reset_to_I2S] Set rt5683_enable_irq_setting to 1" > /dev/kmsg
                        log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Set rt5683_enable_irq_setting to 1
                        # Enable inbox I2S mode irq setting
                        echo 1 > /sys/bus/i2c/devices/2-001a/rt5683_enable_irq_setting
                fi

        # Switch USB D+D- Back to Inbox side USB port
        echo "[ASUS][Inbox_audio_reset_to_I2S] Set force_usb_mux to 0" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_reset_to_I2S] Set force_usb_mux to 0
        echo 0 > /sys/class/power_supply/battery/device/force_usb_mux
}

current_audio_mode=`getprop vendor.inbox.current_audio_mode`

echo "[ASUS][Inbox_audio_reset] Get current_audio_mode=$current_audio_mode" > /dev/kmsg
log -p d -t [ASUS][Inbox_audio_reset] Get current_audio_mode=$current_audio_mode

if test $current_audio_mode -eq 2
then
        echo "[ASUS][Inbox_audio_reset] Get current_audio_mode is USB Mode, reset back to I2S and reset Property" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_reset] Get current_audio_mode is USB Mode, reset back to I2S and reset Property

        Inbox_audio_switch_to_I2S

        setprop vendor.inbox.audio_switch_mode 0

        setprop vendor.inbox.current_audio_mode 0
else
        echo "[ASUS][Inbox_audio_reset] Get current_audio_mode is I2S Mode, reset Property only" > /dev/kmsg
        log -p d -t [ASUS][Inbox_audio_reset] Get current_audio_mode is I2S Mode, reset Property only

        setprop vendor.inbox.audio_switch_mode 0

        setprop vendor.inbox.current_audio_mode 0
fi

























