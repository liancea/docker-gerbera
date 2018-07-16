#!/bin/bash
set -ue

if [[ ! -f /etc/gerbera/config.xml ]]; then
	cp -v /var/lib/gerbera/config-dist.xml /etc/gerbera/config.xml
fi

sed -E -i -e "s/(\\s*)<account user=\"(.+)\" password=\".*\"\\/>/\\1<account user=\"\\2\" password=\"${GERBERA_WEB_PASSWORD}\"\\/>/g" /etc/gerbera/config.xml

exec /usr/bin/gerbera -c /etc/gerbera/config.xml
