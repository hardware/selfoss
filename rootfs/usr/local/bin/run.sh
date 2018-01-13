#!/bin/sh

# Set cron period
sed -i "s/<CRON_PERIOD>/$CRON_PERIOD/g" /services/cron/run

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

# Set permissions
chown -R $UID:$GID /selfoss /services /var/log /var/lib/nginx

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /services
