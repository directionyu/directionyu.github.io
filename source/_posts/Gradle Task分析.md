---
title: Gradle Task分析
date: 2017-06-14 15:11:22
categories: Gradle
tag: Gradle
toc: true
---

# 什么是Gradle Task

Gradle 是一个框架，它定义一套自己的游戏规则。我们要玩转 Gradle，必须要遵守它设 计的规则。下面我们来讲讲 Gradle 的基本组件：

Task 是 Gradle 中的一种数据类型，它代表了一些要执行或者要干的工作。不同的插件 可以添加不同的 Task。每一个 Task 都需要和一个 Project 关联。 Task 的 API 文档位于<https://docs.gradle.org/current/dsl/org.gradle.api.Task.html>

- 一个 Task 包含若干 Action。所以，Task 有 doFirst 和 doLast 两个函数，用于 添加需要最先执行的 Action 和需要和需要最后执行的 Action。Action 就是一个闭 包。

- Task 创建的时候可以指定 Type，通过 type:名字表达。这是什么意思呢？其实 就是告诉 Gradle，这个新建的 Task 对象会从哪个基类 Task 派生。比如，Gradle 本 身提供了一些通用的 Task，最常见的有 Copy 任务。Copy 是 Gradle 中的一个类。 当我们：task myTask(type:Copy)的时候，创建的 Task 就是一个 Copy Task。

- 当我们使用 task myTask{xxx}的时候。花括号是一个 closure。这会导致 gradle 在创建这个 Task 之后，返回给用户之前，会先执行 closure 的内容。

- 当我们使用 task myTask << {xxx}的时候，我们创建了一个 Task 对象，同时把 closure 做为一个 action 加到这个 Task 的 action 队列中，并且告诉它"最后才执行 这个 closure"（注意，<<符号是 doLast 的代表）。

<!--more-->

# Task生命周期

Gradle task在它的生命周期中有两个主要的阶段：『配置阶段』和『执行阶段』。

## 『配置阶段』

一个Task的最顶层的代码就是配置代码。

## 『执行阶段』

最简单的方法是使用doLast语句

```groovy
  task sampleTask {
       def text = 'Hello, World!' // 配置阶段
       doLast {
           println text // 执行阶段
       }
   }
```

### Task执行顺序

  1. 不加doLast和doFirst的最先执行
  2. 依赖task优先级高于自己的doFirst和doLast
  3. 同一个task中的doLast按从上向下顺序执行
  4. 同一个task中的doFirst按从下到上倒序执行
  5. 同一个task的doFirst优先级高于doLast

# Task语法

## 基本数据类型

作为动态语言，Groovy世界中的所有事物都是对象。所以，int，boolean 这些 Java 中 的基本数据类型，在 Groovy 代码中其实对应的是它们的包装数据类型。比如 int 对应为 Integer，boolean 对应为 Boolean。

## 容器类

Groovy中的容器类很简单，就三种：

- List：链表，其底层对应 Java 中的 List 接口，一般用 ArrayList 作为真正的实现类。
- Map：键-值表，其底层对应 Java 中的 LinkedHashMap。
- Range：范围，它其实是 List 的一种拓展。

# Task用法

## Task添加描述

```groovy
task copy(type: Copy) {
   description 'Copies the resource directory to the target directory.'
}
```
