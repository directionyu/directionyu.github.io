---
title: Jenkins
date: 2017-04-10 16:00:42
categories: Jenkins
tag: Jenkins
toc: true
---

# 脚本

## 生成*.keystore

通过JDK下的bin目录下的keytool.exe来生成key
- jdk 1.7 及 1.7以下
keytool -genkey -alias ant_test -keyalg RSA -validity 20000 -keystore my.keystore
- jdk 1.8 及 1.8以上（1.8以后的jdk要求时间校准 加入 -tsa http://timestamp.digicert.com 如果出现校验时间错误，请找一个能用的tsa服务器）
keytool -tsa http://timestamp.digicert.com -genkey -alias myKey -keyalg RSA -validity 17820 -keystore myKey.keystore

## 签名 APK

```
# 输入完整信息签名一个应用，注意填写[]中对应的内容

# [yourStorepass] 签名文件密码 [aliasesPass] 别名密码 [forSignAPKPath] 要签名的apk路径  [aliases] 别名

jarsigner -verbose -keystore myKey.keystore -storepass [yourStorepass] -keypass [aliasesPass] [forSignAPKPath] [aliases]

# 查看帮助

jarsingner -help
```

## 校验签名

```java
# 查看一个路径为 [verifyApkPath] 的APK 是否签名

jarsigner -verify [verifyApkPath]

# 通过一个路径为 [keystorePath] 的签名文件，校验一个 路径为 [verifyApkPath] 的apk

jarsigner -verbose -verify -keystore [keystorePath] -certs [verifyApkPath]
```

## 查看签名文件信息
```xml
# 查看一个路径为 [keystorePath] 的签名文件的信息，需要签名的库密码

keytool -list -keystore [keystorePath]
```

## 签名脚本
### OSX or Linux

```
#!/bin/bash

# setting default key path here

# local OPTIND

# jarsigner -verbose -verify -keystore ${keyPath} -certs ${packagePath}

DEFAULT_KEY_PATH=/Users/sinlov/opt/myShell/myKey.keystore

DEFAULT_STORE_PASS="myPass"

DEFAULT_ALIASES="myAliases"

DEFAULT_KEY_PASS="keyPass"

DEFAULT_DIGESTALG=SHA1

DEFAULT_SIGALG=MD5withRSA



sigalg=${DEFAULT_SIGALG}

digestalg=${DEFAULT_DIGESTALG}

keyPath=${DEFAULT_KEY_PATH}

storepass=${DEFAULT_STORE_PASS}

keypass=${DEFAULT_KEY_PASS}

aliases=${DEFAULT_ALIASES}

packagePath=



IS_VERIFY=false



if [ ! -n "$1" ]; then

    echo "unkonw path, please use apk path"

    exit 1

else

    while getopts "p:k:h:" arg #after param has ":" need option

    do

        case $arg in

            p)

                echo "Package path: $OPTARG"

                packagePath=$OPTARG

                ;;

            k)

                echo "Key Path: $OPTARG"

                keyPath=$OPTARG

                ;;

            h)

                echo "use -p [packagePath] -k [keyPath] -h Show help"

                exit 1

                ;;

            ?)  # other param?

                echo "unkonw argument, please use -p [packagePath] -k [keyPath]"

                exit 1

                ;;

        esac

    done

fi



#echo "sigalg: ${sigalg}"

#echo "digestalg: ${digestalg}"

#echo "keyPath: ${keyPath}"

#echo "storepass: ${storepass}"

#echo "aliases: ${aliases}"

#echo "keypass: ${keypass}"

#echo "packagePath: ${packagePath}"

jarsigner -verbose -digestalg ${digestalg} -sigalg ${sigalg} -keystore ${keyPath} -storepass ${storepass} -keypass ${keypass} ${packagePath} ${aliases}
```
- 用法
```xml
# 给予运行权限

chmod +x my_sign_apk.sh

# 查看帮助

./my_sign_apk.sh -h

# 快速签名

./my_sign_apk.sh -p [apkPath]

# 指定签名文件签名

./my_sign_apk.sh -k [keyPath] -p [apkPath]
```

### Windows
```
@echo.============= Start Sign APK=============

@rem please set params with []

jarsigner -verbose -digestalg SHA1 -sigalg MD5withRSA -keystore [YourKeyFullPath] -storepass [storepass] -keypass [keyPass] "%~nx1" [aliases]
pause
```



# 构建触发器

Jenkins支持上图所示的触发时机配置，如果都不选，则为手动构建，需要点击“立即构建”按钮才构建。

Build periodically：周期进行项目构建（它不关心源码是否发生变化）；
Build when a change is pushed to GItHub：表示只要GitHub上面源码一更新即进行构件；
Poll SCM：定时检查源码变更（根据SCM软件的版本号），如果有更新就checkout最新code下来，然后执行构建动作。

Build periodically和Poll SCM都支持日程表的设置，这个与Spring框架中定时器的日程表配置类似，有5个参数：

第一个参数代表的是分钟 minute，取值 0~59；
第二个参数代表的是小时 hour，取值 0~23；
第三个参数代表的是天 day，取值 1~31；
第四个参数代表的是月 month，取值 1~12；
最后一个参数代表的是星期 week，取值 0~7，0 和 7 都是表示星期天。

如：

选择Build periodically并设置日程表为“0 4 ”，则表示每天凌晨4点构建一次源码。
选择Poll SCM并设置日程表为“/10 ”，则表示每10分钟检查一次源码变化，如果有更新才进行构建。

# FAQ
## 编译出现 AAPT: \\?\C:\Windows\System32\config\systemprofile\***等错误
![](https://github.com/directionyu/BlogPhotos/blob/master/res/jenkins_AAPT_error_1.png)

原因：因为本地Jenkins Service 的账号使用了系统账户登录，
解决方案：在Service 列表中找到Jenkins服务，在属性中选择登录选项卡，选用具体的桌面用户账号登录，再重启服务即可.


|--参数名-|参数类型|	参数值列表|
BUILD_TYPE	Choice	Release or Debug
IS_JENKINS	Choice	true
PRODUCT_FLAVORS	Choice	Xiaomi 、Wandoujia等
BUILD_TIME	Dynamic Parameter	2016-12-21-11-11
APP_VERSION	Choice	1.0.0、1.0.1等
GIT_TAG	Git Parameter	tag1.0.0等
