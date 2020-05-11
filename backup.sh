#!/bin/sh

set -e

echo "INFO: Starting backup.sh pid $$ $(date)"

# cd to the destination folder
# tar creates archive right 'here'
# list of files to delete are without absolute path --> rm would fail
cd $DEST

# check whether last backup routine was closed correctly
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
  # change owner to 1000 (pi in most cases) to grant access to other containers not root
  chown -R 1000 $f

  # get all files but the recent 5
  del=`ls -t $DEST | grep backup_ | awk "NR>$BACKUP_ROTATION"`
  echo "$del"
  # delete them
  if [ -z "$del" ]
  then
    echo "no old files to delete"
  else
    echo "delet old backups: $del"
    rm $del
  fi

  echo "backup done"
  rm -f /tmp/sync.pid









fi
