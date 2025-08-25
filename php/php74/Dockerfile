FROM php:7.4.33-fpm

RUN apt-get update && apt-get install -y --allow-unauthenticated debian-archive-keyring && apt-get update

RUN apt-get install -y libpng-dev
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y unzip
RUN apt-get install -y zip
RUN apt-get install -y git
RUN apt-get install -y libaio1
RUN apt-get install -y libonig-dev
RUN apt-get install -y libmcrypt-dev 
RUN apt-get install -y wget 
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
COPY oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/




# Ekstrak Oracle Instant Client
RUN unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_12_2 /opt/oracle/instantclient && \
	ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so && \
	ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so && \
	ln -s /opt/oracle/instantclient/ /opt/oracle/instantclient/lib

RUN echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf
RUN ldconfig

# Install ekstensi PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) xml
RUN docker-php-ext-install -j$(nproc) opcache

# Install OCI8
# Download dan extract oci8 source dari PECL (versi 2.2.0 untuk PHP 7.4)
WORKDIR /usr/src
RUN wget https://pecl.php.net/get/oci8-2.2.0.tgz
RUN tar -xzf oci8-2.2.0.tgz
RUN rm oci8-2.2.0.tgz

# Compile dan install oci8
WORKDIR /usr/src/oci8-2.2.0
RUN phpize \
    && ./configure --with-oci8=shared,instantclient,/opt/oracle/instantclient \
    && make \
    && make install

# Enable oci8 extension
RUN echo "extension=oci8.so" > /usr/local/etc/php/conf.d/20-oci8.ini


# 📦 Install semua dependency OS untuk compile ekstensi PHP
RUN apt-get update
RUN apt-get install -y \
    bzip2 \
    libbz2-dev \
    libxpm-dev \
    libicu-dev \
    libxslt-dev \
    libpq-dev \
    libssl-dev \
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

# Download and extract mcrypt manually from PECL
WORKDIR /usr/src

RUN wget https://pecl.php.net/get/mcrypt-1.0.4.tgz \
    && tar -xzf mcrypt-1.0.4.tgz \
    && rm mcrypt-1.0.4.tgz

# Build mcrypt extension from source
WORKDIR /usr/src/mcrypt-1.0.4

RUN phpize \
    && ./configure \
    && make \
    && make install

# Enable mcrypt extension
RUN echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini
	
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient,12.2 \
    && docker-php-ext-install pdo_oci
    
# Install timezone data
RUN apt-get install -y tzdata

# Set timezone OS
ENV TZ=Asia/Jakarta

# Set timezone untuk PHP
RUN echo "date.timezone=Asia/Jakarta" > /usr/local/etc/php/conf.d/timezone.ini

# install composer
RUN wget https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# install JDK 8
RUN mkdir /usr/share/man/man1
RUN apt install openjdk-8-jdk -y

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
