---
title: Gradle 自定义插件
date: 2017-12-18T10:54:29.000Z
categories: Gradle
tag: Gradle 插件
toc: true
---

# 什么是Gradle插件

Gradle 在它的核心中提供了一些小但有用的功能，用于在真实世界中的自动化。所有有用的功能， 例如以能够编译 Java 代码为例，都是通过插件进行添加的。插件添加了新任务 （例如JavaCompile）， 域对象 （例如SourceSet），约定（例如主要的 Java 源代码是位于 src/main/java），以及扩展的核心对象和其他插件的对象。

插件本身特性是幂等操作，可以被应用多次，多次执行后的影响与一次执行的的影响相同，不会影响系统状态，不用担心重复执行会对系统造成改变。

# 插件可以做什么

1. 将Task（编译、测试等）加入到项目构建的生命周期去。
2. 使用新的默认配置对将要进行构建的项目进行预配置。
3. 向项目中添加新的依赖配置。
4. 通过扩展现有的插件属性，添加新的方法。

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
