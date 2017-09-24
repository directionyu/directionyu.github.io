---
title: Android 代码质量规范
date: ‎2016‎-05‎-‎25 16:09:05  
categories: Android   
tags:
  - Android
  - 代码规范
toc: true  
---

[Google Java编程风格指南传送门](http://www.hawstein.com/posts/google-java-style.html)

# 包名命名和分类
项目结构目录：
com.xxx.<项目名>.db 数据库相关

com.xxx.<项目名>.service 服务

com.xxx.<项目名>.reciver 广播接收者

com.xxx.<项目名>.constants 常量

com.xxx.<项目名>.utils 工具类

com.xxx.<项目名>.db	数据库操作

com.xxx.<项目名>.net 网络操作

com.xxx.<项目名>.view（或者.ui）	自定义的View类等

com.xxx.<项目名>.view 自定义组件

com.xxx.<项目名>.ui 界面

com.xxx.<项目名>.base 各种父类

<!--more-->
# 类命名规范
类（classes）：名词，采用大驼峰命名法，尽量避免缩写，除非该缩写是众所周知的，比如HTML，URL,如果类名称包含单词缩写，则单词缩写的每个字母均应大写。

# 变量命名规范
变量（variables）采用小驼峰命名法，类中控件名称必须与xml布局id保持一致。

公开的常量：定义为静态final，名称全部大写。
eg: public staticfinal String ACTION_MAIN=”android.intent.action.MAIN”;

静态变量：名称以s开头
eg：private static long sInstanceCount = 0;

非静态的私有变量protected的变量：以m开头，eg：private Intent mItent;


# 方法命名规范
方法（methods）：动词或动名词，采用小驼峰命名法，eg：onCreate(),run();

# 资源id命名规范
命名模式为：view缩写_模块名称_view的逻辑名称
view的缩写详情如下：


# 动画文件命名
动画文件（anim文件夹下）：全部小写，采用下划线命名法，加前缀区分。
//前面为动画的类型，后面为方向

# 布局文件名

activity_xxx.xml

fragment_xxx.xml

include_xxx.xml (被其他地方引用的布局)

item_xxx.xml (ListView 的 item 布局)

layout_xxx.xml (区块布局)

dialog_xxx.xml

ppw_xxx.xml(popwindow)


# 使用Javadoc标准注释
- 每个类以及重要的公共方法必须包含一个Javadoc注释，至少有一个句子描述这个类或方法是做什么的。这句话应该以第三人称描述。
- 不需要写Javadoc里不是很重要的get和set方法，比如你的Javadoc说“sets Foo”那就写setFoo()。如果该方法做更复杂的事情（如强制约束，或有重要的副作用），则必须将其记录下来。如果“Foo”的意思不是很明显，你应该将其记录下来。 你写的每一个方法都会受益于Javadoc。公共方法是一个API的一部分，因此需要Javadoc。

# 注释的规范书写
带参数描述的文档注释：

```
/**
* 设置姓名
* @param name 姓名
*/
```

不带参数的文档注释：

```
/** 我是注释 */
```

普通块注释：

```
/* 我是注释 */
```

普通的单行注释：

```
// 我是注释
```

# 写较短的方法
如果可能，使方法小而集中。我们认识到，较小的方法有时是合适的，所以没有硬性标准来限制方法的长度。如果一个方法超过40行左右，考虑是否可以重写，使之变短，并不损害程序的结构。

#在规定的地方定义字段
在方法使用字段之前，应在文件的顶端或中间来定义它们。

#限制变量的作用域
保持局部变量的使用范围最小。这样做可以增加代码的可读性和可维护性，降低出错的可能性。每个变量应该在使用其变量的最小代码块里定义。 局部变量应该在第一次使用它的时候声明。几乎所有的局部变量在声明时应包含一个初始化。如果你还没有足够的信息来合理地初始化变量，直到信息足够再来初始化。 try-catch语句是一个异常。如果一个变量由抛出checked异常方法的返回值进行初始化，它必须在try块内进行初始化。如果该值必须在try块的外部使用，那么它必须在try块前面定义

# 字段命名的约定
- 非public和static的字段用m开头.
- Static 的字段用s开头.
- 其他的字段用小写字母开头.
- Public static final 字段用ALLCAPSWITH_UNDERSCORES.

exp：
```
   public class MyClass {
        public static final int SOME_CONSTANT = 42;
        public int publicField;
        private static MyClass sSingleton;
        int mPackagePrivate;
        private int mPrivate;
        protected int mProtected;
    }
```
