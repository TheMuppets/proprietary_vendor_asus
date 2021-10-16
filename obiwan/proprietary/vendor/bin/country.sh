#!/vendor/bin/sh
#country.sh

## Use COUNTRY to set default_network
LOG_TAG="COUNTRY"

if test -f /vendor/factory/COUNTRY; then
   COUNTRYCODE=`cat /vendor/factory/COUNTRY | tr '[a-z]' '[A-Z]'`
   ##COUNTRYCODE=`getprop ro.vendor.config.versatility`
fi

case "$COUNTRYCODE" in
#CN/TW/EU/HK/JP/AU/US enable 5G, 5G default on (2G/3G/4G/5G)
    "CN" | "TW" | "EU" | "HK" | "JP" | "AU" | "US" | "TH")
        setprop vendor.telephony.default_network 33,33
        setprop ro.vendor.asus.network.types 11
        ;;
#ID disable 5G (2G/3G/4G)
    "ID")
        setprop vendor.telephony.default_network 22,22
        setprop ro.vendor.asus.network.types 9
        ;;
#Others, WW/BR/RU enable 5G, 5G default off (2G/3G/4G)
    *)
        setprop vendor.telephony.default_network 22,22
        setprop ro.vendor.asus.network.types 11
        ;;
esac

