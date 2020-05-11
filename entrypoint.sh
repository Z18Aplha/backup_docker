#!/bin/sh

# Re-write cron shortcut
case "$(echo "$CRON" | tr '[:lower:]' '[:upper:]')" in
    *@YEARLY* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 1 *" && CRONS="0 0 1 1 *";;
    *@ANNUALLY* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 1 *" && CRONS="0 0 1 1 *";;
    *@MONTHLY* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 * *" && CRONS="0 0 1 * * ";;
    *@WEEKLY* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * 0" && CRONS="0 0 * * 0";;
    *@DAILY* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * *" && CRONS="0 0 * * *";;
    *@MIDNIGHT* ) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * *" && CRONS="0 0 * * *";;
    *@HOURLY* ) echo "INFO: Cron shortcut $CRON re-written to 0 * * * *" && CRONS="0 * * * *";;
    *@* ) echo "WARNING: Cron shortcut $CRON is not supported. Stopping." && exit 1;;
    * ) CRONS=$CRON;;
esac

# Set time zone if passed in
if [ ! -z "$TZ" ]
then
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

if [ -z "$CRONS" ]
  then
    echo "INFO: No CRON setting found. Running backup once."
    echo "INFO: Add CRON=\"0 0 * * *\" to perform backup every midnight"
    su "$USER" -c /scripts/backup.sh
  else
    # Setup cron schedule
    crontab -d
    echo "$CRONS su $USER -c /scripts/backup.sh >>/tmp/backup.log 2>&1" > /tmp/crontab.tmp
    crontab /tmp/crontab.tmp
    rm /tmp/crontab.tmp

    # Start cron
    echo "INFO: Starting crond ..."
    touch /tmp/backup.log
    touch /tmp/crond.log
    crond -b -l 0 -L /tmp/crond.log
    echo "INFO: crond started"
    tail -F /tmp/crond.log /tmp/backup.log
fi