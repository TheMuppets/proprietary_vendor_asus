#!/vendor/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

# No path is set up at this point so we have to do it here.
export PATH=/vendor/bin

THERMAL_LINK=`getprop vendor.thermal.create.thermal_link`
if [ "$THERMAL_LINK" == "1" ]; then
	#ASUS_BSP +++ Show_Cai create symbolic link to vadc                                                                                                    
	SOC_PATH="/sys/devices/platform/soc/"
	SEARCH_PM_XO_THERM="in_temp_xo_therm_input"
	SEARCH_SKIN_THERM="in_temp_skin_therm_input"
	SEARCH_PA_THERM="in_temp_pa_therm1_input"

	SEARCH_SIDE_CON_TEMP_ALT="in_temp_conn_therm_input"
	SEARCH_WP_THERM="in_temp_wp_therm_input"
	SEARCH_SMB_THERM="in_temp_smb1390_therm_input"
	#SEARCH_BATT_THERM=""

	SEARCH_BTM_CON_TEMP_ALT_ADC="in_temp_BTM_CON_TEMP_ALT_ADC_input"
	SEARCH_SKIN_MSM_THERM="in_temp_skin_msm_therm_input"
	SEARCH_PA_THERM2="in_temp_pa_therm2_input"
	SEARCH_BATT_THERM="in_temp_batt_therm_input"

	therm_check(){
		THERM_FILE=`find $SOC_PATH -name $1`
		if [ -f "$THERM_FILE" ]; then
			ln -s $THERM_FILE $2
			echo "[Thermal] link '$1' to '$2'"
		else
			echo "[Thermal] '$1' not found!!"
		fi
	}
	mkdir -p "/dev/therm/"                                                     
	chmod 755 "/dev/therm/"                                                   
	mkdir -p "/dev/therm/vadc"                                                
	chmod 755 "/dev/therm/vadc"
	therm_check $SEARCH_PM_XO_THERM "/dev/therm/vadc/xo_therm"
	therm_check $SEARCH_PA_THERM "/dev/therm/vadc/pa_therm1"
	therm_check $SEARCH_PA_THERM2 "/dev/therm/vadc/pa_therm2"
	therm_check $SEARCH_SKIN_THERM "/dev/therm/vadc/skin_therm"
	therm_check $SEARCH_SKIN_MSM_THERM "/dev/therm/vadc/skin_msm_therm"
	therm_check $SEARCH_BTM_CON_TEMP_ALT_ADC "/dev/therm/vadc/btm_con_temp_alt_adc"
	therm_check $SEARCH_SMB_THERM "/dev/therm/vadc/smb1390_therm"
	therm_check $SEARCH_SIDE_CON_TEMP_ALT "/dev/therm/vadc/side_con_temp_alt"
	therm_check $SEARCH_WP_THERM "/dev/therm/vadc/wp_therm"
	therm_check $SEARCH_BATT_THERM "/dev/therm/vadc/batt_therm"
	#ln -s /sys/class/thermal/thermal_zone6/mtemp /dev/therm/vadc/msm_therm
	#ln -s /dev/therm/vadc/PMI8998_quiet_therm "/dev/therm/vadc/PMI8998_quiet_therm"
	#ln -s /sys/class/power_supply/parallel/charger_mtemp /dev/therm/vadc/smb1381_temp 
	#ASUS_BSP --- Show_Cai create symbolic link to vadc  

	#ASUS_BSP +++ Show_Cai create symbolic link for run-in test
	ln -s /vendor/bin/thermalAtdTool /data/data/Thermal
	sleep 10
	#ASUS_BSP --- Show_Cai creat symbolic link for run-in test
	setprop debug.create.thermal_link 0
	#setprop persist.create.thermal_link 0
	#setprop vendor.create.thermal_link 0
	#setprop sys.create.thermal_link 0

	stop thermal-engine
	start thermal-engine
	setprop vendor.thermal.create.thermal_link 0

	#ASUS_BSP +++ Clay copy factory file
        file_check(){
            if [ -f /vendor/factory/$1 ]; then
		echo "$1 file is exist"
            else
		echo "copy $1 file"
		cp /vendor/etc/grip_cal/$1 /vendor/factory/
		chown shell:shell /vendor/factory/$1
		chmod 777 /vendor/factory/$1
            fi
        }

	cp /vendor/etc/grip_cal/snt_configs.txt /vendor/factory/
	cp /vendor/etc/grip_cal/refwv /vendor/factory/
	cp /vendor/etc/grip_cal/snt_tchwv_configs.txt /vendor/factory/
	cp /vendor/etc/grip_cal/snt_deco_configs.txt /vendor/factory/
	cp /vendor/etc/grip_cal/snt_wfmcfg /vendor/factory/
	chown shell:shell /vendor/factory/refwv
        chmod 777 /vendor/factory/refwv
	#WV_check_result="/vendor/factory/grip_frame_check_result.txt"
	#if [ -f $WV_check_result ]; then
	#    echo "file is exist"
	#else
	#    cp /vendor/etc/grip_cal/grip_frame_check_result.txt /vendor/factory/
	#    chown shell:shell /vendor/factory/grip_frame_check_result.txt
	#    chmod 777 /vendor/factory/grip_frame_check_result.txt
	#fi
	file_check grip_frame_check_result.txt
	file_check grip_bar0_test_result.txt
	file_check grip_bar1_test_result.txt
	file_check grip_bar2_test_result.txt
fi

GET_FREQ=`getprop debug.lmh`
if [ "$GET_FREQ" == "1" ]; then
    lmh1=`cat /sys/bus/platform/devices/18321000.qcom,cpucc:qcom,limits-dcvs@18350800/lmh_freq_limit`
    lmh0=`cat /sys/bus/platform/devices/18321000.qcom,cpucc:qcom,limits-dcvs@18358800/lmh_freq_limit`
    setprop vendor.thermal.lmh_freq0 $lmh0
    setprop vendor.thermal.lmh_freq1 $lmh1
fi
