#!/system/bin/sh

if [ $# -eq 1 ]; then
    inst_id=$1
else
    log -pe -tMMGR_SCRIPT Usage: only one parameter should be given which corresponds to mmgr instance ID.
    exit 3
fi


if [ ! -d /config/telephony/${inst_id} ]; then
    case $inst_id in
    1)
        rm -f /config/telephony/*.fls
        mkdir /config/telephony/${inst_id}
        chmod 770 /config/telephony/${inst_id}
        chown system.radio /config/telephony/${inst_id}
        mv /config/telephony/*.nvm /config/telephony/${inst_id}
        mv /config/telephony/*.bkup /config/telephony/${inst_id}
        ;;
    2)
        if [ -d /config/telephony/mmgr2 ]; then
            rm -f /config/telephony/mmgr2/*.fls
            mv /config/telephony/mmgr2 /config/telephony/${inst_id}
        fi
        if [ -d /factory/telephony/mmgr2 ]; then
            mv /factory/telephony/mmgr2 /factory/telephony/${inst_id}
        fi
        ;;
    *)
        log -pe -tMMGR_SCRIPT This is not a valid instance ID.
        exit 3
        ;;
    esac
fi
