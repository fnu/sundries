## 安装Redis
[Redis](http://www.redis.io/),  一个高性能的 __key-value__ 数据库.
  提供了丰富的数据类型, 很大程度弥补了 __memCached__  这类单一数据类型存储的不足, 在部分场合还可以对关系数据库起到很好的补充作用.
  很多语言都有`Redis`对应的客户端, `PHP` 推荐用 [phpRedis](https://github.com/nicolasff/phpredis) 这个扩展. 更多的客户端请查看[官方网](http://redis.io/clients)

#### 其它依赖
`Redis` 本身没有库依赖, 但它的测试工具依赖于 `Tcl`, 可以通过 YUM 直接安装.

#### 版本约定

```bash
VER_REDIS="redis-2.8.7"
```

#### 下载

```bash
cd /web/soft/
wget http://download.redis.io/releases/${VER_REDIS}.tar.gz
```

#### 安装

```bash
cd /web/soft/
tar zxf ${VER_REDIS}.tar.gz

cd ${VER_REDIS}/
make -j16
```

如果需要做测试, 那么需要安装 `tcl` 这个软件

```bash
yum install tcl
```

测试

```bash
make test
```

目录初始化和安装Redis

```bash
mkdir -p /web/redis/bin /web/redis/etc /web/redis/var/dumps /web/redis/var/logs

make PREFIX=/web/redis/ install
```

#### 管理脚本

注意一些属性, 一般目录说明

+ 配置: `/web/redis/etc/`
+ 日志: `/web/redis/var/logs/`
+ 数据: `/web/redis/var/dumps/`
+ 程序: `/web/redis/bin/redis-server`

由于 CentOS 默认没有 `update-rc.d` 这东东. 所以不支持官方自带的 `install_server.sh`.
但是没关系, 拷贝一下配置文件, 改一改就行了.

```bash
cp utils/redis_init_script /etc/init.d/redis_6379
```

默认的脚本并不支持 `chkconf`, 嗯, 改一改嘛, 在第2行的地方, 插入下面代码.

```bash
#
# redis:6379          Start up the Redis server daemon
#
# chkconfig: 2345 55 25
#
### BEGIN INIT INFO
# Provides: redis
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start up the Redis server daemon
### END INIT INFO

# source function library
. /etc/rc.d/init.d/functions

```

设置开机启动

```bash
chmod +x /etc/init.d/redis_6379
chkconfig --add redis_6379
chkconfig --level 2345 redis_6379 on
chkconfig --list redis_6379
```



@todo 没完... 等待有空时再整理.


#### 其它事项
在 `/etc/sysctl.conf` 中添加 "vm.overcommit_memory = 1"

```bash
echo "# Redis" >> /etc/sysctl.conf
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
```
