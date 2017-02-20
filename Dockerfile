FROM php:7.1-fpm

MAINTAINER      groall <groall@nodasoft.com>

# Set time
RUN     mv /etc/localtime /etc/localtime-old && \
        ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Install programms
RUN     apt-get update && apt-get install -y --no-install-recommends \
libfreetype6-dev libgd-dev libpng12-dev libjpeg-dev libjpeg62-turbo-dev \
        pdftk gcc make g++ build-essential tcl wget git tzdata curl zip nano ca-certificates inotify-tools pwgen gnumeric \
        p7zip-full mysql-client autoconf libtool make locales \
# and libs
        libpcre3-dev libevent-dev librabbitmq1 librabbitmq-dev libcurl3 \
        libxml2-dev libicu-dev libbz2-dev && \
# Set locale
        locale-gen ru_RU.UTF-8 && locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Install extenstions
RUN     docker-php-ext-install -j$(nproc) iconv
RUN     docker-php-ext-install mbstring xmlrpc mysqli zip dom exif pdo pdo_mysql soap opcache
RUN     docker-php-ext-install bcmath bz2 ctype hash json pcntl posix session simplexml sockets xml
#imap phar
# Install Xsl
RUN     apt-get update && apt-get install -y --fix-missing libxslt1.1 libxslt1-dev && \
        docker-php-ext-install xsl && \
# Install curl
        apt-get install -y --fix-missing libcurl4-gnutls-dev && \
        docker-php-ext-install curl && \
# Install mcrypt
        apt-get install -y --fix-missing libmcrypt-dev && \
        docker-php-ext-install -j$(nproc) mcrypt && \
# Install gd
        apt-get install -y --fix-missing libfreetype6-dev libgd-dev libpng12-dev libjpeg-dev libjpeg62-turbo-dev && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
        docker-php-ext-install -j$(nproc) gd && \
# Install imagick
        apt-get install -y --fix-missing libmagic-dev libmagickwand-dev && \
        pecl install imagick && \
        docker-php-ext-enable imagick && \
# Install memcached
        apt-get install -y --fix-missing libmemcached-dev && \
        curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" && \
        mkdir -p memcached && \
        tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 && \
        ( \
           cd memcached && \
           phpize && \
           ./configure && \
           make -j$(nproc) && \
           make install \
        ) && \
        rm -r memcached && \
        rm /tmp/memcached.tar.gz && \
        docker-php-ext-enable memcached

# Install Redis
# оставил на будущее, пока заработал пекловский модуль
#ENV PHPREDIS_VERSION php7
#RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
#    && mkdir /tmp/redis \
#    && tar -xf /tmp/redis.tar.gz -C /tmp/redis \
#    && rm /tmp/redis.tar.gz \
#    && ( \
#        cd /tmp/redis/phpredis-$PHPREDIS_VERSION \
#        && phpize \
#        && ./configure \
#        && make -j$(nproc) \
#        && make install \
#    ) \
#    && rm -r /tmp/redis \
#    && docker-php-ext-enable redis

# php-redis ENV PHPREDIS_VERSION 3.0.0
#RUN docker-php-source extract \
#    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
#    && tar xfz /tmp/redis.tar.gz \
#    && rm -r /tmp/redis.tar.gz \
#    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
#    && docker-php-ext-install redis \
#    && docker-php-source delete

RUN     pecl install -o -f redis && \
        rm -rf /tmp/pear && \
        docker-php-ext-enable redis

# Install xdebug
RUN     pecl install xdebug && \
        docker-php-ext-enable xdebug &&\
        echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.remote_host=xdebug-host" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install apcu
RUN     docker-php-source extract && \
        pecl install apcu && \
        docker-php-ext-enable apcu && \
        docker-php-source delete

# Install intl
RUN     docker-php-ext-configure intl && \
        docker-php-ext-install intl

# Install xhprof
# не ставится, нет под php 7
#RUN     curl -L https://github.com/preinheimer/xhprof/tarball/3bbf52e | tar xz && \
#        mv preinheimer-xhprof-3bbf52e /opt/xhprof && \
#        cd /opt/xhprof/extension && \
#        phpize && \
#        ./configure && \
#        make && \
#        make install
# Install propro
RUN     pecl install propro && \
        docker-php-ext-enable propro
# Install protobuf
# не ставится
#RUN     pecl install -o -f protobuf && \
#        docker-php-ext-enable protobuf
# Install grpc
RUN     pecl install grpc && \
        docker-php-ext-enable grpc

# Install amqp
# не имеет смысла, т.к. старая версия либы в репе
#RUN     apt-get install -y librabbitmq-dev librabbitmq1 &&\
  # INSTALL PACKAGES DEPENDENCIES
ENV     LIBRABBITC_VERSION 0.8.0


#RUN     mkdir /pkg
RUN     wget https://github.com/alanxz/rabbitmq-c/releases/download/v$LIBRABBITC_VERSION/rabbitmq-c-$LIBRABBITC_VERSION.tar.gz && \
        tar -zxvf rabbitmq-c-$LIBRABBITC_VERSION.tar.gz && \
        cd rabbitmq-c-$LIBRABBITC_VERSION && \
        apt-get install automake -y && \
        apt-get install sudo  -y && \
        autoreconf -i && ./configure && make && sudo make install

# CREATE PACKAGE
#ENV AMQP_VERSION 1.8.0
#RUN     apt-get install -y checkinstall
#RUN     cd /tmp && wget -q https://pecl.php.net/get/amqp-$AMQP_VERSION.tgz && \
#        tar -zxvf amqp-$AMQP_VERSION.tgz && \
#        cd amqp-$AMQP_VERSION && \
#        phpize && \
#        ./configure LIBS=/usr/lib/librabbitmq.so.4.2.0 && \
#        checkinstall -y --install=no --pkgname='php7.1-amqp' --pkgversion='$AMQP_VERSION-aig' --pkggroup='php' --pkgsource='https://github.com/pdezwart/php-amqp' --maintainer='Marcelo Almeida \<marcelo.almeida@jumia.com\>' --requires='php7.1-common \(\>= 7.0.7\), librabbitmq1 \(\>= $LIBRABBITC_VERSION\)' --include=include_etc
#
#RUN     docker-php-ext-enable amqp

# Install other extensions
RUN     pecl install -o -f amqp-1.8.0 && \
        rm -rf /tmp/pear && \
        docker-php-ext-enable amqp

# Install mongo
# не ставится, нет под php 7
#RUN     pecl install mongo && \
#        docker-php-ext-enable mongo

RUN     sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf
#RUN echo "expose_php=0" > /usr/local/etc/php/php.ini
RUN     curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN     usermod -u 1000 www-data

# Clean
RUN     apt-get remove --purge -y software-properties-common g++ && \
        apt-get autoremove -y && \
        apt-get clean && \
        apt-get autoclean && \
        echo -n > /var/lib/apt/extended_states && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /usr/share/man/?? && \
        rm -rf /usr/share/man/??_*

#COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

CMD ["php-fpm"]