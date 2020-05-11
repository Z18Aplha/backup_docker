# backup_docker
A tool to create a backup of a folder to an `*.tar.gz` archive with backup rotation.

## Build image
Build the image with
```
docker build -t backup:latest .
```

## Prepare mount
The container need two mounting points:
- the source (the folder with content to backup)
- the destination (the folder with the backups)
The user inside the container is _root_ so it will work with containers using their own user id.

## Run container
Run the container with
```
docker run --name backup_<instance> -v <source>:/src -v <destination>:/backups [-e <key>=<value>] backup:latest
```
There are several environment variables to take more control.
key | default | description
--- | --- | ---
CRON | "0 5 * * *" | time of backup (cron format)
SRC | "0 5 * * *" | time of backup (cron format)
DEST | "0 5 * * *" | time of backup (cron format)
BACKUP_ROTATIONS | "0 5 * * *" | time of backup (cron format)
TZ | "0 5 * * *" | time of backup (cron format)


SRC="/src" \
    DEST="/backups" \
    BACKUP_ROTATION=5 \
    TZ="Europe/Berlin" 

**Example** for usage with grafana:
```
docker run --name backup_grafana -v /home/pi/docker/grafana:/src -v /home/pi/docker/backup_grafana:/backups -e CRON="30 4 * * *" backup:latest
```