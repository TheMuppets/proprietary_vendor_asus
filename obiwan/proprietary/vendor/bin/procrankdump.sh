#!/system/bin/sh

counter=0

echo "Start parsing procrank"
LOG_FOLDER='/sdcard/memleak_test'

rm -rf $LOG_FOLDER
mkdir $LOG_FOLDER

while :
do
	counter=$(($counter+1))

	current_time=$(date +%Y_%m_%d_%H_%M_%S)
	#echo "$current_time procrank -p > $LOG_FOLDER/procrank_$counter.txt" >> $LOG_FOLDER/logs.txt
	#procrank -p > $LOG_FOLDER/procrank_$counter.txt
	procrank -p > $LOG_FOLDER/${current_time}_procrank.txt
		
	sleep 10
done


