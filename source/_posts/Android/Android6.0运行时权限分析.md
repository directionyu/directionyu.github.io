---
title: Android6.0运行时权限分析
date: 2016-10-06T08:55:29.000Z
categories: Android
tag: 权限
toc: true
---

# 6.0版本（23）前权限规则

在23版本之前，用户在安装App时，系统会将所有在Manfiest清单上的所有权限默认授权。

# 6.0版本（23）后权限规则

Google是这样解释的[传送门](http://developer.android.com/intl/zh-cn/training/permissions/requesting.html)，大意可以理解从Android 6.0(API级别23)开始,程序权限授予在应用程序运行时，APP除了需要在Manifest文件中声明相应的权限之外，还要在APP运行时向用户进行请求每个dangerous类的权限。用户可以选择授予或不授予该权限，即使用户不授予该权限APP也可以继续运行，但是相关的需要权限的操作是没法进行的。

<!-- more -->

# 影响

在棉花糖中，系统关闭了对某些数据的访问权限，比如不能再访问本地 WiFi 和蓝牙 MAC 地址信息。 从现在开始，针对 WifiInfo 对象调用 getMacAddress()方法和 BluetoothAdapter.getDefaultAdapter().getAddress() 方法均会返回 02:00:00:00:00:00。

# 兼容性

23之前的app都能在6.0系统运行，走的还是老权限模式，manifest注册权限全部授予，但是如果开发中以不低于23来编译的话，app走的是新权限模式，如果包含dangerous权限，必须进行申请，否则App会崩掉。

# 6.0的权限分类

系统权限分为两类： 1.normal

-   Normal类的权限不会直接涉及到用户隐私风险。如果APP在Manifest文件中声明了Normal类的权限，系统会自动授予这些权限。

2.dangerous

-   Dangerous类的权限可能会让APP涉及到用户机密的数据。如果APP在Manifest文件中声明了Normal类的权限，系统会自动授予这些权限。如果在Manifest文件中添加了Dangerous类的权限，用户必须明确的授予对应的权限后APP才具有这些权限。

关于哪些权限属于Normal类，哪些属于Dangerous类，如下图：

# 权限申请流程

1.在AndroidManifest文件中添加需要的权限。

2.检查权限

    // Assume thisActivity is the current activity
    int permissionCheck = ContextCompat.checkSelfPermission(thisActivity,Manifest.permission.WRITE_CALENDAR);

ContextCompat.checkSelfPermission，主要用于检测某个权限是否已经被授予，方法返回值为 PackageManager.PERMISSION_DENIED或者PackageManager.PERMISSION_GRANTED。当返回DENIED就需要进行申请授权了。

3.申请授权

     ActivityCompat.requestPermissions(thisActivity,new String[]{Manifest.permission.READ_CONTACTS},MY_PERMISSIONS_REQUEST_READ_CONTACTS);

该方法是异步的，第一个参数是Context；第二个参数是需要申请的权限的字符串数组；第三个参数为requestCode，主要用于回调的时候检测。可以从方法名requestPermissions以及第二个参数看出，是支持一次性申请多个权限的，系统会通过对话框逐一询问用户是否授权。

4.处理权限申请回调

（未完待续）
