Dockerfile с php7-fpm и некоторыми модулями

[PHP Modules]
```
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
```

[Zend Modules]
```
Xdebug
Zend OPcache
```

#### docker
Компиляция
```
make build
docker images
```
ищем последний образ, копируем его ID, пусть это будет 43392af1c789
```
docker tag 43392af1c789 registry.nodasoft.com/groall/php-fpm-7.1:0.4
docker push registry.nodasoft.com/groall/php-fpm-7.1:0.4
```