groupadd web

userdel nginx
useradd --system --no-create-home --no-user-group --groups web --home-dir /web/wwwroot/ --shell /sbin/nologin nginx
useradd --system --no-create-home --no-user-group --groups web --home-dir /web/wwwroot/ --shell /sbin/nologin php


