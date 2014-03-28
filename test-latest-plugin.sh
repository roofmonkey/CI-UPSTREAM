#! /bin/bash

# test-latest-plugin.sh
# Contains single function that transfers latest plugin provided as command 
# argument. The function is executed by the jenkins user.  If file plugin exists
# it moves it into $HADOOP_HOME/common/lib and runs a wordcount test.  Else, the
# program exits.

LATEST=$1
DATE=`date +%d%b%y`
TIME=`date +%H%M`
OUTFILE="out_dir-$DATE-$TIME"
HADOOP_HOME=/etc/opt/hadoop

echo "[DEBUG] `whoami`"
if [[ -e $LATEST ]]; then
	
	# Preserv the old copy of the plugin .jar.		
	echo "Omitting old pluggin"
	mv $HADOOP_HOME/share/hadoop/common/lib/glusterfs-hadoop*.jar \
	   $HADOOP_HOME/share/hadoop/common/lib/glusterfs-hadoop-plugin.jar.OLD
	
        # Copy the latest .jar plugin into $HADOOP_HOME/common/lib
	echo "[INFO] Copying $LATEST"
	cp $LATEST $HADOOP_HOME/share/hadoop/common/lib/	
		
 	 # Execute wordcount on dante: /mnt/glusterfs/user/jenkins/dante
	echo "[INFO] Exectuting Wordcount"
	cd $HADOOP_HOME
	su jenkins -c "$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount dante $OUTFILE"
	
	else
	    echo "$LATEST : No such file."
	    exit 1
fi
