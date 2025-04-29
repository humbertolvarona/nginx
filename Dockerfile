FROM alpine:3.21

ARG BUILD_DATE
ARG VERSION="2.0.0"
ARG NGINX_VERSION="1.26.3-r0"

LABEL maintainer="VaronaTech"
LABEL build_version="Nginx version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL org.opencontainers.image.authors="HL Varona <humberto.varona@gmail.com>"
LABEL org.opencontainers.image.description="Nginx + PHP container optimized with additional modules and secure configuration"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"

ENV TIMEZONE=UTC
ENV PHP_MEMORY_LIMIT=512M
ENV NGINX_WORKER_PROCESSES=1
ENV REDIRECT_TO_HTTPS=no
ENV AUTOCERT=no
ENV CERT_WARN_DAYS=30

RUN mkdir -p /config/www /config/data /config/ssl /config/warnings && chmod -R 755 /config

RUN apk add --no-cache \
    tzdata \
    unzip \
    mc \
    nano \
    curl \
    wget \
    sqlite \
    memcached \
    coreutils \
    nginx=${NGINX_VERSION} \
    nginx-mod-http-brotli=${NGINX_VERSION} \
    nginx-mod-http-dav-ext=${NGINX_VERSION} \
    nginx-mod-http-echo=${NGINX_VERSION} \
    nginx-mod-http-fancyindex=${NGINX_VERSION} \
    nginx-mod-http-geoip=${NGINX_VERSION} \
    nginx-mod-http-geoip2=${NGINX_VERSION} \
    nginx-mod-http-headers-more=${NGINX_VERSION} \
    nginx-mod-http-image-filter=${NGINX_VERSION} \
    nginx-mod-http-perl=${NGINX_VERSION} \
    nginx-mod-http-redis2=${NGINX_VERSION} \
    nginx-mod-http-set-misc=${NGINX_VERSION} \
    nginx-mod-http-upload-progress=${NGINX_VERSION} \
    nginx-mod-http-xslt-filter=${NGINX_VERSION} \
    nginx-mod-mail=${NGINX_VERSION} \
    nginx-mod-rtmp=${NGINX_VERSION} \
    nginx-mod-stream=${NGINX_VERSION} \
    nginx-mod-stream-geoip=${NGINX_VERSION} \
    nginx-mod-stream-geoip2=${NGINX_VERSION} \
    nginx-vim=${NGINX_VERSION} \
    php83-bcmath \
    php83-fpm \
    php83-bz2 \
    php83-dom \
    php83-exif \
    php83-ftp \
    php83-gd \
    php83-gmp \
    php83-imap \
    php83-intl \
    php83-ldap \
    php83-mysqli \
    php83-mysqlnd \
    php83-opcache \
    php83-pdo_mysql \
    php83-pdo_odbc \
    php83-pdo_pgsql \
    php83-pdo_sqlite \
    php83-pear \
    php83-pecl-apcu \
    php83-pecl-mcrypt \
    php83-pecl-memcached \
    php83-pecl-redis \
    php83-pgsql \
    php83-posix \
    php83-soap \
    php83-sockets \
    php83-sodium \
    php83-sqlite3 \
    php83-tokenizer \
    php83-xmlreader \
    php83-xsl && \
    printf "Nginx version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
    rm -f /etc/nginx/conf.d/stream.conf && \
    rm -rf /var/cache/apk/* /tmp/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443
VOLUME /config

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -s -L -o /dev/null -w "%{http_code}" http://localhost | grep -qE "200|403|404"

ENTRYPOINT ["/start.sh"]
