---
title: Android打包过程分析
date: ‎2017‎-01‎-0‎2‎，‏‎10:19:51   
categories: Android   
tag: 打包
toc: true  
---

Android工程打包有很多种方式：使用Eclispe或者AndroidStudio直接导出包，另一种是使用Ant工具在命令行方式下打包生成APK，无论采用哪种方式，过程的实质是一样的，Google官方提供了Apk文件构建流程图，文档传送门

从打包流程图可以看出，整个Apk打包过程分为7个步骤：

1. 打包资源文件，生成R.java文件，打包资源工具aapt位于android-Sdk\platform-tools目录下，该工具的源码在Android系统源码的framework\base\tools\aapt目录下，生成的过程主要是调用了aapt源码目录下Resource.cpp文件中的buildResource()函数，（未完待续）

<!--more-->
2. 处理aidl文件，生成相应的java文件，如果项目中没有使用到aidl，则不进行此步骤（未完待续）

3. 编译工程源代码，生成响应的class文件，这一步调用javac编译工程src下所有的java源文件，生成的class文件位于工程的bin\classes目录，（未完待续）

4. 转换所有的class文件，使用dx工具生成classes.dex文件，此工具在android-sdk\platform-tools目录，此步骤将java字节码转换为Dalivk字节码，压缩常量池、消除冗余信息等

5. 打包生成的Apk，使用apkBuilder工具，位于android-sdk\tools目录，此工具实际为一个脚本文件，实际调用的是android-sdk\tools\lib\sdklib.jar文件中的com.android.sdklib.build. ApkBuilderMain类，然后以包含resources.arsc的文件为基础生成apk文件，这个文件一般为ap_结尾的文件，接着调用addSourcesFolder()函数添加工程的资源，addSourcesFolder()会调用processFieForResource()函数向apk文件中添加资源，处理内容包括res目录与assets目录中的文件，添加完资源后调用addResourcesFromJar()函数向apk文件中写入依赖库，接着调用addNativeLibraries()函数添加工程libs目录下的Native库（通过Android NDK编译生成的so文件或bin文件），最后调用sealApk()关闭apk文件。

6. 对APK文件进行签名

7. 对签名后的文件进行对齐处理，使用到的工具为zipalign，位于android-sdk\tools目录，源码为与Android系统源码的build\tools\zipalign目录，此工具职能是将apk包进行对齐处理，使apk包中所有资源文件距离文件起始偏移为4个字节整数倍，这样通过内存映射访问apk文件时的速度回更快，验证apk文件是否对齐过由ZipAlign.cpp文件的verify（）函数完成，处理对齐的工作则由process()函数完成。
