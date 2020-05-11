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
  # echo "PWD: $PWD"
  d=$(date +%Y_%m_%d-%H_%M_%S)
  f="backup_$d.tar.gz"
  tar -cvzf $f -C $SRC/ .
  echo "$f created"
  chown -R 1000 $f
  mv $f $DEST

  del=`ls -t $DEST | grep backup_ | awk "NR>$BACKUP_ROTATION"`
  echo $del
  if ["$del" != ""]
  then
    echo "delet old backups: $del"
    rm $del
  else
    echo "no old files to delete"
  fi

  echo "backup done"
  rm -f /tmp/sync.pid









fi