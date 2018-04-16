---
title: Java基础知识
date: 2015-09-29T00:00:42.000Z
categories: Basic knowledge
tag: Basic knowledge
toc: true
---

# 基础

1.  对象 对象具有状态、行为和标识。意味着每一个对象可以拥有内部数据（它们给出该对象的状态）和方法（产生的行为），并且每一个对象都可以唯一的与其他对象区分开来（每一个对象在内存中都有一个唯一的地址）。

2.  消息 在面向对象中，对象之间通过相互发送消息来进行交互，在Java中通过调用方法来传递消息。

3.  类 类定义了某种类型所有对象所具有的属性和行为，是用来创建对象的蓝图或者模板；对象是某个确切的类的实例，在创建一个类的实例（对象）之前必须定义这个类。

4.  继承

-   属于一个子类（派生类）的对象从父类（基类）中继承了全部属性和行为。所有可以发送给父类对象的消息也可以发送给子类对象。
-   子类自然地继承其父类中非private的成员变量以及成员方法作为自己的成员变量和成员方法。

5.  多态 对象的多态性是指在超类中定义的属性或者行为被子类继承后，可以具有不同的数据类型或者表现不同的行为，这使得同一个属性或者行为在一般类及其各子类中具有不同语义。

6.  联编 是指将发送给对象的消息与包含执行该消息方法的对象连接起来。 静态联编：在编译和连接阶段实现的联编。 动态联编：在运行阶段实现的联编，是实现适应性多态的基础。

7.  类变量 用static关键字修饰的就是类变量，类变量是常驻于内存的，是所有类的实例变量，可以不通过类名来访问，

8.  实例变量 没有用static修饰的就是实例变量，类变量只能通过类来访问。

    # 关键字

## final

1.  final类，final类是不能再被继承的类，没有子类。
2.  final方法，不能够被重写的方法。
3.  final变量，不能被更改初始化的值。

## abstract

1.  一个类不能同时声明final与abstract，abstract类是抽象类，抽象类只声明一种模板，是没有具体实现代码的类，所有抽象类必须被继承，必须有子类，然后在子类中实现超类的抽象方法，否则不可能有实例。

# 类作用

1.  DriverManager：处理驱动程序加载和建立新数据连接。
2.  Statment：用于在制定的连接中处理SQL语句。
3.  Connection: 用于处理特定数据库的连接。
4.  ResultSet：用于处理SQL语句执行后的查询结果。

# 标识符

1.  标识符第一位不能是数字

# 浮点型常量

1.  表示浮点型常量有两种方法:
2.  直接写一个实数，或者在实数后面加字幕D，或者d，例如123.54、123.54d;
3.  科学技术发，用10的方幂表示，用字符e或者E表示幂底10，例如123.54e0、123.54e1，不能在e或者E的两边没有数字，

# 运算符

1.  "%"为求余运算符，求余数运算所得结果的符号与被除数符号相同。

2.  自增自减运算符运算对象只能是变量，不能是常量表达式。

3.  移位运算符的优先级低于算术运算符，高于关系运算符，他们结合的方向是自左向右。

<!-- more -->

# 字符串

## public void concat()

拼接字符串，没有concat(String,String) 这种形式

## indexof

指定字符串中从某个位置开始检索参数字符串，返回字符串首次出现的位置，如果没有检索到返回-1，String字符串从0开始编号。

## startsWith(String prefix)

方法判断字符串S1是否从字符串xx开始

## endWith(String suffix)

方法判断字符串s1是否从字符串xx结尾

## StringTokenizer

StringTokenizer是字符串分隔解析类型，属于Java.util包。

1.  StringTokenizer的构造函数 StringTokenizer（String str）：构造一个用来解析str的StringTokenizer对象。java默认的分隔符是"空格"、"制表符（'\\t'）"、"换行符('\\n'）"、"回车符（'\\r'）"。 StringTokenizer（String str，String delim）指定delim为分割符。 StringTokenizer（String str，String delim，boolean returnDelims）：构造一个用来解析str的StringTokenizer对象，并提供一个指定的分隔符，同时，指定是否返回分隔符。

2.  StringTokenizer的一些常用方法 int countTokens（）：返回nextToken方法被调用的次数。 boolean hasMoreTokens（）：返回是否还有分隔符。 boolean hasMoreElements（）：返回是否还有分隔符。 String nextToken（）：返回从当前位置到下一个分隔符的字符串。 Object nextElement（）：返回从当前位置到下一个分隔符的字符串。 String nextToken（String delim）：与4类似，以指定的分隔符返回结果。

## compareTo(String str)

按照字典顺序比较两个字符串的大小，该比较基于字符串中各个字符的Unicode值，如果String对象小于参数字符串，则返回一个负整数。若大于返回一个正整数，如果两个字符串相等，则返回0.

## indexOf()

用于在字符串中从左到右查找一个字符或者子串的索引位置

## substring()

可以用来从一个String里检索一个字符子串 String str = "helloworld"; str.substring(5) = "world"; str.substring(9) = "d"

## replace(char oldChar, char newChar)

返回一个新字符串，通过用newChar替换此字符串中出现的所有oldChar得到的

## trim()

返回字符串的副本，去掉前后空白

## valueOf()

用于把某种基本类型的值转换成一个String对象

# 包

## java.awt

java.awt是一个软件包，包含用于创建用户界面和绘制图形图像的所有分类。在AWT术语中，诸如按钮或滚动条之类的用户界面对象称为组件。Component类是所有 AWT 组件的根。

## java.applet

Java Applet就是用Java语言编写的一些小应用程序，它们可以直接嵌入到网页中，并能够产生特殊的效果。包含Applet的网页被称为Java-Powered页，可以称其为Java支持的网页

## java.io

Java的核心库java.io提供了全面的IO接口。包括：文件读写、标准设备输出等。Java中IO是以流为基础进行输入输出的，所有数据被串行化写入输出流，或者从输入流读入。

## java.awt.event

提供用于处理AWT组件触发的不同类型事件的接口和类。

# 多线程

线程由"创建->工作->死亡"的过程成为线程的声明周期 线程声明周期的五个状态：新建(new Thread())、就绪(start())、运行(run())、阻塞、死亡。 调度优先级由数值表示，数组越大优先级越高(范围是0~10).

## Thread类和Runnable接口

### Thread

利用Thread类的子类创建的线程对象和在类中实现Runnable接口的run()方法是Java程序实现多线程技术的两种途径。 具体操作步骤： 用Thread子类实现多线程 => 先声明创建一个Thread类的子类，并在子类中重新定义run()方法，当程序需要多线程时,可以创建Thread子类的实例，并让此线程实例调用start()方法，这时run()方法将自动执行。

### Runable

用Runnable接口实现多线程 => 声明实现Runnable接口的类，在类中实现run()方法，并在该类中声明线程对象，在init()方法或者start()方法中创建线程实例，并在start()中启动此线程实例。

# I/O

FileInputStream类和FileOutputStream类实现字节的读写操作。 FileReader类和FileWriter类实现字符的读写操作。

# Connection类、Statement类、ResultSet类

Connection类是java.sql包中用于处理与特定数据库连接的类。 Statement creatStatement()方法 用于创建Statement对象。 Statement类是java.sql包中用于在指定的连接中处理SQL语句的类。数据库编程的要点是在程序中嵌入SQL命令。 ResultSet类的实例是用来存储查询结果集的。 数据库编程连接的步骤：

1.  声明和创建连接数据库的Connection对象，并让该对象连接数据库。 Connection con;
2.  调用类DriverManager的静态方法getConnection()获得Connection对象 Connection con = DriverManager.getConnection(url，username，password);
3.  用Statement类声明SQL语句对象,并调用Connection对象的creatStatement()方法创建SQL语句对象。 Statement sqlstr = con.createStatement();
4.  利用SQL语句对象调用executeQuery()执行SQL语句查询，并将查询结果存在一个ResultSet类的实例里。 ResultSet rs = sqlstr.executeQuery(SQL语句);

# 网络

## URLConnection

### 网络访问基本过程

先创建一个URL对象，利用URL对象的openConnection()方法从系统获取一个URLConnection对象，使用URLConnection对象提供的方法获取流对象实现网络连接。

# InetAddress类。

InetAddress类的对象用于存储IP地址和域名.

## 构造方法：

String getHostName()//用于获取InetAddress类对象的域名。 String getHostAddress()//用于获取InetAddress类对象的IP地址 getLoaclHost()//获取一个含有本机域名和IP地址的InetAddress类实例

# 图形

## Graphics2D

### 功能

-   建立字体、设定显示颜色、显示图像的文本、绘制和填充各种几何图形
-   Graphics类的drawline(int x1,int y1,int x2,int y2)方法可以画一条线段

## Font

Font(String fontName，int style,int size),设置字体、风格、字号

### 属性

1.  stroke 该属性控制线条的宽度、笔形样式、线段连接方式或者短划线图案。
2.  paint 该属性控制填充效果

# C/S模式

IP地址和端口号的组合成为网络套接字(Socket)。 端口号0~1023供系统专用；端口号1024~65536供应用程序使用。 在Client端，Socket类支持网络的底层通信; 在Server端，ServerSocket支持底层的网络通信。 当Client程序需要和Server程序通信时，可以通过Socket类创建套接字对象实现通信连接。 双方实现通信的两种方式： 流式Socket => 面向有连接通信(TCP)，每次通信前需要建立连接，通信结束后需要断开连接。特点就是可以保证数据传输的正确性、可靠性。 数据报式Socket => 面向无连接通信(UDP)，将欲发送的数据分成小数据包，直接上网发送。特点是传输数据时无需建立和拆除连接，速度快，没有可靠性保证

# 未归类

1.  在Swing中，与JComponent类有直接父子关系的是JLabel。
2.  得到菜单项名称的方法是getLabel()。
3.  在访问数据库的程序中，建立statement对象后，利用该对象进行数据库更新，实现SQL数据库更新的方法是executeUpdate(). 4.
