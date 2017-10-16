# Сборка на основе php7.1-fpm c докерхаба

Внутри debian

Билдится командой

    docker build ./Dockerfile

Копируем ID образа, пусть это будет d570ae34b062 и применяем ему тег

    docker tag d570ae34b062 registry.nodasoft.com/groall/php-fpm-7.1:0.6

Заливаем его в наш реестр

    docker push registry.nodasoft.com/groall/php-fpm-7.1:0.6

## Модули
```
[PHP Modules]
amqp
apcu
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
grpc
hash
iconv
imagick
intl
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
propro
readline
redis
Reflection
session
SimpleXML
soap
sockets
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlrpc
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Xdebug
Zend OPcache
```

# Сборка на основе ubuntu 16.04 и репы ppa:ondrej/php

Повторяет сборку на проде

Билдится командой

    docker build ./ubuntu-like-prod/Dockerfile

Копируем ID образа, пусть это будет 2a10e478b701 и применяем ему тег

    docker tag 2a10e478b701 registry.nodasoft.com/groall/php-fpm-like-prod-7.1:0.3


Заливаем его в наш реестр

    docker push registry.nodasoft.com/groall/php-fpm-like-prod-7.1:0.3
    
## Модули
```
[PHP Modules]
amqp
apc
apcu
bcmath
bz2
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
igbinary
imagick
imap
intl
json
libxml
mailparse
mbstring
mcrypt
memcached
msgpack
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
shmop
SimpleXML
soap
sockets
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tokenizer
wddx
xml
xmlreader
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```
