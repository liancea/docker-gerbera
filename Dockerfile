FROM ubuntu:bionic as builder

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y install libavutil-dev libavcodec-dev libavformat-dev libavdevice-dev \
		libavfilter-dev libavresample-dev libswscale-dev libswresample-dev libpostproc-dev \
		libupnp1.8-dev libtag1-dev libuuid1 autoconf git build-essential cmake && \
	mkdir /workspace && \
	cd /workspace && \
	git clone https://github.com/gerbera/gerbera.git && \
	mkdir build && \
	cd build && \
	cmake ../gerbera && \
	make -DWITH_MAGIC=1 -DWITH_MYSQL=1 -DWITH_CURL=1 -DWITH_JS=1 -DWITH_TAGLIB=1 \
		-DWITH_AVCODEC=1 -DWITH_FFMPEGTHUMBNAILER=1 -DWITH_EXIF=1 -DWITH_LASTFM=1

# actual container
FROM ubuntu:bionic

COPY ./start-gerbera.sh /usr/local/bin/start-gerbera.sh
COPY ./config.xml /var/lib/gerbera/config-dist.xml
COPY --from=builder /workspace/gerbera/build /import

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y install libavutil55 libavcodec-extra libavformat57 libavdevice57 libavfilter-extra6 \
		libavresample3 libswscale4 libswresample2 libpostproc54 libupnp10 libtag1v5 make && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	chmod 0755 /usr/local/bin/start-gerbera.sh && \
	chown -R gerbera:gerbera /etc/gerbera && \
	(cd /import && make install) && \
	rm -rf /import && \
	rm -v /etc/gerbera/config.xml

VOLUME [ "/etc/gerbera" ]

USER gerbera
ENTRYPOINT [ "/usr/local/bin/start-gerbera.sh" ]
