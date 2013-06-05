#!/bin/sh
#
# Mysql 数据库备份,自动打包脚本.
#
# dbback.sh mysqlHost  mysqlUsername mysqlPasswd mysqlDbName  sqlFilePath

echo $1
echo $2
echo $3
echo $4
echo $5

myhost=$1
myuser=$2
mypasswd=$3
backdb=$4
path=$5

now="`date +'%Y%m%d_%H.%M.%S'`"

cd $path

backfile="${myuser}_${backdb}_${now}.sql"

echo ${backfile}

date +'%Y-%m-%d_%H.%M.%S'

# 备份数据
mysqldump --opt --lock-tables -h${myhost} -u${myuser} -p${mypasswd} ${backdb} >  ${backfile}

date +'%Y-%m-%d_%H.%M.%S'

# 打包
tar zcf ${backfile}.tgz ${backfile}

# 删除源文件
rm -f ${backfile}

date +'%Y-%m-%d_%H.%M.%S'
