#! /bin/bash

# test-latest-plugin.sh
# Contains single function that transfers latest plugin provided as command 
# argument. The function is executed by the jenkins user.  If file plugin exists
# it moves it into $HADOOP_HOME/common/lib and runs a wordcount test.  Else, the
# program exits.

LATEST=$1
HADOOP_HOME=/etc/opt/hadoop

### Word Count Variables - these are used to handle the naming of word count output directories to avoid name collisions.
DATE=`date +%d%b%y`
TIME=`date +%H%M`
OUTFILE="out_dir-$DATE-$TIME"

# Test $LATEST is a file
if [[ ! -e $LATEST ]] ; then
	echo "File does not exist, exiting."
	exit 1;
fi
	
# Remove the old plugin.		
OLD_JAR=$(find $HADOOP_HOME/share/hadoop/common/lib/ -name glusterfs-hadoop*.jar)
if [[ -e $OLD_JAR ]]
  then
      echo "[INFO] Removing old pluggin"
      mv $OLD_JAR /tmp/
fi
	
# Copy the latest plugin into $HADOOP_HOME/common/lib/
echo "[INFO] Copying $LATEST"
cp $LATEST $HADOOP_HOME/share/hadoop/common/lib/	
	
# Execute pi
su jenkins -c "$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 1 1"

# Execute wordcount on dante: /mnt/glusterfs/user/jenkins/dante
##	echo "[INFO] Exectuting Wordcount"
##	cd $HADOOP_HOME
## 	su jenkins -c "$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount dante $OUTFILE"
