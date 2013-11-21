# 管理用户

#### 创建用户的目录

```bash
mkdir /web/wwwroot/ -p
```

#### 添加用户
添加用户组 `web` 和 `nginx`, `php` 两个用户

```bash
groupadd web
userdel nginx
useradd --system --no-create-home --no-user-group --groups web --home-dir /web/wwwroot/ --shell /sbin/nologin nginx
useradd --system --no-create-home --no-user-group --groups web --home-dir /web/wwwroot/ --shell /sbin/nologin php
```