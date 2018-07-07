#!/bin/sh

# Set cron period, attachment size limit and memory limit
sed -i "s/<CRON_PERIOD>/$CRON_PERIOD/g" /services/cron/run
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/php7/php-fpm.conf /etc/nginx/nginx.conf
sed -i "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /etc/php7/php-fpm.conf

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

# Set log output to STDOUT if wanted (LOG_TO_STDOUT=true)
if [ "$LOG_TO_STDOUT" = true ]; then
  echo "[INFO] Logging to stdout activated"
  chmod o+w /dev/stdout
  sed -i "s/.*error_log.*$/error_log \/dev\/stdout warn;/" /etc/nginx/nginx.conf
  sed -i "s/.*error_log.*$/error_log = \/dev\/stdout/" /etc/php7/php-fpm.conf
fi

# Set permissions
chown -R $UID:$GID /selfoss /services /var/log /var/lib/nginx

# RUN !
exec su-exec $UID:$GID /bin/s6-svscan /services
