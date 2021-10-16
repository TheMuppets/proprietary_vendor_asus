ReceiverOn=`getprop vendor.asus.sar.audio`
Wifion=`getprop wlan.driver.status`
Country=`getprop vendor.asus.operator.iso-country`
SKU=`getprop ro.boot.id.prj`
#CustomerID=`getprop ro.config.CID`
#Wigigon=`getprop vendor.wigig.driver.status`
Softapon=`getprop vendor.wlan.softap.driver.status`
WlanDbs=`getprop vendor.wlan.dbs`
Slm=`getprop vendor.asus.sar.sla`
Camera=`getprop vendor.asus.sar.camera`
sim1_b42b48=`getprop vendor.asus.sar.sim1.b42b48`
sim2_b42b48=`getprop vendor.asus.sar.sim2.b42b48`

log -t WifiSARPower enter ReceiverOn=$ReceiverOn WlanDbs=$WlanDbs Wifion=$Wifion Softapon=$Softapon Country=$Country Slm=$Slm Camera=$Camera SKU=$SKU sim1_b42b48=$sim1_b42b48 sim2_b42b48=$sim2_b42b48

if [ "$Softapon" == "ok" ]; then
    echo 1 > /proc/driver/UTSstatus
else
    echo 0 > /proc/driver/UTSstatus
fi

if [ "$SKU" == "0" ]; then
    if [ "$Wifion" == "ok" ] || [ "$WlanDbs" == "1" ]; then
            case "$Country" in
                *"IT"* | *"FR"* | *"DE"* | *"UK"* | *"BE"* | *"NL"* | *"ES"* | *"DK"* | *"FI"* | *"NO"* | *"SE"* | *"PT"* |*"PL"* | *"RO"* | *"CZ"* | *"SK"* | *"HU"* )
                    if [ "$WlanDbs" == "1" ]; then
                        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD

                        log -t WifiSARPower CE dbs on
                    else
                        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD

                        log -t WifiSARPower CE normal
                    fi
                ;;
                *)
                    if [ "$WlanDbs" == "1" ]; then
                        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

                        log -t WifiSARPower dbs on
                    else
                        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

                        log -t WifiSARPower normal
                    fi
                ;;
            esac
    fi
elif [ "$Country" == "FR" ]; then
    if [ "$Wifion" == "ok" ] || [ "$WlanDbs" == "1" ] || [ "$Softapon" == "ok" ]; then
        if [ "$Softapon" == "ok" -o "$Slm" == "1" ] && [ "$Camera" == "1" ]; then
            if [ "$sim1_b42b48" == "true"] || [ "$sim2_b42b48" == "true" ]; then
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 11 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 11 --END_ATTR --END_ATTR --END_CMD

                log -t WifiSARPower FR Hotspot or SLM + camera + b42b48
            else
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 2 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 2 --END_ATTR --END_ATTR --END_CMD

                log -t WifiSARPower FR Hotspot or SLM + camera
            fi
        elif [ "$Softapon" == "ok" ] || [ "$Slm" == "1" ]; then
            if [ "$sim1_b42b48" == "true"] || [ "$sim2_b42b48" == "true" ]; then
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 10 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 10 --END_ATTR --END_ATTR --END_CMD

                log -t WifiSARPower FR Hotspot or SLM + b42b48
            else
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD

                log -t WifiSARPower FR Hotspot or SLM
            fi
        else
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

            log -t WifiSARPower FR
        fi
    fi
elif [ "$Country" == "US" ]; then
    if [ "$Wifion" == "ok" ] || [ "$WlanDbs" == "1" ] || [ "$Softapon" == "ok" ]; then
        if [ "$ReceiverOn" == "1" ] || [ "$Camera" == "2" ]; then
            if [ "$Softapon" == "ok" ] || [ "$Slm" == "1" ]; then
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 7 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 7 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Calling/Portrait + Hotspot or SLM
            else
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 5 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 5 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Calling/Portrait
            fi
        elif [ "$Camera" == "1" ]; then
            if [ "$Softapon" == "ok" ] || [ "$Slm" == "1" ]; then
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 6 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 6 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Camera + Hotspot or SLM
            else
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 4 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 4 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Camera
            fi
        elif [ "$Camera" == "3" ] || [ "$Camera" == "4" ]; then
            if [ "$Softapon" == "ok" ] || [ "$Slm" == "1" ]; then
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 9 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 9 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Landscape/Gaming + Hotspot or SLM
            else
                vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 8 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 8 --END_ATTR --END_ATTR --END_CMD
                log -t WifiSARPower US Landscape/Gaming
            fi
        else
            log -t WifiSARPower US
        fi
    fi
else
    case "$Country" in
        *"IT"* | *"DE"* | *"UK"* | *"BE"* | *"NL"* | *"ES"* | *"DK"* | *"FI"* | *"NO"* | *"SE"* | *"PT"* |*"PL"* | *"RO"* | *"CZ"* | *"SK"* | *"HU"* )
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 3 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 3 --END_ATTR --END_ATTR --END_CMD

            log -t WifiSARPower CE normal
    ;;
    esac
fi
