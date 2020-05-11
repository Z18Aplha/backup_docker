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
SRC | "/src" | source location with files to backup
DEST | "/backups" | destination location for backup files
BACKUP_ROTATIONS | 5 | number of backup files to keep
TZ | "Europe/Berlin" | [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to use for the cron


**Example** for usage with grafana:
```
docker run --name backup_grafana -v /home/pi/docker/grafana:/src -v /home/pi/docker/backup_grafana:/backups -e CRON="30 4 * * *" backup:latest
```

## Backup container
Grafana has no integrated backup solution. But it is possible to just copy the mount and use it as a backup. To automate this process there is an other [repository](https://github.com/Z18Aplha/backup_docker) which is made therefor.

Combine it with the [rclone](https://rclone.org/) to get the ultimate backup solution. This [repository](https://github.com/Z18Aplha/rclone_docker) is made for an rclone container on arm machines (i.e. RaspberryPi).