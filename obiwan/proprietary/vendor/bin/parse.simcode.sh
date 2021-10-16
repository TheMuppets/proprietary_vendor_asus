#!/vendor/bin/sh
#parse_simcode.sh


## Sync SIM CODE with modem
LOG_TAG="simcode"

if test -f /vendor/factory/SIMCODE; then
   SIMCODE=`cat /vendor/factory/SIMCODE`
    if [[ "$SIMCODE" == "s1" || "$SIMCODE" == "S1" ]] ; then
        setprop persist.vendor.radio.multisim.config none
    elif [[ "$SIMCODE" == "s2" || "$SIMCODE" == "S2" ]] ; then
        setprop persist.vendor.radio.multisim.config dsds
    fi
fi
