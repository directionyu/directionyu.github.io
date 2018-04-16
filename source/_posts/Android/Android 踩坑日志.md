---
title: Android 踩坑日志
date: 2016-11-25T15:17:42.000Z
categories: Android
tag: Android
toc: true
---

# 异常

## Unable to add window -- token android.os.BinderProxy@164db98f is not valid；is your activity running?

-   原因：在弹出Dialog时出现此异常，原因是dialog依附的Activity已经不存在所导致。
-   分析：很多时候需要一个非组件类来调用一个view类的方法来弹出Dialog，这样需要提供一个静态的Context来创建dialog或者Toast，当然并不是所有静态context都是可以用来创建dialog的，例如getApplication().getApplicationContext()这个context就不行，因为它并不代表哪一个Activity或者View。。这样就无法add这个dialog。此view用于绑定显示数据，在其构造方法中初始化一个静态变量mContextNew为此view的mContext。这样就可以通过一个静态类来弹出对话框了，只需传入这个静态的context（mContextNew）就可以了。。但是这个静态的context如果只在构造方法中初始化的话是会存在问题的，因为如果另起了一个界面其绑定数据的view也是用的这个view那么这个静态context就会被重新修改。。因此当这个新的界面finish后返回到上次的界面，这个静态的context是刚才已经finish的view的context。因此如果仍然传入这个静态变量通过一个静态类来弹出对话框就会出现上述找不到window的错误了。
-   解决方案：

    -   对于tab页出现的错误可以用其父类的context来弹出dialog；
    -   对于界面已经销毁引起的错误就只能判断界面是否存在然后再弹出了；
    -   对于利用静态context来弹出的dialog可以通过规避的方式来解决，比如避免出现静态context被修改。但是这样就可能限制了我们程序的功能。因此我们可以通过在bind数据时时时更新这个静态context就可以解决此问题了，这样就可以保证这个静态的context在任何view中都是当前的界面的view的context。就不会出现找不到其父类window了。
    -   对于依附Activity上的Fragment，用显示之前调用activity的isFinishing方法判断一下，如果是false再显示。

<!-- more -->

# 系统API

## try catch finally，try里有return，finally还执行么？

-   Condition 1： 如果try中没有异常且try中有return （执行顺序）

try --- finally -- return

-   Condition 2： 如果try中有异常并且try中有return

try---catch--finally-- return 总之 finally 永远执行！

-   Condition 3： try中有异常，try-catch-finally里都没有return ，finally 之后有个return

try---catch--finally try中有异常以后，根据java的异常机制先执行catch后执行finally，此时错误异常已经抛出，程序因异常而终止，所以你的return是不会执行的

-   Condition 4： 当 try和finally中都有return时，finally中的return会覆盖掉其它位置的return（多个return会报unreachable code，编译不会通过）。

-   Condition 5： 当finally中不存在return，而catch中存在return，但finally中要修改catch中return 的变量值时

```java
int ret = 0;
try{
    throw new Exception();
}
catch(Exception e)
{
    ret = 1;  return ret;
}
finally{
    ret = 2;
}
```

## EditText 字体动态大小

EditText默认的hint文字大小为12sp，当有文字填写时，文字大小变为18sp，在xml文件中无法实现，只能通过下列java代码实现：

```java
  edit = (EditText) findViewById(R.id.edit);
  SpannableString ss = new SpannableString("请填写已经注册的手机号码");//定义hint的值
  AbsoluteSizeSpan ass = new AbsoluteSizeSpan(12, true);//设置字体大小 true表示单位是sp
  ss.setSpan(ass, 0, ss.length(),Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
  edit.setHint(new SpannedString(ss));
```

## 绘制虚线

```xml
  <shape xmlns:android="http://schemas.android.com/apk/res/android"   
       android:shape="line">  
       <!-- 显示一条虚线，破折线的宽度为dashWith，破折线之间的空隙的宽度为dashGap，当dashGap=0dp时，为实线 -->  
     <stroke android:width="1dp" android:color="#D5D5D5"      
               android:dashWidth="2dp" android:dashGap="3dp" />     
               <!-- 虚线的高度 -->   
     <size android:height="2dp" />      
  </shape>
```

## 内存泄漏

1.  查询数据库没有关闭Cursor。
2.  使用BaseAdapter作为适配器时没有复用convertView。
3.  bitmap没有回收。
4.  注册对象后没有反注册，比如Broadcast Receiver等。
5.  handler问题，如果handler是非静态的，会导致Activity或者Service不被回收，所以应当注册为静态内部类，同时在onDestroy时停止线程:mThread.getLooper().quit()。
6.  Activity被静态引用，特别是缓存bitmap时，解决方法可以考虑使用Application的context代替Activity的context。
7.  View在callback中被引用,可能回调还没有结束,但是view处于引用状态,无法回收。
8.  WebView的泄露问题:在魅族上面发现webView打开再关闭就会内存泄露。目前使用的解决方法是在webview外面嵌套一层layout作为Container.在Activity的onDestroy中调用container.removeAllViews()方法。
9.  Dialog导致Window泄露,如果需要在dialog依附的Activity销毁前没有调用dialog.dismiss()会导致Activity泄露

## 多进程

使用多进程可能会造成以下问题：

1.  静态成员和单例模式完全失效；
2.  线程同步完全失效;
3.  SharedPreferences可靠性下降；
4.  Application会多次创建；

## Android library中的资源ID在R.java中不是final类型

问题现象：在library中使用switch语句区分不同的资源ID时，IDE会报错；

原因分析：这个问题在Android Studio Project Site (<http://tools.android.com/tips/non-constant-fields>) 有提及，在ADT14及以上的版本中，library所对应的R.java中所有ID不再是final类型，所以不能将ID作为switch语句中的case分支属性值。这个问题和IDE无关，在Eclipse和AS中都存在。

解决方案：如果涉及到区分多个ID的情况（比如监听回调事件、初始化通过xml给自定义View设置的属性值等）应该使用if...else if...else代替switch语句；

## 同一个程序内的多个进程之间使用SharedPreferences不安全：

问题现象：在同一个程序内使用多进程时，在不同进程间使用SharedPreferences操作数据会导致SF中的数据随机丢失的情况（获取到的值为空）；

原因分析：虽然API中提供了Context.MODE MULTI PROCESS模式打开SF文件，但在官方文档 (<https://developer.android.com/reference/android/content/SharedPreferences.html>) 中已有说明："currently this class does not support use across multiple processes"，因为SF在多进程间操作是不安全的，并行操作时会导致写冲突。

解决方案：Github上有个开源项目Tray (<https://github.com/grandcentrix/tray>) ，专门针对在多进程中使用SF不安全的问题提供的解决方案。

## Typeface初始化自定义字体慢：

问题现象：在使用自定义字体的页面，进入慢；

原因分析：使用Typeface初始化字体很耗时，至少需要100ms（不同文件耗时不一样）以上的时间。

解决方案：如果在Activity的onCreate方法中初始化Typeface，会导致进入Activity慢，出现黑屏/白屏现象，所以应该尽量在非UI线程中做自定义字体的初始化操作。

## Toast连续显示时长时间不消失：

问题现象：多个Toast同时显示时，Toast一直显示不消失，退出程序了仍然显示；

原因分析：看Toast的源码可以发现，同时显示多个toast时是排队显示的，所以才会出现同时显示多个Toast时很久都不消失的情况；

解决方案：这属于体验问题，很多应用都存在。建议定义一个全局的Toast对象，这样可以避免连续显示Toast时不能取消上一次Toast消息的情况（如果你有连续弹出Toast的情况，避免使用Toast.makeText）；

## 不要通过Bundle传递很大块的数据：

问题现象：从目录界面跳转到内容显示界面，出现随机崩溃的现象，报的异常是：TransactionTooLargeException；

原因分析：跟踪发现如果通过Bundle传递太大块（>1M）的数据会在程序运行时报TransactionTooLargeException异常，具体原因可以上官网查看，大致意思是传递的序列化数据不能超过1M，否则会报TransactionTooLargeException异常；之所以随机是因为每次传递的数据大小不一样。

解决方案：如果你在不同组件之间传递的数据太大，甚至超过了1M，为了提高效率和程序的稳定性，建议通过持久化的方式传递数据，即在传递方写文件，在接收方去读取这个文件；

# AndroidStudio

## Adb connection Error:远程主机强迫关闭了一个现有的连接

原因分析：运行的adb.exe进程被意外结束，已经建立连接的模拟器或测试手机强行关闭

解决办法：在前面运行adb指令的1/2/3/4点中，错误打印killing这个词，可能因为运行C盘的adb.exe进程需要结束已运行的E盘的adb.exe进程，本地电脑即使有多个adb.exe，都会在运行另一个进程前结束另一个，造成Android Studio或Eclipse现有的连接被异常关闭。

总结：运行另一个adb进程会先结束已运行的进程，出现killing错误提示，一个adb进程依赖唯一的5037端口号，已运行的adb占用127.0.0.1:5037，提示套接字只允许使用一次错误。测试手机通过数据线连接当前电脑，一些第三方的手机软件自动运行，优先占用5037端口号，造成adb.exe无法正常使用。以往的做法，重新插拔数据线或者重启电脑恢复正常，读完TeachCourse的这篇文章，只需要几个指令即可正常启动adb进程。

## Android Sudio出现 Error:No Service of type Factory available in ProjectScopeServices。

![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115225.png)

定位到

![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115253.png)

应该是Meaven插件的问题

![image](https://raw.githubusercontent.com/directionyu/BlogPhotos/master/res/QQ%E6%88%AA%E5%9B%BE20161101115328.png)

在<https://code.google.com/p/android/issues/detail?id=219692> 已经有人提了issue

解决方法就是将

' classpath com.github.dcendents:android-maven-gradle-plugin:1.3' 版本升级到1.4.1 再次编译Success。

# Gradle

#
