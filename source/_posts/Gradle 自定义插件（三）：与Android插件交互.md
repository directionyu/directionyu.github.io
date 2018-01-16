---
title: Gradle 自定义插件（三）：与Android插件交互
date: 2017-12-23T10:54:29.000Z
categories: Gradle
tag: Gradle 插件
toc: true
---

在Android的开发中，自定义的task往往都会跟Android插件（apply plugin: 'com.android.application'）关联使用
使用Android Pugin中的构建流程需要合理使用build variants，

  ```groovy
  android.applicationVariants.all { variant ->
  // Do something
  }
  ```
<!-- more -->

  applicationVriants是所有vriants的集合，通过迭代出每一个variant就可以获得对特定variant的应用，然后获得variant相应的属性，例如名称，描述等等；
  如果项目是一个Android Libraray那么applicationVariants应该改为librayVariants
  注意到上部分代码在迭代集合内容时采用的是all()方法而不是原先介绍的each()方法，这是因为each只有在build variants创建之前触发，而all方法只要有新加入的variants就会被触发
  这个技巧能够用来来来动态改变apk的名称，例如给apk名称加上版本号，接下来的部分将详细介绍如何动态修改apk名称

# 自动重命名APK文件
  在Android的打包流程中，最常见的需求就是通过给apk的名称加上版本号、渠道号重命名默认的Apk文件名称，具体实现可参考如下代码
