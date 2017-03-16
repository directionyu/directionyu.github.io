---
title: Gradle入门到精通
date: 2016-07-23 16:51:29   
categories: Android   
tag: Gradle 
toc: true  
---


## Gradle是什么
Gradle与Ant和Maven一样都是依赖管理/自动化项目构建工具，但是与后者不同的是使用名为Groovy的语言而不是xml来编写，xml虽然通俗易懂，但是很难描述if/else的关系，而Groovy没有这种顾虑，gradle完全兼容Maven和ivy.

## Groovy是什么
Groovy是一种动态语言，官方对其的定义是在Java平台上的、具有像Python、Ruby、Smalltalk语言特性的灵活性动态语言，Groovy保证了这些特性像Java语法一样使用，用大白话来说就是基于Java并扩展，使其编写起来像脚本一样，写完就跑，Groovy内部将其编译成字节码文件然后启动jvm来运行.
Groovy还有一个特点就是它是一种DSL(Domain Specific Language)领域相关语言。

<!--more-->

## AndroidStudio为什么采用Gradle架构
更容易重用资源和代码;
可以更容易创建不同的版本的程序，多个类型的apk包；
更容易配置，扩大;
更好的IDE集成;
## Gradle基础
- Gradle与Maven一样有个配置文件，Maven是pom.xml而gradle是build.gradle.
- AndroidStudio中至少包含两个build.gradle文件，两者作用域不一样，一个是project,一个是module范围,Project与module是一对多的关系，每新加一个module则会有一个新的build.gradle创建出来.
## Gradle默认创建配置详解
1. project的build.gradle
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

    *PS:为什么repositories要声明两次，实际上是因为作用不同，buildscript种的仓库是gradle脚本中所需要的资源，而allprojects下的仓库是项目中所有模块需要的资源*

2. module下的build.gradle

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
3. settings.gradle
这个文件是用来配置多模块的，比如你的项目有两个模块module-a,module-b,那末你就需要在这个文件中进行配置，格式以下：
include ':module-a',':module-b'

4. gradle文件夹
这里面有两个文件，gradle-wrapper.jar和gradle-wrapper.properties,它们就是gradle wrapper。gradle项目都会有，你可以通过命令gradle init来创建它们（条件是本地安装了gradle并且配置到了环境变量中）。

5. gradlew和gradlew.bat
这分别是linux下的shell脚本和windows下的批处理文件，它们的作用是根据gradle-wrapper.properties文件中的distributionUrl下载对应的gradle版本。这样就能够保证在不同的环境下构建时都是使用的统一版本的gradle，即便该环境没有安装gradle也能够，由于gradle wrapper会自动下载对应的gradle版本。
gradlew的用法跟gradle一模一样，比如履行构建gradle build命令，你可以用gradlew build。gradlew即gradle wrapper的缩写。

6. gradle仓库
gradle有3种仓库，maven仓库，ivy仓库和flat本地仓库。声明方式以下：
maven{ url "..." } ivy{ url "..." } flatDir{ dirs 'xxx' }
有一些仓库提供了别名，可直接使用：
repositories{ mavenCentral() jcenter() mavenLocal() }

## Gradle Task
- gradle中有1个核心概念叫任务，跟maven中的插件目标类似。
- gradle的android插件提供了4个顶级任务
- assemble 构建项目输出 
- check 运行检测和测试任务 
- build 运行assemble
- check clean 清算输出任务
- 履行任务可以通过gradle/gradlew+任务名称的方式执，履行1个顶级任务会同时履行与其依赖的任务，比如你履行gradlew assemble,它通常会履行:gradlew assembleDebug gradlew assembleRelease,这时候会在你项目的build/outputs/apk或build/outputs/aar目录生成输出文件

注：linux下履行构建任务需要首先更改gradlew脚本的权限，然后才能履行该脚本：
chmod +x gradlew ./gradlew assemble
可以通过：
gradlew tasks
列出所有可用的任务。在Android Studio中可以打开右边gradle视图查看所有任务。

## Gradle命令

## Gradle技巧
1. 导入本地jar包
跟eclipse不太1样，android studio导入本地jar除将jar包放到模块的libs目录中之外，还得在该模块的build.gradle中进行配置，配置方式是在dependencies结点下进行以下声明：
compile files('libs/xxx.jar')
如果libs下有多个jar文件，可以这样声明：
compile fileTree(dir: 'libs', include: ['*.jar'])

2. 导入3方maven仓库
可能你项目需要的1些库文件是在你们公司的私服上，这时候候repositories中唯一jcenter就不行了，你还需要把私服地址配到里面来，注意，应当配到project的build.gradle中的allprojects结点下或直接配到某个模块中如果唯一这个模块用到。
配置方式：
repositories{ maven{ url="http://mvnrepo.xxx.com" } }

3. 导入某个project
4. 将库项目导出为aar
首先你的项目必须是1个库项目，build.gradle中进行配置：
apply plugin : 'com.android.library'
然后你可以在命令行中进到项目目录，履行以下gradle任务：
gradlew assembleRelease//确保该目录下有gradlew文件
生成的aar在/build/output/aar文件夹中