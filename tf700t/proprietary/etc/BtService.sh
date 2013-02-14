#!/system/bin/sh

BT_Service="Bluetooth Service"
LOG_TAG="BtService"

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

error_exit ()
{
  echo $BT_Service: $1
  exit $2
}

warning ()
{
  echo $*
}

KILL="/system/bin/kill"
PPPD="/system/bin/pppd_btdun"
GREP="/system/bin/grep"

killPppd() {
        PPPDPID=$2
        $KILL $PPPDPID
}

dunService() {
    logi "Start dunService ${DUN_SERVICE} addr:${DUN_ADDR}"
    case ${DUN_SERVICE} in
    connect)
	/system/xbin/rfcomm release 0
	logi "rfcomm bind"
	/system/xbin/rfcomm bind 0 ${DUN_ADDR} ${DUN_CHAN}
	logi "pppd call"
	$PPPD call BluetoothDialup
    ;;

    disconnect)
	PPPDINFO=$(ps | $GREP $PPPD)
	killPppd $PPPDINFO
#	/system/xbin/rfcomm release 0
    ;;

    release)
	/system/xbin/rfcomm release 0
    ;;
    carrier)
        /system/xbin/rfcomm release 0
        logi "rfcomm bind"
        /system/xbin/rfcomm bind 0 ${DUN_ADDR} ${DUN_CHAN}
        logi "pppd call"
	$PPPD call BluetoothCarrier
    esac
}

logi "BTService run"
case $1 in
	dunService)
		logi "dunService"
		DUN_SERVICE=$2
		DUN_ADDR=$3
		DUN_CHAN=$4
		dunService
		;;
	*)
         error_exit "usage:BTService(restore:cleardev)" 0
esac
	 error_exit "$1: success" 0

