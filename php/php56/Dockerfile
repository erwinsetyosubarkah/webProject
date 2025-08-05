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

COPY oracle/instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/
COPY oracle/instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/




# Ekstrak Oracle Instant Client
RUN unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /opt/oracle && \
    unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_11_2 /opt/oracle/instantclient && \
	ln -s /opt/oracle/instantclient/libclntsh.so.11.1 /opt/oracle/instantclient/libclntsh.so && \
	ln -s /opt/oracle/instantclient/libocci.so.11.1 /opt/oracle/instantclient/libocci.so && \
	ln -s /opt/oracle/instantclient/ /opt/oracle/instantclient/lib

RUN echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf
RUN ldconfig

# Install ekstensi PHP
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) xml
RUN docker-php-ext-install -j$(nproc) opcache

# Install OCI8
RUN export LD_LIBRARY_PATH=/opt/oracle/instantclient
RUN echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8-2.0.12
RUN docker-php-ext-enable oci8

#install extension
# Ganti mirror ke arsip Debian (Jessie)
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i '/security.debian.org/d' /etc/apt/sources.list \
 && apt-get update

# 📦 Install semua dependency OS untuk compile ekstensi PHP
RUN apt-get install -y \
    bzip2 \
    libbz2-dev \
    libxpm-dev \
    libicu-dev \
    libmcrypt-dev \
    libxslt-dev \
    libpq-dev \
    libssl-dev \
    wget \
    gnupg \
    zlib1g-dev

# 📦 Pasang ekstensi stabil dulu
RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) calendar
RUN docker-php-ext-install -j$(nproc) exif
RUN docker-php-ext-install -j$(nproc) fileinfo 

# 🧩 Lanjut ekstensi tambahan (lebih sering error)
RUN docker-php-ext-install -j$(nproc) intl 
RUN docker-php-ext-install -j$(nproc) pdo_pgsql
RUN docker-php-ext-install -j$(nproc) pgsql
RUN docker-php-ext-install -j$(nproc) xsl 


RUN docker-php-ext-install mcrypt
	
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient,11.2 \
    && docker-php-ext-install pdo_oci
    
# Install timezone data
RUN apt-get install -y tzdata

# Set timezone OS
ENV TZ=Asia/Jakarta

# Set timezone untuk PHP
RUN echo "date.timezone=Asia/Jakarta" > /usr/local/etc/php/conf.d/timezone.ini

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
