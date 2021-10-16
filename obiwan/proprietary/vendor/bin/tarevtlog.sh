#!/vendor/bin/sh

echo "tar evt log"
TAR_FOLDER='/data/logcat_log/evtlog'
ASUSEVTLOG='ASUSEvtlog.txt'
max_log=20

mkdir -p /data/logcat_log/evtlog
mkdir -p /data/logcat_log/evtlog.old
chown root root /data/logcat_log/evtlog
chown root root /data/logcat_log/evtlog.old
chmod 0775 /data/logcat_log/evtlog
chmod 0775 /data/logcat_log/evtlog.old

if [ -e /asdf/ASUSEvtlog_old1.txt ]; then
	if [ -e $TAR_FOLDER/$ASUSEVTLOG.1 ]; then
		cp $TAR_FOLDER/*.* $TAR_FOLDER.old
		i=$(($max_log))
		while [ $i -gt 0 ]; do
			if [ -e $TAR_FOLDER.old/$ASUSEVTLOG.$i ]; then
				cp $TAR_FOLDER/$ASUSEVTLOG.$i $TAR_FOLDER.old/$ASUSEVTLOG.$i
			fi
			i=$(($i-1))
		done
		i=$(($max_log-1))
		while [ $i -gt 0 ]; do
			if [ -e $TAR_FOLDER.old/$ASUSEVTLOG.$i ]; then
			echo "rotate $TAR_FOLDER.old/$ASUSEvtlog.$i to $TAR_FOLDER/$ASUSEvtlog.$(($i+1))"
				cp $TAR_FOLDER.old/$ASUSEVTLOG.$i $TAR_FOLDER/$ASUSEVTLOG.$(($i+1))
			fi
			i=$(($i-1))
		done
		rm -rf $TAR_FOLDER.old/*.*

	fi
	mv /asdf/ASUSEvtlog_old1.txt $TAR_FOLDER/$ASUSEVTLOG.1
	tar -czf /asdf/ASUSEvtlog.tar.gz . -C $TAR_FOLDER
fi
persist.vendor.asus.tarevtlog 0
