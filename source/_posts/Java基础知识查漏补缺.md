---
title: Java基础知识查漏补缺
date: 2015-09-29 00:00:42   
categories: Basic knowledge   
tag: Basic knowledge
toc: true  
---

# 标识符

1. 标识符第一位不能是数字

# 浮点型常量

1. 表示浮点型常量有两种方法:
- 直接写一个实数，或者在实数后面加字幕D，或者d，例如123.54、123.54d;
- 科学技术发，用10的方幂表示，用字符e或者E表示幂底10，例如123.54e0、123.54e1，不能在e或者E的两边没有数字，

# 运算符

1. "%"为求余运算符，求余数运算所得结果的符号与被除数符号相同。

2. 自增自减运算符运算对象只能是变量，不能是常量表达式。

<!--more-->


# 字符串

1. concat 拼接字符串，没有concat(String,String) 这种形式

2. indexof()，指定字符串中从某个位置开始检索参数字符串，返回字符串首次出现的位置，如果没有检索到返回-1，String字符串从0开始编号。

3. startsWith()方法判断字符串S1是否从字符串xx开始

4. /endWith()方法判断字符串s1是否从字符串xx结尾

## StringTokenizer
StringTokenizer是字符串分隔解析类型，属于Java.util包。

1. StringTokenizer的构造函数
StringTokenizer（String str）：构造一个用来解析str的StringTokenizer对象。java默认的分隔符是“空格”、“制表符（‘\t’）”、“换行符(‘\n’）”、“回车符（‘\r’）”。
StringTokenizer（String str，String delim）指定delim为分割符。
StringTokenizer（String str，String delim，boolean returnDelims）：构造一个用来解析str的StringTokenizer对象，并提供一个指定的分隔符，同时，指定是否返回分隔符。

2. StringTokenizer的一些常用方法
int countTokens（）：返回nextToken方法被调用的次数。
boolean hasMoreTokens（）：返回是否还有分隔符。
boolean hasMoreElements（）：返回是否还有分隔符。
String nextToken（）：返回从当前位置到下一个分隔符的字符串。
Object nextElement（）：返回从当前位置到下一个分隔符的字符串。
String nextToken（String delim）：与4类似，以指定的分隔符返回结果。
