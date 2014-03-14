# 文档说明:
为线上环境的 Centos 安装 Nginx, PHP(Yaf, PHPRedis), Git, Redis 等服务.

# 目录约定
安装的软件下载目录: `/web/soft/`  
Web的整体目录:`/web/`  
Web的站点主目录: `/web/wwwroot/`  
PHP: `/web/php/`  
Nginx: `/web/nginx/`  
日志目录: `/web/logs/` , 根据服务的不同, 再分子目录.

创建目录:

```bash
mkdir -p /web/soft/
cd /web/
mkdir -p nginx php php/etc/pool.d/ nginx wwwroot logs/nginx logs/fpm
```

# 软件版本约定
```bash
VER_PHP="php-5.5.10"
```

# Yum 安装基础库

```bash
yum install -y \
    gcc auto gcc-c++ libtool make \
    pcre-devel.x86_64 \
    libxml2.x86_64 libxml2-devel.x86_64 \
    curl.x86_64 libcurl.x86_64 libcurl-devel.x86_64 \
    libjpeg-turbo.x86_64 libjpeg-turbo-devel.x86_64 \
    libpng.x86_64 libpng-devel.x86_64 \
    libXpm.x86_64 libXpm-devel.x86_64 \
    freetype.x86_64 freetype-devel.x86_64 \
    libicu-devel.x86_64 libicu.x86_64 \
    openssl-devel.x86_64 \
    git
```

## 安装 libmcrypt
libmcrypt 软件Centos的仓库并没有提供, 需要自行下载安装.

```bash
cd /web/soft/
tar zxf libmcrypt-2.5.8.tar.gz

cd libmcrypt-2.5.8
./configure
make -j16 && make install

ldconfig
```

--------

# PHP
选择PHP版本的策略: 项目兼容性; 最新的稳定版.

## 下载 PHP
```bash
cd /web/soft/
wget http://www.php.net/get/${VER_PHP}.tar.gz/from/this/mirror
```

## 安装 PHP
```bash
cd /web/soft/
tar zxf ${VER_PHP}.tar.gz
```

## libXpm 要在 /usr/lib 中建个软链接
由于 libXpm.so 默认保存在 `/usr/lib64` 下, PHP找不到它, 所以需要建立一个软链接过来.

```bash
ln -s /usr/lib64/libXpm.so /usr/lib/libXpm.so
```

## 配置
请根据业务需求, 更改下面的配置信息

```bash
cd /web/soft/${VER_PHP}/

./configure  \
    --prefix=/web/php \
    --enable-fpm \
    --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir \
    --with-zlib-dir --enable-zip --with-curl --with-mcrypt --enable-mbstring=all --with-mhash \
    --enable-gd-native-ttf --enable-ftp --with-iconv --with-xpm-dir  \
    --with-libxml-dir --with-pcre-regex \
    --with-mysql \
    --enable-pdo --with-pdo-sqlite --with-pdo-mysql \
    --with-openssl \
    --disable-debug \
    --enable-sockets \
    --enable-intl \
    --enable-opcache
```

如果上面的配置没有出错, 那么, 就可以开始编译, 测试, 和安装.

```bash
make -j16 && make test 
make install
```

## fpm 管理脚本

```bash
cd /web/soft/${VER_PHP}/
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig --level 2345 php-fpm on
chkconfig --list php-fpm
```

## fpm 配置
注意修改 fpm 的运行身份, 日志及端口等.

```bash
cd /web/soft/${VER_PHP}/
cp /web/php/etc/php-fpm.conf.default /web/php/etc/php-fpm.conf
```

## 拷贝生产环境的 php.ini
记得要修改 `date.timezone = PRC` 和 `post` 等变量.

```bash
cd /web/soft/${VER_PHP}/
cp php.ini-production /web/php/lib/php.ini
```

## 创建 /etc/ 下的软连接
我们并没有安装在通用路径下, 可以创建一下软连接, 方便以后管理.  
创建软件之前, 强烈建议先检查一下原来系统有没有文件, 以防止被覆盖.


```bash
ln -s /web/php/etc /etc/php
ln -s /web/php/bin/php /usr/bin/php
```

## Opcache 的配置
因为 PHP 5.5.x 已经把 `zend Optimizer` 内置进来了, 所以没有太强烈理由去安装 `Xcache` / `Apc` 这些扩展了.
但是, 需要在 ini 配置文件中, 添加类似于下面的配置, 具体的参数, 根据环境和需求再作调整.
更多详细信息, 请看 (官方手册)[http://php.net/manual/zh/book.opcache.php]

```ini
zend_extension = opcache.so
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 60
opcache.fast_shutdown = 1
opcache.enable_cli = 1
opcache.enable = 1
```

--------

## 安装PHP的第三方扩展
安装第三方扩展后, 记得修改 `php.ini` 文件, 不然扩展不会自动加载

### PHPRedis 扩展 (如果项目没有用到, 不需要安装)

```bash
cd /web/soft/
git clone git://github.com/nicolasff/phpredis.git phpredis
cd /web/soft/phpredis
/web/php/bin/phpize

./configure --enable-redis --with-php-config=/web/php/bin/php-config

make -j16 && make test
make install
```

在 php.ini 中, 增加配置:
```ini
[redis]
extension = redis.so
```

### Yaf 扩展 (如果项目没有用到, 不需要安装)
因为PHP官方的 PECL 有提供 `Yaf`, 直接用 PECL 安装就可以了.

```bash
cd /web/soft/
/web/php/bin/pecl install yaf
```

在 php.ini 中, 增加配置:
```ini
[Yaf]
extension = yaf.so
; 启用命名空间
yaf.use_namespace = 1
```

### memcache 扩展 (如果项目没有用到, 不需要安装)

```bash
cd /web/soft/
wget http://pecl.php.net/get/memcache-2.2.7.tgz
tar zxf memcache-2.2.7.tgz
mv memcache-2.2.7 memcache
cd /web/soft/memcache

/web/php/bin/phpize

./configure --enable-memcache --with-php-config=/web/php/bin/php-config

make -j16 && make test
make install
```

