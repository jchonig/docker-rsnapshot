# docker-rsnapshot
A container running [rsnapshot](https://rsnapshot.org/) for the
purpose backing up remote filesystems via ssh

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
  jchonig/rsnapshot
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  rsnapshot:
    image: jchonig/rsnapshot
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
	* Add a crontab configuration in /config/cron.d/rsnapshot-${NAME}
	  * Note that the root user should not be specified in the
        crontab, it will be removed if present
  * Add ssh keys and configuration to config/.ssh dir
  
## Crontab example

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
