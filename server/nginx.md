## 安装 Nginx

### 可能需要用到的库
+ `pcre-devel` : Nginx 的 `rewrite` 模块需要用到此库
+ `openssl`, `openssl-devel`: 加密库, 主要的密码算法, 常用的密钥和证书封装管理功能以及SSL协议等

可能通过简单的 `yum` 命令安装上面的库

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
因为我们并没有安装在通用路径下,
所以, 如果没有安装过Nginx, 可以创建一下软连接, 方便以后管理.

```bash
ln -s /web/nginx/conf /etc/nginx
ln -s /web/nginx/sbin/nginx /usr/sbin/nginx
```

#### Nginx 管理脚本
脚本文件可以参考 [wiki.nginx.org](http://wiki.nginx.org/RedHatNginxInitScript "/etc/init.d/nginx") 上面的示例.

注意 `nginx="/usr/sbin/nginx"` , `NGINX_CONF_FILE="/etc/nginx/nginx.conf"` 这两项配置

```bash
wget http://wiki.nginx.org/RedHatNginxInitScript --output-document=/etc/init.d/nginx
chkconfig --add nginx
chkconfig --list nginx
```


