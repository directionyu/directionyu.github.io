---
title: Android Jenkins自动化构建
date: 2017-04-10T16:00:42.000Z
categories: Jenkins
tags:
  - Jenkins
  - Android
  - 自动化
toc: true
---

# 环境搭建

## Android SDK

android sdk 工具包的一些命令行工具是基于32位系统的，在64为平台运行32程序必须安装 i386 的一些依赖库，方法如下：

```java
# aapt
sudo dpkg --add-architecture i386

# adb
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1

sudo apt-get update
```

<!-- more -->

 安装完成32位的依赖库后，我们使用wget 去官方下载最新的linux下android SDK包。

```
wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
tar xvzf android-sdk_r24.4.1-linux.tgz
```

编辑 .profile 或者 .bash_profile 把下面的目录增加到 path的搜索路径中，确保android SDK的的一些命令工具可以直接在终端使用，比如 adb 命令。 ANDROID_HOME=$HOME/android-sdk-linux PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

使环境变量生效

```
source ~/.profile
```

环境变量生效后，你可以使用android命令 列出sdk相关的列表，以便我们选择和自己项目匹配的SDK版本。(刚才只是安装了最基础的SDK，要完全满足你的开发环境需要还得从下面的列表中选择你需要的SDK和工具更新下载)

  ```
  android list sdk --all
  ```

输出如下所示：

```
Packages available for installation or update: 176
   1- Android SDK Tools, revision 25.2.5
   2- Android SDK Platform-tools, revision 25.0.4
   3- Android SDK Platform-tools, revision 26 rc1
   4- Android SDK Build-tools, revision 26 rc1
   5- Android SDK Build-tools, revision 25.0.2
   6- Android SDK Build-tools, revision 25.0.1
   7- Android SDK Build-tools, revision 25
   8- Android SDK Build-tools, revision 24.0.3
   9- Android SDK Build-tools, revision 24.0.2
  10- Android SDK Build-tools, revision 24.0.1
  11- Android SDK Build-tools, revision 24
  12- Android SDK Build-tools, revision 23.0.3
  13- Android SDK Build-tools, revision 23.0.2
  14- Android SDK Build-tools, revision 23.0.1
  15- Android SDK Build-tools, revision 23 (Obsolete)
  16- Android SDK Build-tools, revision 22.0.1
  17- Android SDK Build-tools, revision 22 (Obsolete)
  18- Android SDK Build-tools, revision 21.1.2
  19- Android SDK Build-tools, revision 21.1.1 (Obsolete)
  20- Android SDK Build-tools, revision 21.1 (Obsolete)
  21- Android SDK Build-tools, revision 21.0.2 (Obsolete)
  22- Android SDK Build-tools, revision 21.0.1 (Obsolete)
  23- Android SDK Build-tools, revision 21 (Obsolete)
  24- Android SDK Build-tools, revision 20
  25- Android SDK Build-tools, revision 19.1
  26- Android SDK Build-tools, revision 19.0.3 (Obsolete)
  27- Android SDK Build-tools, revision 19.0.2 (Obsolete)
  28- Android SDK Build-tools, revision 19.0.1 (Obsolete)
  29- Android SDK Build-tools, revision 19 (Obsolete)
  30- Android SDK Build-tools, revision 18.1.1 (Obsolete)
  31- Android SDK Build-tools, revision 18.1 (Obsolete)
  32- Android SDK Build-tools, revision 18.0.1 (Obsolete)
  33- Android SDK Build-tools, revision 17 (Obsolete)
  34- Documentation for Android SDK, API 24, revision 1
  35- SDK Platform Android 7.1.1, API 25, revision 3
  36- SDK Platform Android 7.0, API 24, revision 2
  37- SDK Platform Android 6.0, API 23, revision 3
  38- SDK Platform Android 5.1.1, API 22, revision 2
  39- SDK Platform Android 5.0.1, API 21, revision 2
  40- SDK Platform Android 4.4W.2, API 20, revision 2
  41- SDK Platform Android 4.4.2, API 19, revision 4
  42- SDK Platform Android 4.3.1, API 18, revision 3
  43- SDK Platform Android 4.2.2, API 17, revision 3
  44- SDK Platform Android 4.1.2, API 16, revision 5
  45- SDK Platform Android 4.0.3, API 15, revision 5
  46- SDK Platform Android 4.0, API 14, revision 4
```

这里包括不同的Android API 版本和不同的构建工具，选择你想要安装项目的序号，这里我想安装 build tools 25 ,build tools 25 及 android 4.4以上的SDK所以选择序号 "1,2,3,4,5,37,38,39,40,41"

`android update sdk -u -a -t 1,2,3,4,5,37,38,39,40,41`

## Gradle 3.3

wget <https://services.gradle.org/distributions/gradle-3.3-bin.zip>

释放到本地Home目录,创建名字为"gradle"的符号链接，符号连接的好处是方便版本更新，有了新的版本直接修改符号链接即可。

```
unzip gradle-2.12-bin.zip
ln -s gradle-2.12 gradle
```

配置gradle环境变量并使其生效,编辑 ~/.profje 文件增加下面内容

```
GRADLE_HOME=$HOME/gradle
export PATH=$PATH:$GRADLE_HOME/bin
```

保存后使环境变量使其生效 `source ~/.profile` 环境变量生效后你可以在终端敲入'gradle'命令并运行用以检测gradle是否安装成功。

`gradle`

如果安装配置的没有问题将会提示类似下面的信息

```
:help
Welcome to Gradle 2.12
To run a build, run gradle <task> ...
To see a list of available tasks, run gradle tasks
To see a list of command-line options, run gradle --help
BUILD SUCCESSFUL
```

# 签名详解

## 生成秘钥

keytool: 是一个Java数据证书的管理工具，keytool 将密钥（key）和证书（certificates）存在一个keystore的文件中，或者是jks的文件

## 命令

```
-genkey: 在用户目录中创建一个默认.keystore文件
-alias 产生别名,不区分大小写
-keystore 指定密钥库的名称(产生的各类信息将不在.keystore文件中),其中包含密钥和公钥，指定导出的证书位置和名称
-keyalg 指定密钥的算法 (如 RSA DSA（如果不指定默认采用DSA）)
-validity 指定创建的证书有效期多少天 -keysize 指定密钥长度
-storepass 指定密钥库的密码(获取keystore信息所需的密码)
-keypass 指定别名条目的密码(私钥的密码) -dname 指定证书拥有者信息 例如： "CN=名字与姓氏,OU=组织单位名称,O=组织名称,L=城市或区域名称,ST=州或省份名称,C=单位的两字母国家代码" -list 显示密钥库中的证书信息 keytool -list -v -keystore 指定keystore -storepass 密码 -v 显示密钥库中的证书详细信息
-export 将别名指定的证书导出到文件 keytool -export -alias 需要导出的别名
-keystore 指定keystore -file 指定导出的证书位置及证书名称
-storepass 密码
-file 参数指定导出到文件的文件名
-delete 删除密钥库中某条目 keytool -delete -alias 指定需删除的别名
-keystore 指定keystore -storepass 密码
-printcert 查看导出的证书信息 keytool -printcert -file yushan.crt -keypasswd 修改密钥库中指定条目口令keytool -keypasswd -alias 需修改的别名
-keypass 旧密码
-new 新密码
-storepass keystore密码 -keystore sage -storepasswd 修改keystore口令 keytool -storepasswd -keystore xxx.keystore(需修改口令的keystore)
-storepass 123456(原始密码)
-new yuanyu(新密码)
-import 将已签名数字证书导入密钥库 keytool -import -alias 指定导入条目的别名 -keystore 指定keystore -file 需导入的证书
```

## 一次性生成Key

`keytool -genkey -alias $ALIAS -keypass 123456 -keyalg RSA -keysize 1024 -validity 3650 -keystore $PATH -storepass 123456 -dname "CN=fanle, OU=xx, O=xx, L=xx, ST=xx, C=xx"`

<!-- more -->

## 签名 APK

```
# 输入完整信息签名一个应用，注意填写[]中对应的内容

# [yourStorepass] 签名文件密码 [aliasesPass] 别名密码 [forSignAPKPath] 要签名的apk路径  [aliases] 别名

jarsigner -verbose -keystore myKey.keystore -storepass [yourStorepass] -keypass [aliasesPass] [forSignAPKPath] [aliases]
```

## 校验签名

```java
# 查看一个路径为 [verifyApkPath] 的APK 是否签名

jarsigner -verify [verifyApkPath]

# 通过一个路径为 [keystorePath] 的签名文件，校验一个 路径为 [verifyApkPath] 的apk

jarsigner -verbose -verify -keystore [keystorePath] -certs [verifyApkPath]
```

## 查看签名文件信息

```java
# 查看一个路径为 [keystorePath] 的签名文件的信息，需要签名的库密码

keytool -list -keystore [keystorePath]
```

# 构建

## 动态参数

|--参数名-|参数类型| 参数值列表| BUILD_TYPE Choice Release or Debug IS_JENKINS Choice true PRODUCT_FLAVORS Choice Xiaomi 、Wandoujia等 BUILD_TIME Dynamic Parameter 2016-12-21-11-11 APP_VERSION Choice 1.0.0、1.0.1等 GIT_TAG Git Parameter tag1.0.0等

## 构建触发器

Jenkins支持上图所示的触发时机配置，如果都不选，则为手动构建，需要点击"立即构建"按钮才构建。

Build periodically：周期进行项目构建（它不关心源码是否发生变化）； Build when a change is pushed to GItHub：表示只要GitHub上面源码一更新即进行构件； Poll SCM：定时检查源码变更（根据SCM软件的版本号），如果有更新就checkout最新code下来，然后执行构建动作。

Build periodically和Poll SCM都支持日程表的设置，这个与Spring框架中定时器的日程表配置类似，有5个参数：

第一个参数代表的是分钟 minute，取值 0~59； 第二个参数代表的是小时 hour，取值 0~23； 第三个参数代表的是天 day，取值 1~31； 第四个参数代表的是月 month，取值 1~12； 最后一个参数代表的是星期 week，取值 0~7，0 和 7 都是表示星期天。

如：

选择Build periodically并设置日程表为"0 4 "，则表示每天凌晨4点构建一次源码。 选择Poll SCM并设置日程表为"/10 "，则表示每10分钟检查一次源码变化，如果有更新才进行构建。

# 上传S3

## 环境搭建

```shell

# 安装pip
apt-get install python-pip

# 安装awscli
apt-get install awscli

# 初始化配置
aws configure
# 做这一步时系统会要求输入“访问密钥ID”、“私有访问密钥”、“默认区域名称”、“默认输出格式”，前两个在创建IAM用户时会自动生成，“默认区域名称”最好选择桶EC2所在的区域，“默认输出格式”可以填json和text格式，默认是json格式。

# 创建存储桶
aws s3 mb s3://test20170418

# 上传文件到存储桶
aws s3 cp /usr/share/jenkins/test.txt s3://test20170418/
```

# build description

在持续集成过程中，随着feature的不断加入，版本越来越多，你希望每个build成功之后能显示一些很重要的信息，比如版本号，当前该build支持的主要feature等。

这样不论是开发还是测试，在拿build的时候都能一眼就看出该build对应的版本号以及主要的feature。

使用description setter plugin。安装该插件后，在【Post-build Actions】栏目中会多出description setter功能，可以实现构建完成后设置当次build的描述信息。这个描述信息不仅会显示在build页面中，同时也会显示在历史构建列表中。 该功能的强大之处在于，它可以在构建日志中通过正则表达式来匹配内容，并将匹配到的内容添加到BuildDescription中去。

```html
<img src='http://justdownit.s3.amazonaws.com/apps/gkt/android_jenkins/qrcode/${APP_NAME}_${PRODUCT_FLAVORS}_${BUILD_TYPES}_v${APP_VERSION}.png'></img>

<a href='http://justdownit.s3.amazonaws.com/apps/gkt/android_jenkins/apk/${APP_NAME}_${PRODUCT_FLAVORS}_${BUILD_TYPES}_v${APP_VERSION}.apk'>点击从S3下载Apk</a>

<br><br>GooglePlay线上URL：https://play.google.com/store/apps/details?id=$APPLICATION_ID<br><br>
包名：$APPLICATION_ID <br><br>
应用名:$APP_NAME <br><br>
APP_ID：$APP_ID <br><br>
APP_SECRET：$APP_SECRET <br><br>
ANALYTICS_ID：$ANALYTICS_ID <br><br>
FACEBOOK_ID：$FACEBOOK_ID <br><br>
FB GooglePlay Package Name：$APPLICATION_ID <br><br>
ADJUST_TOKEN：$ADJUST_TOKEN <br><br>
ADJUST_TRACK_EVENT_PAYMENT：$ADJUST_TRACK_EVENT_PAYMENT <br><br>
ADJUST_TRACK_EVENT_PAYMENT：$ADJUST_TRACK_EVENT_PAYMENT <br><br>
```

## 展示二维码图片

有了这个前提，要将二维码图片展示在历史构建列表中貌似就可以实现了，能直观想到的方式就是采用HTML的img标签，将`<img src='qr_code_url'>`写入到build描述信息中。

这个方法的思路是正确的，不过这么做以后并不会实现我们预期的效果。

这是因为Jenkins出于安全的考虑，所有描述信息的Markup Formatter默认都是采用Plain text模式，在这种模式下是不会对build描述信息中的HTML编码进行解析的。

要改变也很容易，Manage Jenkins -> Configure Global Security，将Markup Formatter的设置更改为Safe HTML即可。

更改配置后，我们就可以在build描述信息中采用HTML的img标签插入图片了。

另外还需要补充一个点。如果是使用蒲公英（pyger）平台，会发现每次上传安装包后返回的二维码图片是一个短链接，神奇的是这个短连接居然是固定的（对同一个账号而言）。这个短连接总是指向最近生成的二维码图片，但是对于二维码图片的唯一URL地址，平台并没有在响应中进行返回。在这种情况下，我们每次构建完成后保存二维码图片的URL链接就没有意义了。

应对的做法是，每次上传完安装包后，通过返回的二维码图片短链接将二维码图片下载并保存到本地，然后在build描述信息中引用该图片的Jenkins地址即可。

# Jenkins 权限组分配

# 脚本

见git：<http://git.dy/gkt/testjenkins/tree/master>

# FAQ

## Jenkins 在Linux下出现权限等问题

1. 进入/etc/default/目录 在jenkins文件中修改JENKINS_USER="root"
2. 重启Jenkins服务

## 编译出现 AAPT: \?\C:\Windows\System32\config\systemprofile_*_等错误

![](https://github.com/directionyu/BlogPhotos/blob/master/res/jenkins_AAPT_error_1.png)

原因：因为本地Jenkins Service 的账号使用了系统账户登录， 解决方案：在Service 列表中找到Jenkins服务，在属性中选择登录选项卡，选用具体的桌面用户账号登录，再重启服务即可.
