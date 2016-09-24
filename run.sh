#!/bin/sh

# Set permissions
chown -R $UID:$GID /selfoss /etc/nginx /etc/php7 /var/log /var/lib/nginx /tmp /etc/s6.d

# Selfoss custom configuration file
sed -i "s/lkjl1289/`cat \/dev\/urandom | tr -dc 'a-zA-Z' | fold -w 20 | head -n 1`/g" /selfoss/defaults.ini
rm -f /selfoss/config.ini

if [ -e /selfoss/data/config.ini ]; then
  cp /selfoss/data/config.ini /selfoss/config.ini
else
  cp /selfoss/defaults.ini /selfoss/data/config.ini
  cp /selfoss/defaults.ini /selfoss/config.ini
fi

# Init data dir
if [ ! "$(ls -Ad /selfoss/data/*/)" ]; then
   cd /selfoss/data/ && mkdir cache favicons logs sqlite thumbnails
fi

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
