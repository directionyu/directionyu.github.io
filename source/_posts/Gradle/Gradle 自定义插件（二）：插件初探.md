---
title: Gradle 自定义插件（二）：插件初探
date: 2017-12-20T10:54:29.000Z
categories: Gradle
tag: Gradle 插件
toc: true
---

# Application Plugin

在Android工程中，app model下的build.gradle文件里包含android{}代码块，如下所示

```groovy
android {
    compileSdkVersion 26
    defaultConfig {
      ......
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

<!-- more -->

 该代码块中包含了android工程构建所需要的全部配置，这些配置之所以能被使用，原因就在于在build.gradle头行引入了android 插件

```groovy
apply plugin: 'com.android.application'
```

# 举个栗子

先用一个栗子来实现最简单的插件

1. 创建一个PluginTest类,记得创建不是java类,而是groovy类.

  ```groovy
  public class PluginTest implements Plugin<Project> {

  @Override
  void apply(Project project) {
  project.extensions.create('config', ApkDistributeExtension)
  project.task('hello') << {
      println "${project.config.keyone} from ${project.config.keytwo}"
  }
  }
  }
  ```

2. 创建一个参数接收类

  ```groovy
  public class ConfigExtension {
  String keyone = null
  String keytwo = null
  }
  ```

3. 在gradle-plugins目录下创建插件对应的配置文件com.roy.plugin.config.properties

  ```xml
  implementation-class=com.roy.plugin.PluginTest
  ```

4. 命令运行uploadArchives Task提交到本地仓库后app model进行依赖

5. 在根目录的build.gradle中添加如下代码

  ```groovy
  buildscript {

  repositories {
   google()
   jcenter()
   maven {
       url 'file://E:\\CodeRepository\\LocalMavenRepository' // 本地仓库地址
   }
   mavenCentral()
  }

  dependencies {
   classpath 'com.android.tools.build:gradle:3.0.1'
   classpath 'com.roy.plugin:androidbuildplugin:0.0.1' // 插件jar标识
  }
  }
  ```

6. app model下的build.gradle中引入插件

  ```groovy
  apply plugin: 'com.roy.plugin.config'
  ```

  注意看插件的名称，是不是很熟悉，就是gradle-plugins目录下插件对应的.properties配置文件名 官方约定：开发插件时我们需要指定插件的 id，如 apply plugin: "Java"，默认的插件 ID 为包名+类名，这个默认的命名规则太长了，使用时很不方便，我们可以指定一个 Short ID 作为别名。

# Project 对象

[Project 官方解释](https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html)

> This interface is the main API you use to interact with Gradle from your build file. From a Project, you have programmatic access to all of Gradle's features.

简单的说就是Project是与Gradle交互的主接口，通过它可以使代码使用所有Gradle的特性. Project与build.gradle是一对一的关系，即每一个build.gradle文件都会转换为一个Project对象.

每个Project对应一个个具体的工程，构建的过程中需要执行若干Task，所以需要为 Project 加载所需要的插件，比如为Java工程加载Java插件，Android工程加载Android插件，一个Project包含多少Task往往是插件决定的。

所以，在 Project中最重要的事情是

- 加载插件
- 不同插件有不同的行话，即不同的配置，要在 Project 中配置好，这样插件就知道从哪里读取源文件等
- 设置属性。

## 插件加载

Project的API位于 <https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html。> 加载插件是调用它的 apply函数.apply 其实是 Project 实现的 PluginAware 接口定义的

## Log 系统

在开发 Gradle 插件时可以使用 Gradle 自身的日志系统进行输出，如 project.logger.error(msg) Log日志级别

- quiet
- error
- warn
- lifecycle
- info
- debug
- trace

  运行时可以通过加上级别或其缩写来只输出某个级别以上的日志，如

  ```groovy
  gradle -q build 或 gradle --quiet build
  ```
