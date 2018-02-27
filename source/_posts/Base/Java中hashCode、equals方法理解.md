---
title: Java中hashCode、equals方法理解
date: 2016-05-29T00:00:42.000Z
categories: java
tag: java
toc: true
---

hashCode()和equals()定义在Object类中，这个类是所有java类的基类，所以所有的java类都继承这两个方法。

# hashCode()

hashCode()方法被用来获取给定对象的唯一整数。这个整数被用来确定对象被存储在HashTable类似的结构中的位置。 默认的，Object类的hashCode()方法返回这个对象存储的内存地址的编号。
