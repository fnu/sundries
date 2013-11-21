# 文档说明:
为线上环境的 Centos 安装 Nginx, PHP(Apc,PHPRedis), Git, Redis 等服务.

## 目录约定
安装的软件下载目录: `/web/soft/`  
Web的整体目录:`/web/`  
Web的站点主目录: `/web/wwwroot/`  
PHP: `/web/php/`  
Nginx: `/web/nginx/`  
MySql采用Yum安装, 但数据目录改为: `/web/mysql/data/`  
日志目录: `/web/logs/` , 根据服务的不同, 再分子目录.

创建目录:

```bash
mkdir -p /web/soft/
cd /web/
mkdir -p nginx php php/etc/pool.d/ nginx wwwroot logs/nginx logs/fpm
```

## 软件版本约定
```bash
VER_PHP="php-5.4.22"
```

### Yum 安装基础库

```bash
yum install -y \
    gcc auto gcc-c++ libtool make \
    pcre-devel.x86_64 \
    libxml2.x86_64 libxml2-devel.x86_64 \
    curl.x86_64 libcurl.x86_64 libcurl-devel.x86_64 \
    libjpeg-turbo.x86_64 libjpeg-turbo-devel.x86_64 \
    libpng.x86_64 libpng-devel.x86_64 \
    libXpm.x86_64 libXpm-devel.x86_64 \
    freetype.x86_64 freetype-devel.x86_64
```

### 安装 libmcrypt
libmcrypt 软件Centos的仓库并没有提供, 需要自行下载安装.

```bash
cd /web/soft/
tar zxf libmcrypt-2.5.8.tar.gz

cd libmcrypt-2.5.8
./configure
make -j16 && make install

ldconfig
```


### 下载 PHP
```bash
cd /web/soft/
wget http://www.php.net/get/${VER_PHP}.tar.gz/from/this/mirror
```

## 安装 PHP
```
cd /web/soft/
tar zxf ${VER_PHP}.tar.gz
```

#### libXpm 要在 /usr/lib 中建个软链接
由于 libXpm.so 默认保存在 `/usr/lib64` 下, PHP找不到它, 所以需要建立一个软链接过来.

```
ln -s /usr/lib64/libXpm.so /usr/lib/libXpm.so
```

#### 配置
请根据业务需求, 更改下面的配置信息

```
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
    --with-openssl
```

如果上面的配置没有出错, 那么, 就可以开始编译, 测试, 和安装.

```bash
make -j16 && make test 
make install
```

#### fpm 管理脚本

```bash
cd /web/soft/${VER_PHP}/
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
```

#### fpm 配置
注意修改 fpm 的运行身份, 日志及端口等.

```bash
cd /web/soft/${VER_PHP}/
cp /web/php/etc/php-fpm.conf.default /web/php/etc/php-fpm.conf
```

#### 拷贝生产环境的 php.ini
记得要修改 date.timezone = PRC, post, 等变量.

```bash
cd /web/soft/${VER_PHP}/
cp php.ini-production /web/php/lib/php.ini
```

#### 创建 /etc/ 下的软连接
```
ln -s /web/php/etc /etc/php
```

## 安装PHP的第三方扩展

#### PHPRedis 扩展

```bash
cd /web/soft/
git clone git://github.com/nicolasff/phpredis.git phpredis
cd /web/soft/phpredis
/web/php/bin/phpize

./configure --enable-redis --with-php-config=/web/php/bin/php-config

make -j16 && make test
make install

```

#### xCache 扩展 (与 Apc 扩展 二选一)
`xCache` 一个不错的PHP优化扩展, 也 `Apc` 功能是很接近, 我个人比较推荐用 `xCache`

```bash
cd /web/soft/
wget "http://xcache.lighttpd.net/pub/Releases/3.1.0/xcache-3.1.0.tar.gz"
tar zxf xcache-3.1.0.tar.gz
cd /web/soft/xcache-3.1.0
/web/php/bin/phpize

./configure --enable-xcache  --with-php-config=/web/php/bin/php-config

make -j16 && make test
make install

```

#### Apc 扩展 (与 xCache 扩展 二选一)

```bash
cd /web/soft/
wget http://pecl.php.net/get/APC-3.1.13.tgz
tar zxf APC-3.1.13.tgz
mv APC-3.1.13 apc
cd /web/soft/apc

/web/php/bin/phpize

./configure --enable-apc --with-php-config=/web/php/bin/php-config

make -j16 && make test
make install

```

#### memcache 扩展

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


Ok, PHP 的安装部分差不多就这样子.
