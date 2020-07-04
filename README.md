# docker-monit
A container running [rsnapshot](https://rsnapshot.org/) for the
purpose backing up remote filesystems via ssh

# Usage

## docker

```
docker create \
  --name=monit \
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
  monit:
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

| Volume  | Function                         |
| ------  | --------                         |
| /config | All the config files reside here |
| /backup | Root of backup dirs |

# Application Setup

  * Environment variables can also be passed in a file named `env` in
    the `config` directory. This file is sourced by the shell.
  * Configure rsnapshot as follows
    * Store config file(s) in config/rsnapshot/NAME.conf
	* Set the logfile to config/log/rsnapshot.log
  * Add ssh keys and configuration to config/.ssh dir

## TODO

  * [ ] Document configuration



