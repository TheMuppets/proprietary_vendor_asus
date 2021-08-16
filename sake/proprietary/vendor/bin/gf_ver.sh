#!/system/bin/sh
GF_VER_PACK=`getprop vendor.goodix.version.pack`

setprop vendor.fp.version.driver "$GF_VER_PACK"
