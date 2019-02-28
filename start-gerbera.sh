#!/bin/bash
set -ue

if [[ ! -f /etc/gerbera/config.xml ]]; then
    cp -v /var/lib/gerbera/config-dist.xml /etc/gerbera/config.xml
    sed -E -i -e "s/(\\s*)<udn\\/>/\\1<udn>uuid:$(uuidgen)<\\/udn>/g" /etc/gerbera/config.xml
fi

sed -E -i -e "s/(\\s*)<account user=\"(.+)\" password=\".*\"\\/>/\\1<account user=\"\\2\" password=\"${GERBERA_WEB_PASSWORD}\"\\/>/g" /etc/gerbera/config.xml
sed -E -i -e "s/(\\s*)<name>.*<\\/name>/\\1<name>${GERBERA_FRIENDLY_NAME}<\\/name>/g" /etc/gerbera/config.xml
sed -E -i -e "s/(\\s*)<interface>.*<\\/interface>/\\1<interface>${GERBERA_BIND_INTERFACE}<\\/interface>/g" /etc/gerbera/config.xml
sed -E -i -e "s/(\\s*)<home>.*<\\/home>/\\1<home>\\/var\\/lib\\/gerbera<\\/home>/g" /etc/gerbera/config.xml


exec /usr/local/bin/gerbera -c /etc/gerbera/config.xml "$@"
