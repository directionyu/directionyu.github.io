---
title: FileProvider解析
date: 2017-07-31 16:12:23
categories: Android
tag: 'Android'
toc: true
---

## 背景
Google原文链接:https://developer.android.com/about/versions/nougat/android-7.0-changes.html#sharing-files
>对于面向 Android 7.0 的应用，Android 框架执行的 StrictMode API 政策禁止在您的应用外部公开 file:// URI。如果一项包含文件 URI 的 intent 离开您的应用，则应用出现故障，并出现 FileUriExposedException 异常。
要在应用间共享文件，您应发送一项 content:// URI，并授予 URI 临时访问权限。进行此授权的最简单方式是使用 FileProvider 类。

官方的意思就是从7.0开始不允许以 file:// 的方式通过 Intent 在两个 App 之间分享文件，取而代之的是通过 FileProvider 生成 content://Uri 。如果在 android N 以上的版本继续使用 file:// 的方式分享文件，则系统会直接抛出异常，导致 App 出现 Crash ，同时会报以下错误日志：
```java
FATAL EXCEPTION: main
    Process: com.inthecheesefactory.lab.intent_fileprovider, PID: 28905
    android.os.FileUriExposedException: file:///storage/emulated/0/.../xxx/xxx.jpg exposed beyond app through ClipData.Item.getUri()
    at android.os.StrictMode.onFileUriExposed(StrictMode.java:1799)
    at android.net.Uri.checkFileUriExposed(Uri.java:2346)
    at android.content.ClipData.prepareToLeaveProcess(ClipData.java:832)
```

## 什么是FileProvider
官方对于 FileProvider 的解释为：FileProvider 是一个特殊的 ContentProvider 子类，通过 content://Uri 代替 file://Uri 实现不同 App 间的文件安全共享。
当通过包含 Content URI 的 Intent 共享文件时，需要申请临时的读写权限，可以通过 Intent.setFlags() 方法实现。
而 file://Uri 方式需要申请长期有效的文件读写权限，直到这个权限被手动改变为止，这是极其不安全的做法。因此 Android 从 N 版本开始禁止通过 file://Uri 在不同 App 之间共享文件。

## FileProvider 的使用流程
1. 定义一个 FileProvider
2. 指定有效的文件
3. 为文件生成有效的 Content URI
4. 申请临时的读写权限
5. 发送 Content URI 至其他的 App

### 1. 定义 FileProvider
FileProvider 已经把文件生成 Content URI 的工作帮我们做掉了，因此我们只需要在 AndroidManifest.xml 文件中配置 <provider> 元素并提供相应的属性。
重要的属性包括以下四个：
- 设置 android:name 为android.support.v4.content.FileProvider，这是固定的，不需要手动更改；
- 设置 android:authorities 为 application id + .provider ；
- 设置 android:exported 为 false ，表示 FileProvider 不是公开的；
- 设置 android:grantUriPermissions 为 true 表示允许临时读写文件。
