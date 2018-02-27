---
title: Gradle-SignConfig(签名配置)
date: 2016-11-08T19:11:42.000Z
categories: Android
tag: Android
toc: true
---

# Gradle Signing 要素

- Gradle 签名打包应用位置，键名，两个密码，还有存储类型一起形成了签名配置。
- 默认情况下，debug被配置成使用一个debug keystory。 debug keystory使用了默认的密码和默认key及默认的key密码。 debug keystory的位置在$HOME/.android/debug.keystroe，如果对应位置不存在这个文件将会自动创建一个。
- debug Build Type(构建类型) 会自动使用debug SigningConfig (签名配置)。
- 可以创建其他配置或者自定义内建的默认配置。通过signingConfigs这个DSL容器来配置

# Gradle中隐藏Key密码

1. 添加releaseConfig

```
android{
  signingConfigs {
        release {
            keyAlias 'alias_ndp'
            keyPassword System.console().readLine("\nKey password: ")
            storeFile file('D:/NdpKeyStore/ndp.keystore')
            storePassword System.console().readLine("\nKeystore password: ")
        }
    }
}
```

1. 指向releaseConfig

```
buildTypes {
    release {
        ...
        signingConfig signingConfigs.release
        ...
    }
}
```

1. 隐藏用户名

```
signingConfigs {
       release {
           keyAlias 'alias_ndp'
           keyPassword System.console().readLine("\n Key password: ")
           storeFile file('D:/NdpKeyStore/ndp.keystore')
           storePassword System.console().readLine("\n KeyStore password: ")
       }
   }
```

1. FAQ

2. Gradle build 时出现 Cannot invoke method readLine() on null object"
