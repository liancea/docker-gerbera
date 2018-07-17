FROM ubuntu:bionic

COPY ./start-gerbera.sh /usr/local/bin/start-gerbera.sh

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y gerbera && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	chmod 0755 /usr/local/bin/start-gerbera.sh && \
	chown -R gerbera:gerbera /etc/gerbera && \
	rm -v /etc/gerbera/config.xml

COPY ./config.xml /var/lib/gerbera/config-dist.xml

VOLUME [ "/etc/gerbera" ]

USER gerbera
ENTRYPOINT [ "/usr/local/bin/start-gerbera.sh" ]
