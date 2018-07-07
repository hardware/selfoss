FROM alpine:3.8

LABEL description "Multipurpose rss reader, live stream, mashup, aggregation web application" \
      maintainer="Hardware <contact@meshup.net>"

ARG VERSION=2.18
ARG SHA256_HASH="0b3d46b0b25170f99e3e29c9fc6a2e5235b0449fecbdad902583c919724aa6ed"

ENV GID=991 UID=991 CRON_PERIOD=15m UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

RUN echo "@community http://nl.alpinelinux.org/alpine/v3.8/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    wget \
    git \
 && apk add \
    musl \
    nginx \
    s6 \
    su-exec \
    libwebp \
    ca-certificates \
    php7@community \
    php7-fpm@community \
    php7-gd@community \
    php7-json@community \
    php7-zlib@community \
    php7-xml@community \
    php7-dom@community \
    php7-curl@community \
    php7-iconv@community \
    php7-mcrypt@community \
    php7-pdo_mysql@community \
    php7-pdo_pgsql@community \
    php7-pdo_sqlite@community \
    php7-ctype@community \
    php7-session@community \
    php7-mbstring@community \
    php7-simplexml@community \
    php7-xml \
    php7-xmlwriter \
    tini@community \
 && wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && CHECKSUM=$(sha256sum /tmp/selfoss-$VERSION.zip | awk '{print $1}') \
 && if [ "${CHECKSUM}" != "${SHA256_HASH}" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && sed -i -e 's/base_url=/base_url=\//g' /selfoss/defaults.ini \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*
VOLUME /selfoss/data
EXPOSE 8888
CMD ["run.sh"]
