From lsiobase/alpine:3.16

ARG DEBIAN_FRONTEND=noninteractive

ENV \
	TZ=UTC \
	PUID= \
        PGID=

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

