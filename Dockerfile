FROM alpine:latest

ENV CRON="0 5 * * *" \
    SRC="source" \
    DEST="backup" \
    BACKUP_ROTATION=5 \
    TZ="Europe/Berlin" 

COPY backup.sh /scripts/backup.sh
COPY entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/backup.sh /scripts/entrypoint.sh

WORKDIR /backup

ENTRYPOINT ["/scripts/entrypoint.sh"]
