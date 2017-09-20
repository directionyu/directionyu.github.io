---
title: Gradle入门
date: 2016-07-23T16:51:29.000Z
categories: Android
tag: Gradle
toc: true
---

# Gradle是什么

Gradle与Ant和Maven一样都是依赖管理/自动化项目构建工具，但是与后者不同的是使用名为Groovy的语言而不是xml来编写，xml虽然通俗易懂，但是很难描述if/else的关系，而Groovy没有这种顾虑，gradle完全兼容Maven和ivy. Gradle 中，每一个待编译的工程都叫一个Project。每一个Project在构建的时候都包含 一系列的Task。比如一个 Android APK 的编译可能包含：Java 源码编译 Task、资源编译 Task、JNI 编译 Task、lint 检查 Task、打包生成 APK 的 Task、签名 Task等。 一个 Project 到底包含多少个 Task，其实是由编译脚本指定的插件决定。插件是什么呢？ 插件就是用来定义 Task，并具体执行这些 Task 的东西。 刚才说了，Gradle 是一个框架，作为框架，它负责定义流程和规则。而具体的编译工作 则是通过插件的方式来完成的。比如编译 Java 有 Java 插件，编译 Groovy 有 Groovy 插件， 编译 Android APP 有 Android APP 插件，编译 Android Library 有 Android Library 插件。

# Groovy是什么

Groovy是一种动态语言，官方对其的定义是在Java平台上的、具有像Python、Ruby、Smalltalk语言特性的灵活性动态语言，Groovy保证了这些特性像Java语法一样使用，用大白话来说就是基于Java并扩展，使其编写起来像脚本一样，写完就跑，Groovy内部将其编译成字节码文件然后启动jvm来运行. Groovy还有一个特点就是它是一种DSL(Domain Specific Language)领域相关语言。

<!-- more -->

 # AndroidStudio为什么采用Gradle架构

更容易重用资源和代码; 可以更容易创建不同的版本的程序，多个类型的apk包； 更容易配置，扩大; 更好的IDE集成;

# Gradle基础

- Gradle与Maven一样有个配置文件，Maven是pom.xml而gradle是build.gradle.
- AndroidStudio中至少包含两个build.gradle文件，两者作用域不一样，一个是project,一个是module范围,Project与module是一对多的关系，每新加一个module则会有一个新的build.gradle创建出来.

  ## Gradle默认创建配置详解

- project的build.gradle

  ```
   buildscript {
    //构建进程依赖的仓库
       repositories {
           jcenter()
       }
       //构建进程需要依赖的库
       dependencies {
       //声明的是gradle插件的版本
           classpath 'com.android.tools.build:gradle:2.1.0'
       }
   }

   allprojects {
   //配置全部项目依赖的仓库,这样每一个module就不用配置仓库了
       repositories {
           jcenter()
       }
   }

   task clean(type: Delete) {
       delete rootProject.buildDir
   }
  ```

  _PS:为什么repositories要声明两次，实际上是因为作用不同，buildscript种的仓库是gradle脚本中所需要的资源，而allprojects下的仓库是项目中所有模块需要的资源_

- module下的build.gradle

  ```
       //声明插件，这是1个android程序，如果是android库,应当是com.android.library
       apply plugin: 'com.android.application'
       //安卓构建进程需要配置的参数
       android {
           //编译版本
           compileSdkVersion 23
           //buildtool版本
           buildToolsVersion "23.0.3"
           //默许配置，会同时利用到debug和release版本上
           defaultConfig {
               applicationId "com.roy.rutils"
               minSdkVersion 19
               targetSdkVersion 23
               versionCode 1
               versionName "1.0"
           }
           //这里面可以配置debug和release版本的1些参数，比如混淆、签名配置等
           buildTypes {
               release {
                   minifyEnabled false
                   //是不是开启混淆,混淆文件位置
                   proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
               }
           }
       }
       //模块依赖
       dependencies {
           compile fileTree(include: ['*.jar'], dir: 'libs')
           testCompile 'junit:junit:4.12'
           compile 'com.android.support:appcompat-v7:23.4.0'
           compile project(':rutils')
       }
  ```

- settings.gradle 这个文件是用来配置多模块的，比如你的项目有两个模块module-a,module-b,那末你就需要在这个文件中进行配置，格式以下： include ':module-a',':module-b'

- gradle文件夹 这里面有两个文件，gradle-wrapper.jar和gradle-wrapper.properties,它们就是gradle wrapper。gradle项目都会有，你可以通过命令gradle init来创建它们（条件是本地安装了gradle并且配置到了环境变量中）。

- gradlew和gradlew.bat 这分别是linux下的shell脚本和windows下的批处理文件，它们的作用是根据gradle-wrapper.properties文件中的distributionUrl下载对应的gradle版本。这样就能够保证在不同的环境下构建时都是使用的统一版本的gradle，即便该环境没有安装gradle也能够，由于gradle wrapper会自动下载对应的gradle版本。 gradlew的用法跟gradle一模一样，比如履行构建gradle build命令，你可以用gradlew build。gradlew即gradle wrapper的缩写。

- gradle仓库 gradle有3种仓库，maven仓库，ivy仓库和flat本地仓库。声明方式以下： maven{ url "..." } ivy{ url "..." } flatDir{ dirs 'xxx' } 有一些仓库提供了别名，可直接使用： repositories{ mavenCentral() jcenter() mavenLocal() }

## Gradle Task

- gradle中有1个核心概念叫任务，跟maven中的插件目标类似。
- gradle的android插件提供了4个顶级任务
- assemble 构建项目输出
- check 运行检测和测试任务
- build 运行assemble
- check clean 清算输出任务
- 履行任务可以通过gradle/gradlew+任务名称的方式执，履行1个顶级任务会同时履行与其依赖的任务，比如你履行gradlew assemble,它通常会履行:gradlew assembleDebug gradlew assembleRelease,这时候会在你项目的build/outputs/apk或build/outputs/aar目录生成输出文件

注：linux下履行构建任务需要首先更改gradlew脚本的权限，然后才能履行该脚本： chmod +x gradlew ./gradlew assemble 可以通过： gradlew tasks 列出所有可用的任务。在Android Studio中可以打开右边gradle视图查看所有任务。

## Gradle命令

## Gradle技巧

1. 导入本地jar包 跟eclipse不一样，android studio导入本地jar除将jar包放到模块的libs目录中之外，还得在该模块的build.gradle中进行配置，配置方式是在dependencies结点下进行以下声明：

  ```groovy
  compile files('libs/xxx.jar')
  ```

  如果libs下有多个jar文件，可以这样声明：

```groovy
compile fileTree(dir: 'libs', include: ['*.jar'])
```

1. 导入3方maven仓库 可能你项目需要的1些库文件是在你们公司的私服上，这时候候repositories中唯一jcenter就不行了，你还需要把私服地址配到里面来，注意，应当配到project的build.gradle中的allprojects结点下或直接配到某个模块中如果唯一这个模块用到。 配置方式：

  ```groovy
  repositories{ maven{ url="http://mvnrepo.xxx.com" } }
  ```

2. 加快Build速度，因为Gradle在构建生命周期中有三个阶段，每次执行任务时都需要经历着三个阶段。这虽然使得整个构建过程在每一个环节都可配置，但也导致了构建非常缓慢。

3. 将库项目导出为aar 首先你的项目必须是1个库项目，build.gradle中进行配置： apply plugin : 'com.android.library' 然后你可以在命令行中进到项目目录，履行以下gradle任务： gradlew assembleRelease//确保该目录下有gradlew文件 生成的aar在/build/output/aar文件夹中

# Gradle与Maven

在比较Gradle和Maven异同之前，先来想想我们为什么需要依赖管理这种方式。

## 为什么出现依赖管理工具

码农的世界里，项目开发时间一再的被Boss和项目经理压榨，用别人造出来的轮子造福自己，这种生产方式已经深入日常生活，项目简单的时候我们可以直接将轮子的源码放入项目中，或者将轮子的二进制文件(如jar等)放置在lib里，而项目复杂的时候，动不动依赖十几个轮子，轮子又依赖别人轮子，怎么检测轮子升级，怎么判断lib目录下是否有库正在被依赖着，这时候项目管理工具的重要就体现出来了，

## 假如我们自己需要设计一个项目依赖工具，怎么规划？

1. 命名规则或者坐标（Coordinates），一个依赖库需要定义一套标识它自己唯一的坐标，让别人能够迅速找到。
2. 存储空间，门牌号有了，接下来就需要一个具体房子装起来，这就是中心仓库的意义，同时提供使用者推拉的方式。
3. 配置文件，门牌号和地址都有了，就要有对应的配置文件规则，来描述定义库依赖。
4. 解析配置工具，使用者需要一个工具去解析配置文件，从而自动拉取仓库中的依赖库文件。

## Maven与Gradle依赖对比

- Maven最核心的改进就在于提出仓库这个概念。我可以把所有依赖的包，都放到仓库里去，在我的工程管理文件里，标明我需要什么什么包，什么什么版本。在构建的时候，maven就自动帮我把这些包打到我的包里来了。我们再也不用操心着自己去管理几十上百个jar文件了。
- Maven提出，要给每个包都标上坐标，这样，便于在仓库里进行查找。所以，使用maven构建和发布的包都会按照这个约定定义自己的坐标，例如：

```xml
<!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.1</version>
</dependency>
```

  我的工程要依赖gson，我们知道Gson仓库坐标com.google.code.gson:gson:2.8.1。那么maven就会自动去帮我把junit打包进来。如果我本地没有gson，maven还会帮我去网上下载。下载的地方就是远程仓库，我们可以通过repository标签来指定远程仓库。

> Maven的习惯是通过 groupID（一般是组织的域名倒写，遵循Java package的命名习惯）+ artifactId（库本身的名称） + version（版本）来定义坐标，通过xml来做配置文件，提供了中心仓库（repo.maven.org）以及本地工具（mvn）。



看起来不是很复杂吧，这只是一个依赖的配置，当一个项目中有多个依赖时，如下

```xml
<properties>
    <kaptcha.version>2.3</kaptcha.version>
</properties>

<dependencies>
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.8.1</version>
    </dependency>
    <dependency>
        <groupId>com.google.code.kaptcha</groupId>
        <artifactId>kaptcha</artifactId>
        <version>${kaptcha.version}</version>
        <classifier>jdk15</classifier>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-core</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-beans</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
    </dependency>
</dependencies>
````

而这些用Gradle来写

```groovy
dependencies {
    compile 'com.google.code.gson:gson:2.8.1'
    compile('org.springframework:spring-core:2.5.6')
    compile('org.springframework:spring-beans:2.5.6')
    compile('org.springframework:spring-context:2.5.6')
    compile('com.google.code.kaptcha:kaptcha:2.3:jdk15')
    testCompile('junit:junit:4.7')
}
```

## Gradle相对于Maven的改进

1. 配置语言 Maven使用的是xml语言，xml受限于语言本身，复杂的项目pom.xml会很繁杂，而Gradle基于Groovy定义的一中DSL语言，简洁并且表达能力强大。
2. 扩展插件 Maven中任何扩展功能都需要使用插件来实现，但是Gradle使用的Groovy可以依赖任何java库，直接在build.gradle中自定义task，可以直接获取Project对象以及环境变量，通过自定义task对build过程进行更精细的逻辑控制。
3. 任务依赖以及执行机制 Maven不鼓励你自定义任，Maven构建的生命周期每一步都是预先定义好的，插件任务只能在预留的生命周期中某个阶段切入，整个构建时只能严格的按照生命周期线性执行任务，而Gradle继承了maven中仓库，坐标，依赖这些核心概念，文件的布局也和maven相同。同时，它又继承了ant中target的概念创造出Task概念，使用了Directed Acyclic Graph（有向非循环图）来检测任务的依赖关系，决定哪些任务可以并行执行，这样的方式更为灵活。
4. 依赖管理 Maven对依赖管理比较严格，依赖必须是源码仓库的坐标，而Gradle比较灵活，支持多种集成三方库的方式，本地库，库工程，maven库全支持。同时针对Maven库的依赖能动态管理版本 拿gson库举例，如果依赖2.2.1这个版本，可以在build.gradle文件里这样写

  ```groovy
  dependencies {
    compile 'com.google.code.gson:gson:2.2.1'
  }
  ```

  如果不想依赖具体的库，想每次从maven repo中拉取最新的库，那么，可以写成这样：

  ```groovy
  dependencies {
    compile 'com.google.code.gson:gson:2.2.＋'
  }
  ```

  也可以写成这样

  ```groovy
  dependencies {
    compile 'com.google.code.gson:gson:2.＋'
  }
  ```

  甚至可以这样

  ```groovy
  dependencies {
    compile 'com.google.code.gson:gson:＋'
  }
  ```

  用"+"来通配一个版本族，这样有个好处是maven上有新库了，不用你操心升级，GRADLE编译的时候自动升级了，但是带来了两个坏处，一是，有可能新版库的接口改了，导致编译失败，这个时候需要修改代码做升级适配；更大的坏处是，每次GRADLE编译完整的项目，都会去maven上试图拉取最新的库，这样，拖慢了编译速度，尤其在网络非常差的时候，所以，为了构建速度，建议写死依赖库的版本号。
  
