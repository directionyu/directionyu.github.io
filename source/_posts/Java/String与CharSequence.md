---
title: String与CharSequence
date: 2016-12-29T16:28:22.000Z
categories: Java
tag: Java
toc: true
---

# String 和 CharSequence 关系

-   String 继承于CharSequence，也就是说String也是CharSequence类型。

-   CharSequence是一个接口，它只包括length(), charAt(int index), subSequence(int start, int end)这几个API接口。除了String实现了CharSequence之外，StringBuffer和StringBuilder也实现了CharSequence接口。 需要说明的是，CharSequence就是字符序列，String, StringBuilder和StringBuffer本质上都是通过字符数组实现的！

-   CharSequence与String都能用于定义字符串，但CharSequence的值是可读可写序列，而String的值是只读序列。

-   CharSequence是实现这个接口的实例，而对于一个抽象类或者是接口类不能使用new来直接赋值，但是可以通过以下方式进行实例的创建

-   CharSequence str = "dd"
-   举例： CharSequence str = "dd"; 就是 CharSequence str = new String("dd");
