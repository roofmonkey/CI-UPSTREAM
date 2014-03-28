#! /bin/bash

## s3-get-latest.sh

DATE=`date +%d%b%y`
TIME=`date +%H%M`
REPO_HOME=/home/fedora
echo "[INFO] Backing up S3 Maven Repositories"
#mv $REPO_HOME/repositories $REPO_HOME/repositories.defunct
s3cmd get -r s3://rhbd/maven/repositories $REPO_HOME/s3-backup/ && \
mv $REPO_HOME/s3-backup/repositories $REPO_HOME/s3-backup/repositories-$DATE.$TIME
echo "[INFO] S3 Repository Backup Complete"
