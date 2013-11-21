## 安装 Nginx

#### Nginx 版本

```bash
VER_NGINX="1.4.4"
```

#### 下载Nginx

```bash
wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz
```

#### 解压
```bash
cd /web/soft/
tar zxf nginx-${VER_NGINX}.tar.gz

cd nginx-${VER_NGINX}
```

#### 配置
请根据业务需求, 更改下面的配置信息

```bash
cd /web/soft/nginx-${VER_NGINX}

./configure --prefix=/web/nginx \
    --user=nginx --group=web \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --http-log-path=/web/logs/nginx/access.log \
    --error-log-path=/web/logs/nginx/error.log 

make
```

#### 安装
如果编译没有问题, 那么就可以安装了

```bash
make install
```

#### 创建 /etc/ 下的软连接

```bash
ln -s /web/nginx/conf /etc/nginx
```

#### Nginx 管理脚本
脚本文件可以参考 [wiki.nginx.org](http://wiki.nginx.org/RedHatNginxInitScript "/etc/init.d/nginx") 上面的示例.

注意修改 `nginx="/usr/sbin/nginx"` , `NGINX_CONF_FILE="/etc/nginx/nginx.conf"` 这两项配置

