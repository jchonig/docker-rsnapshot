From lsiobase/alpine:3.22

ENV \
	TZ=UTC \
	PUID= \
        PGID= \
        DOCKER_MODS=linuxserver/mods:universal-cron

# Set up
RUN \
    echo "*** Install required packages ****" && \
    apk add --no-cache \
        inotify-tools \
        logrotate \
        openssh-client \
        rsnapshot

# Add configuration files
COPY root /

VOLUME ["/config", "/backup"]

