---
title: Andoroid 疑难杂症系列(一)
date: 11/1/2016 11:35:31 AM   
categories: Android   
tag: AndroidStudio
toc: true  
---


## Android Sudio出现 Error:No Service of type Factory available in ProjectScopeServices。


![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115225.png)

定位到

![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115253.png)

应该是Meaven插件的问题

![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115328.png)

在[https://code.google.com/p/android/issues/detail?id=219692](https://code.google.com/p/android/issues/detail?id=219692) 已经有人提了issue

解决方法就是将

' classpath com.github.dcendents:android-maven-gradle-plugin:1.3'
版本升级到1.4.1 再次编译Success。
