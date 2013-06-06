# 文档说明:
为线上环境的 Centos 安装 MySql, Nginx, PHP(Apc,PHPRedis, Memcached), Git, Redis, Memcached 等服务.

## 约定
安装的软件下载目录: `/web/soft/`  
Web的整体目录为:`/web/`  
PHP: `/web/php/`  
Nginx: `/web/nginx/`  
MySql采用Yum安装, 但数据目录改为: `/web/mysql/data/`  
日志目录: `/web/logs/` , 根据服务的不同, 再分子目录.



### Yum安装的基础库, Git, Memcache 和 MySql

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
