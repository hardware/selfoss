FROM wonderfall/nginx-php:7.1

LABEL description "Multipurpose rss reader, live stream, mashup, aggregation web application" \
      maintainer="Hardware <contact@meshup.net>"

ARG VERSION=2.17
ARG SHA256_HASH="5c880fe79326c0e584be21faeaebe805fac792f2c56b7fd5144584e5137a608d"

ENV GID=991 UID=991 CRON_PERIOD=15m UPLOAD_MAX_SIZE=25M MEMORY_LIMIT=128M

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    wget \
    git \
 && apk add \
    musl \
    libwebp \
    ca-certificates \
 && wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && CHECKSUM=$(sha256sum /tmp/selfoss-$VERSION.zip | awk '{print $1}') \
 && if [ "${CHECKSUM}" != "${SHA256_HASH}" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && sed -i -e 's/base_url=/base_url=\//g' /selfoss/defaults.ini \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY rootfs /
RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*
VOLUME /selfoss/data
EXPOSE 8888
CMD ["run.sh"]
