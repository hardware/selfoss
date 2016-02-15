FROM alpine:3.3
MAINTAINER Hardware <contact@meshup.net>

ENV GID=991 UID=991 VERSION=2.14 DBHOST=mariadb DBUSER=selfoss DBNAME=selfoss

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk -U add \
    musl \
    nginx \
    php-fpm \
    php-gd \
    php-json \
    php-zlib \
    php-xml \
    php-dom \
    php-curl \
    php-iconv \
    php-mcrypt \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-ctype \
    supervisor \
    libressl@testing \
    tini@commuedge \
 && rm -f /var/cache/apk/* \
 && sed -i -e 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/php.ini

RUN wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && rm -rf /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup

RUN chmod +x /usr/local/bin/startup

VOLUME /selfoss/data
EXPOSE 80
CMD ["/usr/bin/tini","--","/usr/local/bin/startup"]