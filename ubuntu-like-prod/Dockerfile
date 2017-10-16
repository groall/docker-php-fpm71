FROM ubuntu:16.04

MAINTAINER      groall <groall@nodasoft.com>

# Let the conatiner know that there is no tty
ENV     DEBIAN_FRONTEND noninteractive

# Set time
RUN     mv /etc/localtime /etc/localtime-old && \
        ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Install programms
RUN     apt-get update && \
        apt-get install -y --no-install-recommends \
        libfreetype6-dev libgd-dev libpng12-dev libjpeg-dev  \
        pdftk gcc make g++ build-essential tcl wget git tzdata curl zip nano ca-certificates inotify-tools pwgen \
        gnumeric p7zip-full mysql-client autoconf libtool make locales ssh openssh-client \
# and libs
        libpcre3-dev libevent-dev  librabbitmq-dev libcurl3 \
        # librabbitmq1 libjpeg62-turbo-dev
        libxml2-dev libicu-dev libbz2-dev

# Set locale
RUN     locale-gen ru_RU.UTF-8 && locale-gen en_US.UTF-8 && dpkg-reconfigure locales
RUN     apt-get install -y language-pack-en
RUN     update-locale LANG=en_US.UTF-8
ENV     LANG C.UTF-8

# Add repository ppa:ondrej/php
RUN     apt-get install -y python3 software-properties-common python-software-properties && \
        add-apt-repository ppa:ondrej/php && \
        apt-get update

# Install php and modules
RUN     apt-get install -y --no-install-recommends php7.1 \
        php7.1-imagick php7.1-mail php-mail-mime php-mail-mimedecode php7.1-mbstring php7.1-memcached \
        php7.1-cli php7.1-common php7.1-curl php7.1-dev php7.1-fpm php7.1-gd php7.1-imap php7.1-intl \
        php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-readline php7.1-soap \
        php7.1-sqlite3 php7.1-xml pkg-php-tools php7.1-bcmath php7.1-opcache \
        dh-php php-amqp php-apcu php-auth-sasl php-common php-db php-net-dime \
        php-http-request php-igbinary php-net-socket php-net-url php-pear php-redis php-soap php-xml \
        php-xml-parser php-apcu-bc php-net-smtp php-bz2  php-zip

# Install grpc
RUN     pecl install grpc

# Install mongo
RUN     apt-get install -y libssl-dev && \
        pecl install mongodb

# Instakk composer
RUN     curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN     usermod -u 1000 www-data

RUN     sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /etc/php/7.1/fpm/pool.d/www.conf
RUN     sed -i -e 's/;daemonize = yes/daemonize = no/' /etc/php/7.1/fpm/php-fpm.conf

# Clean
RUN     apt-get remove --purge -y software-properties-common g++ && \
        apt-get autoremove -y && \
        apt-get clean && \
        apt-get autoclean && \
        echo -n > /var/lib/apt/extended_states && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /usr/share/man/?? && \
        rm -rf /usr/share/man/??_*

RUN mkdir /run/php && chmod 777 /run/php

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.1", "-F"]


