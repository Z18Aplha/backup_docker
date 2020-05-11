FROM alpine:latest

ENV CRON="0 5 * * *" \
    SRC="/src" \
    DEST="/backups" \
    BACKUP_ROTATION=5 \
    TZ="Europe/Berlin" 

RUN apk --no-cache add dcron tzdata

COPY backup.sh /scripts/backup.sh
COPY entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/backup.sh /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
