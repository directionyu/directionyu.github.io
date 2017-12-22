---
title: Gradle 自定义插件（二）：插件开发
date: 2017-12-20T10:54:29.000Z
categories: Gradle
tag: Gradle 插件
toc: true
---

# 举个栗子

先用一个栗子来实现最简单的插件

1. 创建一个PluginTest类

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
  注意看插件的名称，是不是很熟悉，就是gradle-plugins目录下插件对应的.properties配置文件名
  官方约定：开发插件时我们需要指定插件的 id，如 apply plugin: "Java"，默认的插件 ID 为包名+类名，这个默认的命名规则太长了，使用时很不方便，我们可以指定一个 Short ID 作为别名。



# Project 对象

[Project 官方解释](https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html)

> This interface is the main API you use to interact with Gradle from your build file. From a Project, you have programmatic access to all of Gradle's features.

简单的说就是Project是与Gradle交互的主接口，通过它可以使代码使用所有Gradle的特性，Project与build.gradle是一对一的关系
