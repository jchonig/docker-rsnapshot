# docker-rsnapshot
A container running [rsnapshot](https://rsnapshot.org/) for the
purpose backing up remote filesystems via ssh

Image hosted at: `ghcr.io/jchonig/rsnapshot`

# Usage

## docker

```
docker create \
  --name=rsnapshot \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v </path/to/appdata/config>:/config \
  -v </path/to/backup_root>:/backup \
  --restart unless-stopped \
  ghcr.io/jchonig/rsnapshot
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  rsnapshot:
    image: ghcr.io/jchonig/rsnapshot
    container_name: rsnapshot
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - </path/to/appdata/config>:/config
	  - </path/to/backup_root>:/backup
    restart: unless-stopped
```

# Parameters

## Environment Variables (-e)

| Env        | Function                                |
| ---        | --------                                |
| PUID=1000  | for UserID - see below for explanation  |
| PGID=1000  | for GroupID - see below for explanation |
| TZ=UTC     | Specify a timezone to use EG UTC        |

## Volume Mappings (-v)

| Volume  | Function                          |
|---------|-----------------------------------|
| /config | All the config files reside here  |
| /backup | Root of backup dirs               |
| /data/* | Local filesystems to be backed up |

# Application Setup

  * Environment variables can also be passed in a file named `env` in
    the `config` directory. This file is sourced by the shell.
  * Configure rsnapshot as follows
    * Store config file(s) in config/rsnapshot/NAME.conf
      * Set the logfile to config/log/rsnapshot.log
	  * Set the backup path to /backup/${NAME}
	  * If backing up local F?S, mount them under /data/*
	  * Logs under `/config/log` are rotated automatically by the
        `svc-logrotate` service (daily check, per
        `/etc/logrotate.d/rsnapshot`); state is kept in
        `/config/log/.logrotate.status`.
	* Add the schedule to the root crontab in `/config/crontabs/root`
	  * Cron is provided by the `linuxserver/mods:universal-cron`
        Docker mod, which reads `/config/crontabs/root` (run as root)
        and `/config/crontabs/abc` (run as the PUID/PGID user).
	  * These are plain user crontabs - do **not** include a user
        field in the entries.
	  * The mod only imports the crontabs when the container starts.
        This image adds a `svc-crontab-watch` service that watches
        `/config/crontabs` and re-imports on change, so edits to
        `/config/crontabs/root` take effect on a running container
        without a restart.
  * Add ssh keys and configuration to config/.ssh dir

## Crontab example

`/config/crontabs/root`:

```
57 17 * * * rsnapshot -c /config/rsnapshot/HOSTNAME.conf hourly
36 1 * * 0-5 rsnapshot -c /config/rsnapshot/HOSTNAME.conf daily
36 1 * * 6 rsnapshot -c /config/rsnapshot/HOSTNAME.conf weekly && rsnapshot -c /config/rsnapshot/HOSTNAME.conf daily
36 0 1 * * rsnapshot -c /config/rsnapshot/HOSTNAME.conf monthly
```

## ssh config example

```
Host *
    PasswordAuthentication no
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host HOSTNAME
  IdentityFile ~/.ssh/KEYNAME
```
