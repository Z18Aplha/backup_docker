FROM apline:latest

ENV CRON="0 5 * * *" \
    SRC="/source" \
    DEST="/backup" \
    BACKUP_ROTATION=5 \
    TZ="Europe/Berlin" 

COPY backup.sh /scripts/backup.sh
COPY entrypoint.sh /scripts/entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]