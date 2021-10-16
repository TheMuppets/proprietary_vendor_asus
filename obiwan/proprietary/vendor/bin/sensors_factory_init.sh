#!/vendor/bin/sh

PROXM_SPEC_FILE="/data/data/proximity_spec"
LIGHT_SPEC_FILE="/data/data/lightsensor_spec"

PROXM_INF_FILE="/vendor/factory/psensor_inf.nv"
PROXM_HI_FILE="/vendor/factory/psensor_hi.nv"
PROXM_LOW_FILE="/vendor/factory/psensor_low.nv"
PROXM_1CM_FILE="/vendor/factory/psensor_1cm.nv"
PROXM_2CM_FILE="/vendor/factory/psensor_2cm.nv"
PROXM_3CM_FILE="/vendor/factory/psensor_3cm.nv"
PROXM_4CM_FILE="/vendor/factory/psensor_4cm.nv"
PROXM_5CM_FILE="/vendor/factory/psensor_5cm.nv"
LIGHT_FILE="/vendor/factory/lsensor.nv"
LIGHT_100_FILE="/vendor/factory/lsensor_100ms.nv"
LIGHT_50_FILE="/vendor/factory/lsensor_50ms.nv"
GSENSOR_X_FILE="/vendor/factory/gsensor_x.nv"
GSENSOR_Y_FILE="/vendor/factory/gsensor_y.nv"
GSENSOR_Z_FILE="/vendor/factory/gsensor_z.nv"

sensor_chmod()
{
	if [ -f $1 ];
	then
		echo "File $FILE exists"
		chmod 660 $1
		chown system:shell $1
	else
		echo "File $FILE does not exists"
		echo 0 > $1
		chmod 660 $1
		chown system:shell $1
	fi
}

sensor_chmod $PROXM_SPEC_FILE
sensor_chmod $LIGHT_SPEC_FILE

sensor_chmod $PROXM_INF_FILE
sensor_chmod $PROXM_HI_FILE
sensor_chmod $PROXM_LOW_FILE
sensor_chmod $PROXM_1CM_FILE
sensor_chmod $PROXM_2CM_FILE
sensor_chmod $PROXM_3CM_FILE
sensor_chmod $PROXM_4CM_FILE
sensor_chmod $PROXM_5CM_FILE
sensor_chmod $LIGHT_FILE
sensor_chmod $LIGHT_100_FILE
sensor_chmod $LIGHT_50_FILE

sensor_chmod $GSENSOR_X_FILE
sensor_chmod $GSENSOR_Y_FILE
sensor_chmod $GSENSOR_Z_FILE

exit 0
