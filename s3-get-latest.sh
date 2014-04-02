#! /bin/bash

## s3-get-latest.sh

DATE=`date +%d%b%y`
TIME=`date +%H%M`
REPO_HOME=/home/fedora

echo "[INFO] Backing up S3 Maven Repositories"

#  Initiate s3 download
s3cmd get -r s3://rhbd/maven/repositories $REPO_HOME/s3-backup/

#  Append date-time stamp to repo /dir
mv $REPO_HOME/s3-backup/repositories/ \
   $REPO_HOME/s3-backup/repositories-$DATE.$TIME/ && \
echo "[INFO] Appended DATE-TIME stamp to repo /dir";

