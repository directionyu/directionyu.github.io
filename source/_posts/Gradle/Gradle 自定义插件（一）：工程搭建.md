---
title: Gradle 自定义插件（一）：工程搭建
date: 2017-12-18T10:54:29.000Z
categories: Gradle
tag: Gradle 插件
toc: true
---

# 什么是Gradle插件

Gradle 在它的核心中提供了一些小但有用的功能，用于在真实世界中的自动化。所有有用的功能， 例如以能够编译 Java 代码为例，都是通过插件进行添加的。插件添加了新任务 （例如JavaCompile）， 域对象 （例如SourceSet），约定（例如主要的 Java 源代码是位于 src/main/java），以及扩展的核心对象和其他插件的对象。

插件本身特性是幂等操作，可以被应用多次，多次执行后的影响与一次执行的的影响相同，不会影响系统状态，不用担心重复执行会对系统造成改变。

[Gradle插件用户指南](http://avatarqing.github.io/Gradle-Plugin-User-Guide-Chinese-Verision/introduction/README.html)

# 插件可以做什么

1. 将Task（编译、测试等）加入到项目构建的生命周期去。
2. 使用新的默认配置对将要进行构建的项目进行预配置。
3. 向项目中添加新的依赖配置。
4. 通过扩展现有的插件属性，添加新的方法。

<!-- more -->

 # 插件的类型

## 本地插件

直接在项目里编写，如之前的utils.gradle，这种方式的缺点是无法复用代码，在其他项目使用必须复制过去。

## 远程插件

在独立项目里编写，打包成jar，jar包含多个插件入口，发布到线上仓库，达到复用的效果。

# 插件的引用

举个例子：gradle依赖javaplugin插件的写法有多种方式

- 完整路径

  ```groovy
  apply plugin: org.gradle.api.plugins.JavaPlugin
  ```

- 短名称 插件都有一个标识自己的短名称，如JavaPlugin的短名称就是java。

  ```groovy
  apply plugin: 'java'
  ```

- 插件名

  ```groovy
  apply plugin: JavaPlugin
  ```

# 插件开发

## 工程创建

AS不像IDEA那样并没有groovy工程模板，但是原理是一样的

1. 新建一个Android Project
2. 再新建一个Module，这个Module用于开发Gradle插件，同样，Module里面没有gradle plugin给你选，但是我们只是需要一个"容器"来容纳我们写的插件，因此，可以随便选择一个Module类型（如Phone&Tablet Module或Android Librarty）,将里面的大部分内容删除，所以选择哪个类型的Module不重要。
3. 将Module里面的内容删除，只保留build.gradle文件和src/main目录。 由于gradle是基于groovy，因此，我们开发的gradle插件相当于一个groovy项目。所以需要在main目录下新建groovy目录
4. groovy又是基于Java，因此，接下来创建groovy的过程跟创建java很类似。在groovy目录下新建包名，如：com.roy.plugin，然后在该包下新建xxx.groovy文件

  ```
  ├── app
  │   ├── build.gradle
  │   ├── libs
  │   └── src
  │       ├── androidTest
  │       │   └── java
  │       ├── main
  │       │   ├── AndroidManifest.xml
  │       │   ├── java
  │       │   └── res
  │       └── test
  ├── build.gradle
  ├── plugin
  │   ├── build.gradle            
  │   └── src
  │       └── main
  │           ├── groovy          
  │           └── resources
  |               └── META-INF   
  |                   └── gradle-plugins     
  |                       └── xxx.properties
  ├── gradle
  │   └── wrapper
  │       ├── gradle-wrapper.jar
  │       └── gradle-wrapper.properties
  ├── gradle.properties
  ├── gradlew
  ├── gradlew.bat
  ├── local.properties
  └── settings.gradle
  ```

5. 删除pluginModel下的xxx.gradle中全部代码，添加如下代码，依赖开发插件必须的库

  ```groovy
  apply plugin: 'groovy'
  apply plugin: 'maven'

  dependencies {
    //gradle sdk
    compile gradleApi()
    //groovy sdk
    compile localGroovy()
    compile fileTree(dir: 'libs', include: ['*.jar'])
  }
  ```

6. 在plugin.gradle中添加上传仓库的Task，例子如下

  ```groovy
   uploadArchives {
     configuration = configurations.archives
     repositories.mavenDeployer {
         repository(url: LOCAL_REPO_URL) // 本地测试仓库
   //            repository(url: REMOTE_REPO_URL) { // 远程仓库
   //                authentication(userName: REMOTE_REPO_NAME, password: REMOTE_REPO_PASSWORD)
   //            }
         pom.groupId = PROJECT_GROUP_ID
         pom.artifactId = PROJECTECT_ARTIFACTID
         pom.version = PROJECT_VERSION
         description PROJECT_DESCRIPTION
     }
   }
  ```
