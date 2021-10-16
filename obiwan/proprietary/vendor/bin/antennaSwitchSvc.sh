#!/system/bin/sh

LOG_TAG="antennaSwitchSvc"

APM_PROPERTY="persist.vendor.radio.airplane_mode_on"
mState=`getprop $APM_PROPERTY`

if [ ! -z "$mState" ] ; then
    if [ "$mState" == "1" ]; then
        log -t $LOG_TAG "disable regulator"
        echo '0' > /sys/devices/platform/soc/soc:qcom,ipa_fws/antennaSwitch
    else
        log -t $LOG_TAG "enable regulator"
        echo '1' > /sys/devices/platform/soc/soc:qcom,ipa_fws/antennaSwitch
    fi
fi

