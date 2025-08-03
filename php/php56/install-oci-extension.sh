#!/bin/sh
set -e

apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev \
    libcurl4-openssl-dev unzip zip git libaio1 build-essential

# Ekstrak Oracle Instant Client
unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle
unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle
ln -s /opt/oracle/instantclient_12_2 /opt/oracle/instantclient
ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so

echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf
ldconfig

# Install ekstensi PHP
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install mysqli pdo pdo_mysql gd mbstring curl xml zip opcache

# Install OCI8
export LD_LIBRARY_PATH=/opt/oracle/instantclient
echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8-2.0.12
docker-php-ext-enable oci8

apt-get clean && rm -rf /var/lib/apt/lists/*
