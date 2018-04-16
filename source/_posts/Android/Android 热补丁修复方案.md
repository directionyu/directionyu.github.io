---
title: Android 热补丁修复方案
date: 2016-02-18T18:25:29.000Z
categories: Android
tag: Android
toc: true
---

# 热修复原理

Android的ClassLoader体系，android中加载类一般使用的是PathClassLoader和DexClassLoader，首先看下这两个类的区别：

-   对于PathClassLoader，从文档上的注释来看：

    > Provides a simple {@link ClassLoader} implementation that operates on a list of files and directories in the local file system, but does not attempt to load classes from the network. Android uses this class for its system class loader and for its application class loader(s).

    可以看出，Android是使用这个类作为其系统类和应用类的加载器。并且对于这个类呢，只能去加载已经安装到Android系统中的apk文件。

-   对于DexClassLoader，依然看下注释：

    > A class loader that loads classes from {@code .jar} and {@code .apk} files containing a {@code classes.dex} entry. This can be used to execute code not installed as part of an application.

    可以看出，该类呢，可以用来从.jar和.apk类型的文件内部加载classes.dex文件。可以用来执行非安装的程序代码。

    如果大家对于插件化有所了解，肯定对这个类不陌生，插件化一般就是提供一个apk（插件）文件，然后在程序中load该apk，那么如何加载apk中的类呢？其实就是通过这个DexClassLoader，具体的代码我们后面有描述。

    Android使用PathClassLoader作为其类加载器，DexClassLoader可以从.jar和.apk类型的文件内部加载classes.dex文件就好了。

上面我们已经说了，Android使用PathClassLoader作为其类加载器，那么热修复的原理具体是？

ok，对于加载类，无非是给个classname，然后去findClass，我们看下源码就明白了。 PathClassLoader和DexClassLoader都继承自BaseDexClassLoader。在BaseDexClassLoader中有如下源码：

BaseDexClassLoader中有个pathList对象，pathList中包含一个DexFile的集合dexElements，而对于类加载呢，就是遍历这个集合，通过DexFile去寻找。

> 一个ClassLoader可以包含多个dex文件，每个dex文件是一个Element，多个dex文件排列成一个有序的数组dexElements，当找类的时候，会按顺序遍历dex文件，然后从当前遍历的dex文件中找类，如果找类则返回，如果找不到从下一个dex文件继续查找。(来自：安卓App热补丁动态修复技术介绍)

所以热加载修复的原理总结为两句话：

1.  动态改变BaseDexClassLoader对象间接引用的dexElements；
2.  在app打包的时候，阻止相关类去打上CLASS_ISPREVERIFIED标志。

一个Android的apk插件是个什么形式。主要是三点，我总结如下：

-   DexLoader动态的加载dex文件进入vm
-   AndroidManifest.xml中预注册一些将要使用的四大组件（方法很low，其实有更好的）
-   针对四大组件，分别进行抽象代理，proxy
-   Apk安装还需要单独处理native的.so文件。
-   宿主需要处理好Resource，保证R文件的正确使用。

# 什么是dex

Dex是Dalvik VM executes的全称，和windows上的exe很像，你项目的源码java文件已被编译成了.dex. 在用ide开发的时候编译发布构建工具（ant,gradle）会调用（aapt）将DEX文件，资源文件以及AndroidManifest.xml文件组合成一个应用程序包（APK）

# Apk安装过程

1.  复制APK安装包到data/app目录下，解压并扫描安装包。
2.  dex文件(Dalvik字节码)保存到dalvik-cache目录，并data/data目录下创建对应的应用数据目录
3.  ODEX是安卓上的应用程序apk中提取出来的可运行文件，即将APK中的classes.dex文件通过dex优化过程将其优化生成一个.dex文件单独存放，原APK中的classes.dex文件会保留

这样做可以加快软件的启动速度，预先提取，减少对RAM的占用，因为没有odex的话，系统要从apk包中提取dex再运行

客户端app启动时，插件管理框架读取本地所有插件信息，例如插件版本，提供者等等，并将该信息发送到插件管理服务端，在服务端监测是否有新的插件需要更新。如果有新的插件插件管理框架负责下载等操作。 1.插件管理：读取插件信息和服务端交互，根据返回判断是否下载新的插件。

首先我们来打包jar包并转换成dex文件，首先将写好的jar包导出，Export->java jarfile ->Next 然后选择jar的存放目录。然后我们将jar包转成dex格式，为了方便我们将jar包放到SDK的安装目录plarform-tools下，DOS进入这个目录，执行命令： dx --dex -ouput=classes.jar Myplug.jar 这样我们就将Myplugin.jar转成了dex格式，
