FROM --platform=linux/arm64 php:8.3-fpm-alpine

ONBUILD ARG __VAPOR_RUNTIME=
ONBUILD RUN if [ -z "$__VAPOR_RUNTIME" ] ; then \
    echo "No runtime provided. Please upgrade to the latest version of laravel/vapor-cli." ; \
    exit 1 ; \
    elif [ "$__VAPOR_RUNTIME" != "docker-arm" ] ; then \
    echo "The provided runtime [$__VAPOR_RUNTIME] is not supported by the vapor:php83-arm base image." ; \
    exit 1 ; \
    fi

RUN apk --update add \
    wget \
    curl \
    build-base \
    libmcrypt-dev \
    libxml2-dev \
    pcre-dev \
    zlib-dev \
    autoconf \
    oniguruma-dev \
    openssl \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    jpeg-dev \
    libpng-dev \
    imagemagick-dev \
    imagemagick \
    postgresql-dev \
    libzip-dev \
    gettext-dev \
    libxslt-dev \
    libgcrypt-dev \
    linux-headers && \
    rm /var/cache/apk/*

RUN pecl channel-update pecl.php.net && \
    pecl install mcrypt redis-6.0.1 && \
    rm -rf /tmp/pear

RUN docker-php-ext-install \
    mysqli \
    mbstring \
    pdo \
    pdo_mysql \
    xml \
    pcntl \
    bcmath \
    pdo_pgsql \
    zip \
    intl \
    gettext \
    soap \
    sockets \
    xsl

RUN docker-php-ext-configure gd --with-freetype=/usr/lib/ --with-jpeg=/usr/lib/ && \
    docker-php-ext-install gd

RUN docker-php-ext-enable redis

RUN cp "/etc/ssl/cert.pem" /opt/cert.pem

COPY runtime/bootstrap /opt/bootstrap
COPY runtime/bootstrap.php /opt/bootstrap.php
COPY runtime/php.ini /usr/local/etc/php/php.ini

RUN chmod 755 /opt/bootstrap
RUN chmod 755 /opt/bootstrap.php

ENTRYPOINT []

CMD /opt/bootstrap
