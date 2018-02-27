---
title: Android Gradle 扩展功能分析
date: 2018-01-11T22:01:29.000Z
categories: Gradle
tag: Gradle
toc: true
---

# lint

Android Tools中内置了Lint，这是一种针对代码、资源优化的命令行工具，它可以辅助检测项目哪些资源没有使用，哪些使用了新的API，哪些资源没有处理国际化等，并生成详细报告，供使用者进行分析优化。 AS中对其做了很好的支持，Android Gradle插件提供了lintOptions{}这个闭包来配置lint，

public void lintOptions{Action

<lintoptions> action}{
    checkWritability();
    action.execute(lintOptions);
  }</lintoptions>

## abortOnError

lintOptions的一个属性， 接受一个boolean值，用于在lint扫描过程中发现错误是否退出Gradle构建，默认为true

## absolutePaths

lintOptions的一个属性， 接受一个boolean值,用于配置错误的输出是否应该显示绝对路径，默认是true，显示。
