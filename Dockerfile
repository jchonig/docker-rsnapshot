FROM lsiobase/ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

ENV \
	TZ=UTC \
	PUID= \
        PGID=

# Set up
RUN \
	echo "**** install packages ****" && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		cron \
		logrotate \
		openssh-client \
		rsnapshot && \
	echo "**** clean up ****" && \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# Add configuration files
COPY root /

VOLUME ["/config", "/backup"]

