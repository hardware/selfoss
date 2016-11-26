FROM alpine:3.4
MAINTAINER Hardware <contact@meshup.net>

ARG VERSION=2.16

ENV GID=991 UID=991 CRON_PERIOD=15m

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    wget \
    git" \
 && apk -U add \
    ${BUILD_DEPS} \
    musl \
    nginx \
    s6 \
    su-exec \
    libwebp \
    ca-certificates \
    php7@commuedge \
    php7-fpm@commuedge \
    php7-gd@commuedge \
    php7-json@commuedge \
    php7-zlib@commuedge \
    php7-xml@commuedge \
    php7-dom@commuedge \
    php7-curl@commuedge \
    php7-iconv@commuedge \
    php7-mcrypt@commuedge \
    php7-pdo_sqlite@commuedge \
    php7-ctype@commuedge \
    php7-session@commuedge \
    tini@commuedge \
 && sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php7/php.ini \
 && wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && sed -i -e 's/base_url=/base_url=\//g' /selfoss/defaults.ini \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /selfoss/data

EXPOSE 8888

CMD ["run.sh"]
