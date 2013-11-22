# crontab
一些常见定时任务


```bash
# 网络校时
0 * * * *           /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1
```

