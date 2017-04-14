---
title: Android Jenkins自动化构建
date: 2017-04-10 16:00:42
categories: Jenkins
tag: Jenkins,Android
toc: true
---

# 脚本

## 生成*.keystore

keytool: 是一个Java数据证书的管理工具，keytool 将密钥（key）和证书（certificates）
存在一个keystore的文件中，或者是jks的文件


-genkey:     在用户目录中创建一个默认.keystore文件
-alias       产生别名,不区分大小写
-keystore    指定密钥库的名称(产生的各类信息将不在.keystore文件中),其中包含密钥和公钥，指定导出的证书位置和名称
-keyalg      指定密钥的算法 (如 RSA  DSA（如果不指定默认采用DSA）)
-validity    指定创建的证书有效期多少天
-keysize     指定密钥长度
-storepass   指定密钥库的密码(获取keystore信息所需的密码)
-keypass     指定别名条目的密码(私钥的密码)
-dname       指定证书拥有者信息 例如：  "CN=名字与姓氏,OU=组织单位名称,O=组织名称,L=城市或区域名称,ST=州或省份名称,C=单位的两字母国家代码"
-list        显示密钥库中的证书信息      keytool -list -v -keystore 指定keystore -storepass 密码
-v           显示密钥库中的证书详细信息
-export      将别名指定的证书导出到文件  keytool -export -alias 需要导出的别名 -keystore 指定keystore -file 指定导出的证书位置及证书名称 -storepass 密码
-file        参数指定导出到文件的文件名
-delete      删除密钥库中某条目          keytool -delete -alias 指定需删除的别  -keystore 指定keystore  -storepass 密码
-printcert   查看导出的证书信息          keytool -printcert -file yushan.crt
-keypasswd   修改密钥库中指定条目口令    keytool -keypasswd -alias 需修改的别名 -keypass 旧密码 -new  新密码  -storepass keystore密码  -keystore sage
-storepasswd 修改keystore口令      keytool -storepasswd -keystore e:\yushan.keystore(需修改口令的keystore) -storepass 123456(原始密码) -new yushan(新密码)
-import      将已签名数字证书导入密钥库  keytool -import -alias 指定导入条目的别名 -keystore 指定keystore -file 需导入的证书

- 一次性生成Key

`keytool -genkey -alias $ALIAS -keypass 123456 -keyalg RSA -keysize 1024 -validity 3650 -keystore $PATH -storepass 123456 -dname "CN=fanle, OU=xx, O=xx, L=xx, ST=xx, C=xx"`


-certreq            生成证书请求
-changealias        更改条目的别名
-delete             删除条目
-exportcert         导出证书
-genkeypair         生成密钥对
-genseckey          生成密钥
-gencert            根据证书请求生成证书
-importcert         导入证书或证书链
-importpass         导入口令
-importkeystore     从其他密钥库导入一个或所有条目
-keypasswd          更改条目的密钥口令
-list               列出密钥库中的条目
-printcert          打印证书内容
-printcertreq       打印证书请求的内容
-printcrl           打印 CRL 文件的内容
-storepasswd        更改密钥库的存储口令


## 签名 APK

<!--more-->
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
