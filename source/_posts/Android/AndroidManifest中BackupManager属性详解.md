---
title: AndroidManifest中BackupManager属性详解
date: 2017-06-08T14:18:29.000Z
categories: Android
tag: Android
toc: true
---

# 官方解释

<https://developer.android.com/reference/android/app/backup/BackupManager.html>

> The interface through which an application interacts with the Android backup service to request backup and restore operations. Applications instantiate it using the constructor and issue calls through that instance.

> When an application has made changes to data which should be backed up, a call to dataChanged() will notify the backup service. The system will then schedule a backup operation to occur in the near future. Repeated calls to dataChanged() have no further effect until the backup operation actually occurs.

> A backup or restore operation for your application begins when the system launches the BackupAgent subclass you've declared in your manifest. See the documentation for BackupAgent for a detailed description of how the operation then proceeds.Several attributes affecting the operation of the backup and restore mechanism can be set on the

> <application> tag in your application's AndroidManifest.xml file.</application>

直译过来就是： 这个接口能实现应用程序通过Andorid备份服务请求备份和恢复的操作

# Attributes

- android:allowBackup 是否允许应用程序进行备份
- android:backupAgent

- android:killAfterRestore

- android:restoreAnyVersion
