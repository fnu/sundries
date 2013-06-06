# 文档说明:
为线上环境的 Centos 安装 MySql, Nginx, PHP(Apc,PHPRedis, Memcached), Git, Redis, Memcached 等服务.

## 约定
安装的软件下载目录: `/web/soft/`  
Web的整体目录为:`/web/`  
PHP: `/web/php/`  
Nginx: `/web/nginx/`  
MySql采用Yum安装, 但数据目录改为: `/web/mysql/data/`  
日志目录: `/web/logs/` , 根据服务的不同, 再分子目录.

创建目录:
```
mkdir -p /web/soft/
cd /web/
mkdir -p nginx php nginx mysql/data logs/nginx logs/fpm/ 
```

### Yum 安装的基础库, Git, Memcache 和 MySql

```
yum install -y \
    git \
    mysql.x86_64 mysql-server.x86_64 \
    mysql-libs.x86_64 mysql-devel.x86_64 \
    libmemcached.x86_64 libmemcached-devel.x86_64 memcached.x86_64 memcached-devel.x86_64 \
    pcre-devel.x86_64 \
    libxml2.x86_64 libxml2-devel.x86_64 \
    curl.x86_64 libcurl.x86_64 libcurl-devel.x86_64 \
    libjpeg-turbo.x86_64 libjpeg-turbo-devel.x86_64 \
    libpng.x86_64 libpng-devel.x86_64 \
    libXpm.x86_64 libXpm-devel.x86_64 \
    freetype.x86_64 freetype-devel.x86_64 \
```

### 安装 libmcrypt
libmcrypt 软件Centos的仓库并没有提供, 需要自行下载安装.
```
cd /web/soft/
tar zxf libmcrypt-2.5.8.tar.gz

cd libmcrypt-2.5.8
./configure
make && make install

ldconfig
```


### 下载 PHP, Nginx 等软件
```
cd /web/soft/
wget http://cn2.php.net/get/php-5.4.15.tar.gz/from/this/mirror
wget http://nginx.org/download/nginx-1.4.1.tar.gz
```


### 安装PHP


#### PHPRedis 扩展
```
cd /web/soft/php-5.4.15/ext/
git clone git://github.com/nicolasff/phpredis.git redis
```

#### apc 扩展
```
cd /web/soft/php-5.4.15/ext/
wget http://pecl.php.net/get/APC-3.1.13.tgz
tar zxf APC-3.1.13.tgz
mv APC-3.1.13 apc
mv APC-3.1.13.tgz /web/soft/
```

#### memcache 扩展
```
cd /web/soft/php-5.4.15/ext/
wget http://pecl.php.net/get/memcache-2.2.7.tgz
tar zxf memcache-2.2.7.tgz
mv memcache-2.2.7 memcache
mv memcache-2.2.7.tgz /web/soft/

```

#### 重新生成 configure 脚本
只有更新了 configure 脚本, 才能在配置中识别出新增加的PHP扩展
```
cd /web/soft/php-5.4.15/

rm -f configure
./buildconf --force
```

#### libXpm 要在 /usr/lib 中建个软链接
由于 libXpm.so 默认保存在 `/usr/lib64` 下, PHP找不到它, 所以需要建立一个软链接过来.
```
ln -s /usr/lib64/libXpm.so /usr/lib/libXpm.so
```

#### 配置
请根据业务需求, 更改下面的配置信息
```
cd /web/soft/php-5.4.15/
./configure  \
    --prefix=/web/php \
    --enable-fpm \
    --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir \
    --with-zlib-dir --enable-zip --with-curl --with-mcrypt --enable-mbstring=all --with-mhash \
    --enable-gd-native-ttf --enable-ftp --with-iconv --with-xpm-dir  \
    --with-libxml-dir --with-pcre-regex \
    --with-mysql --with-mysqli \
    --enable-pdo --with-pdo-sqlite --with-pdo-mysql \
    --with-pdo-dblib \
    --enable-redis \
    --enable-soap  --with-xmlrpc  \
    --with-openssl \
    --enable-apc \
    --enable-memcache 
```

如果上面的配置没有出错, 那么, 就可以开始编译和测试,和安装.
```
make && make test 
make install
```

#### fpm 管理脚本
```
cd /web/soft/php-5.4.15/
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
```

#### fpm 配置
注意修改 fpm 的运行身份, 日志及端口等.
```
cd /web/soft/php-5.4.15/
cp /web/php/etc/php-fpm.conf.default /web/php/etc/php-fpm.conf
```

#### 拷贝生产环境的 php.ini
记得要修改 date.timezone = PRC, post, 等变量.
```
cd /web/soft/php-5.4.15/
cp php.ini-production /web/php/lib/php.ini
```

