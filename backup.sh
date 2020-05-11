#!/bin/sh

set -e

echo "INFO: Starting backup.sh pid $$ $(date)"

# Delete logs by user request
if [ ! -z "${ROTATE_LOG##*[!0-9]*}" ]
then
  echo "INFO: Removing logs older than $ROTATE_LOG day(s)..."
  touch /logs/tmp.txt && find /logs/*.txt -mtime +$ROTATE_LOG -type f -delete && rm -f /logs/tmp.txt
fi

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous $RCLONE_CMD is still running. Skipping new $RCLONE_CMD command."
else
  echo $$ > /tmp/backup.pid
  # create archive
  d=$(date +%Y_%m_%d-%H_%M_%S)
  f="backup_$d.tar"
  tar -cvf $DEST/$f $SRC/
  echo "$f created"

  del=`ls -t $DEST | grep backup_ | awk "NR>$BACKUP_ROTATION"`
  echo "delet old backups: $del"
  rm $del

  echo "backup done"
  rm -f /tmp/sync.pid









fi