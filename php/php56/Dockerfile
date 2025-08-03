FROM php:5.6.40-fpm

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

RUN apt-get update && apt-get install -y --allow-unauthenticated debian-archive-keyring && apt-get update

RUN apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \ 
    libxml2-dev \
    unzip \
    zip \
    git \
    libaio1 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
COPY oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/




# Ekstrak Oracle Instant Client
RUN unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_12_2 /opt/oracle/instantclient && \
ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so

RUN echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf
RUN ldconfig

# Install ekstensi PHP
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd mysqli pdo pdo_mysql gd mbstring curl xml zip opcache

# Install OCI8
RUN export LD_LIBRARY_PATH=/opt/oracle/instantclient
RUN echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8-2.0.12
RUN docker-php-ext-enable oci8

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
