---
title: Mac下MySql服务启动问题
date: 2018-06-6T15:16:32.000Z
categories: Android
tag: Android
toc: true
---
# 启动终止命令

启动MySQL服务
sudo /usr/local/MySQL/support-files/mysql.server start

停止MySQL服务
sudo /usr/local/mysql/support-files/mysql.server stop

重启MySQL服务
sudo /usr/local/mysql/support-files/mysql.server restart

# MySQL启动报错问题
<!-- more -->

-   出现Unable to lock ./ibdata1 error: 35

    使用 ps -ef |grep mysqld 查看确实有进程在跑, 每次kill完又会重启进程,

    LAUNCHD是什么？
    launchd是Mac OS X从10.4开始引入，用于用于初始化系统环境的关键进程，它是内核装载成功之后在OS环境下启动的第一个进程。
    传统的Linux会使用/etc/rc.\* 或者/etc/init来管理开机要启动的服务，而在OS X中就是使用launchd来管理。采用这种方式来配置启动项很简单，
    只需要一个plist文件。/Library/LaunchDaemons目录下的plist文件都是系统启动后立即启动进程。使用launchctl命令加载/卸载plist文件，
    加载配置文件后，程序启动，卸载配置文件后程序关闭。
