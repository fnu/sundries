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
wget http://download.redis.io/releases/redis-${VER_REDIS}.tar.gz
```

#### 安装

```bash
cd /web/soft/
tar zxf redis-${VER_REDIS}.tar.gz

cd redis-${VER_REDIS}/
make -j16
make test

```


@todo 没完... 等待有空时再整理.


#### 其它事项
在 `/etc/sysctl.conf` 中添加 "vm.overcommit_memory = 1"

```bash
echo "# Redis" >> /etc/sysctl.conf
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
```
