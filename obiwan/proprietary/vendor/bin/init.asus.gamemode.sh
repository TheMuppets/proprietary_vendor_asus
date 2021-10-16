#!/vendor/bin/sh
game_mode_type=`getprop vendor.asus.gamingtype`
echo "game_mode_type : $game_mode_type" > /dev/kmsg

echo $game_mode_type > sys/devices/platform/goodix_ts.0/game_mode

if [ $game_mode_type == "1" ]; then

  sku=`getprop ro.build.asus.sku`
  echo "game mode SKU : $sku" > /dev/kmsg
  if [ $sku == "CN" ]; then
    sleep 0.5
    echo "set CN game_mode" > /dev/kmsg
    echo "100.060.025.020.010.010.002" >/sys/devices/platform/goodix_ts.0/game_settings 
  fi  
fi




