---
title: Java基础知识查漏补缺
date: 2015-09-29 00:00:42   
categories: Basic knowledge   
tag: Basic knowledge
toc: true  
---
# 基础
1. 对象
  对象具有状态、行为和标识。意味着每一个对象可以拥有内部数据（它们给出该对象的状态）和方法（产生的行为），并且每一个对象都可以唯一的与其他对象区分开来（每一个对象在内存中都有一个唯一的地址）。

2. 消息
  在面向对象中，对象之间通过相互发送消息来进行交互，在Java中通过调用方法来传递消息。
3. 类
  类定义了某种类型所有对象所具有的属性和行为，是用来创建对象的蓝图或者模板；对象是某个确切的类的实例，在创建一个类的实例（对象）之前必须定义这个类。
4. 继承
  - 属于一个子类（派生类）的对象从父类（基类）中继承了全部属性和行为。所有可以发送给父类对象的消息也可以发送给子类对象。
  - 子类自然地继承其父类中非private的成员变量以及成员方法作为自己的成员变量和成员方法。

5. 多态
  对象的多态性是指在超类中定义的属性或者行为被子类继承后，可以具有不同的数据类型或者表现不同的行为，这使得同一个属性或者行为在一般类及其各子类中具有不同语义。
6. 联编
  是指将发送给对象的消息与包含执行该消息方法的对象连接起来。
  静态联编：在编译和连接阶段实现的联编。
  动态联编：在运行阶段实现的联编，是实现适应性多态的基础。

# 关键字
1. 一个类不能同时声明final与abstract，Final类是不能再被继承的类，也就是说没有子类，abstract类是抽象类，抽象类只声明一种模板，是没有具体实现代码的类，所有抽象类必须被继承，必须有子类，然后在子类中实现超类的抽象方法，否则不可能有实例。

2.

# 类作用
1. DriverManager：处理驱动程序加载和建立新数据连接。
2. Statment：用于在制定的连接中处理SQL语句。
3. Connection: 用于处理特定数据库的连接。
4. ResultSet：用于处理SQL语句执行后的查询结果。

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
