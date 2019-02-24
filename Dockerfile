FROM debian:buster

COPY ./start-gerbera.sh /usr/local/bin/start-gerbera.sh
COPY ./config.xml /var/lib/gerbera/config-dist.xml

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install libavutil-dev libavcodec-dev libavformat-dev libavdevice-dev \
            libavfilter-dev libavresample-dev libswscale-dev libswresample-dev libpostproc-dev \
            libexpat-dev libupnp-dev libtag1-dev uuid-dev libsqlite3-dev duktape-dev \
            libcurl4-openssl-dev libmagic-dev libexif-dev systemd libsystemd-dev pkg-config \
            zlib1g-dev libffmpegthumbnailer-dev autoconf git build-essential cmake \
            \
            libavutil56 libavcodec-extra libavformat58 libavdevice58 libavfilter-extra7 \
            libavresample4 libswscale5 libswresample3 libpostproc55 libupnp13 libtag1v5 && \
    mkdir /workspace && \
    cd /workspace && \
    git clone https://github.com/gerbera/gerbera.git && \
    mkdir build && \
    cd build && \
    cmake ../gerbera -DWITH_MAGIC=1 -DWITH_CURL=1 -DWITH_JS=1 -DWITH_TAGLIB=1 -DWITH_AVCODEC=1 \
                        -DWITH_FFMPEGTHUMBNAILER=1 -DWITH_EXIF=1 && \
    make -j2 && \
    adduser --disabled-password --gecos "" gerbera && \
    chmod 0755 /usr/local/bin/start-gerbera.sh && \
    install -m 0755 -o gerbera -g gerbera -d /etc/gerbera && \
    (cd /workspace/build && make install) && \
    rm -rf /workspace && \
    apt-get -y purge libavutil-dev libavcodec-dev libavformat-dev libavdevice-dev \
            libavfilter-dev libavresample-dev libswscale-dev libswresample-dev libpostproc-dev \
            libexpat-dev libupnp-dev libtag1-dev uuid-dev libsqlite3-dev duktape-dev \
            libcurl4-openssl-dev libmagic-dev libexif-dev systemd libsystemd-dev pkg-config \
            zlib1g-dev libffmpegthumbnailer-dev autoconf git build-essential cmake

VOLUME [ "/etc/gerbera" ]

USER gerbera
ENTRYPOINT [ "/usr/local/bin/start-gerbera.sh" ]
