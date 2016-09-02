FROM alpine:3.4
MAINTAINER Hardware <contact@meshup.net>
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG VERSION=2.15

ENV GID=991 UID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    wget \
    git" \
 && apk -U add \
    ${BUILD_DEPS} \
    musl \
    nginx \
    libwebp \
    supervisor \
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
 # --------------- TEMPORARY PHP7 FIX ---------------
 && git clone -q https://github.com/bcosca/fatfree --depth=1 /tmp/f3 \
 && rm -rf /selfoss/libs/f3/* && mv /tmp/f3/lib/* /selfoss/libs/f3/ \
 # ---------------------------------------------
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup
COPY cron /etc/periodic/15min/selfoss

RUN chmod +x /usr/local/bin/startup /etc/periodic/15min/selfoss

VOLUME /selfoss/data
EXPOSE 80
CMD ["/sbin/tini","--","startup"]
