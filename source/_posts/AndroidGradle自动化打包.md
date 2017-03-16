---
title: AndroidStudio Gradle 自动化打包
date: 2016-10-6 08:55:29   
categories: Android   
tag: 打包 
toc: true  
---

## Gradle打包优势
因为部门业务的性质，APP产品需要对应多个渠道，多个国家输出不同需求，甚至不同支付逻辑的Apk版本，以前部门为了应对需求，采用的策略是一个APP产品对应渠道，国家开多套源码的分支，每一次打包需求过来，不同分支的APP首先便是要升级SDK，然后可能会将一些在别的分支上已经实现的逻辑拷贝到这个分支上，目前部门的APP产品信息记录在禅道文档已经更新到了65个，而部门APP产品（星座、FC、LookerPlus、Wallpaper、WallpaperCutey、Gamebar、ToolBox、SmartLocker、AppLocker、电池卫视、内存医生、WiFi增强器VideoPlus）等十三个独立App，平均每个APP存在6个版本的源码，除去破解产品本身特殊没办法统一源码，正式自研产品的版本也相当之多，现在每次打包拉源代码分支、替换包名、更换各项ID、升级SDK、测试等流程走一遍平均需要4小时左右，效率比较低下，也比较容易疏忽出错。而AndroidStudio Gradle打包方式能够实现一个自研App产品维护一套源码，输出多个渠道、用途的Apk包，能极大提升开发打包的效率、减少出错的可能性。

<!--more-->

## Gradle打包能够实现什么
1. 能够输出多渠道、多国家版本。
2. 针对性的输出Debug、dev版本、收费免费版本，输出的包名不一致能够同时安装到手机上测试。
3. 请求Api与Sandbox不同的服务器接口，例如Wallpaper和WallpaperCutey请求不同的图片资源接口。
4. 不同apk需要应用名不同，图标不同，某些常量不同。

## Gradle基本概念
* Gradle是一种依赖管理工具，基于Groovy语言，面向Java应用为主，它抛弃了基于XML的各种繁琐配置，取而代之的是一种基于Groovy的内部领域特定（DSL）语言。
* 在build.gradle(modul)文件的android节点下defaultConfig属性下定义默认项目配置
* gradle使用applicationId属性来配置manifest中的packageName属性，目的是为了消除在App包名与java包名相似引起的混乱。
* gradle构建是动态的，可以从自定义的逻辑代码中读取App版本信息

## 通过Gradle导入第三方依赖项目优势
* gradle导入jar包更方便，一行代码即可搞定。不像后者那样还要自己去官方下载。
* 如果官方将jar包更新了，我们只需要在build.gradle中改一下版本号就行了，不用重新去官网下载。
* jcenter可以理解成是一个新的中央远程仓库，兼容maven中心仓库，而且性能更优，所有通过gradle导入的jar包都是从http://bintray.com/bintray/jcenter 这个中央仓库上扒下来的。如果你需要的jar包在这个网站上没有，那就无法通过gradle的方式来导入，还需以前一样自行加入到项目中并依赖。

## 签名打包的两种方式
1. 通过Android Studio进行签名
2. 通过命令行的方式进行签名

## BuildType（构建类型）
AndroidStudio创建新工程时默认会给工程自动构建工程的debug和release版本，Android plugin允许像创建其他构建类型一样定制debug和release实例，这需要在buildTypes的DSL容器中配置：
```
android {
    buildTypes {
        debug {
            applicationIdSuffix ".debug"
        }
        jnidebug.initWith(buildTypes.debug)
        jnidebug {
            packageNameSuffix ".jnidebug"
            jnidebugBuild true
        }
    }
}
```
以上代码片段实现了以下功能：
* 配置默认的debug构建类型：将debug版本的包名设置为<app package>.debug以便能够同时在一台设备上安装debug和release版本的apk。
* 创建了一个名为“jnidebug”的新构建类型，并且这个构建类型是debug构建类型的一个副本。
* 继续配置jnidebug构建类型，允许使用JNI组件，并且也添加了不一样的包名后缀。

创建一个新的构建类型就是简单的在buildType标签下添加一个新的元素，并且可以使用initWith()或者直接使用闭包来配置它。

以下是一些可能使用到的属性和默认值：


Property name	|Default values for debug	|Default values for release/other
------------------------|-----------------------------------|-----------------------
debuggable    			|debuggable    						|false
jniDebugBuild    		|false								|false
renderscriptDebugBuild  |false								|false
renderscriptOptimLevel  |3									|3
packageNameSuffix    	|null								|null
versionNameSuffix    	|null								|null
signingConfig    		|android.signingConfigs.debug		|null
zipAlign    			|false    							|true
runProguard    			|false								|false
proguardFile    		|N/A (set only)						|N/A (set only)
proguardFiles    		|N/A (set only)						|N/A (set only)

除了以上属性之外，Build Type还会受项目源码和资源影响：
对于每一个Build Type都会自动创建一个匹配的sourceSet。默认的路径为：`src/<buildtypename>/  `
这意味着BuildType名称不能是main或者androidTest（因为这两个是由plugin强制实现的），并且他们互相之间都必须是唯一的


## ProductFlavors（不同定制的产品）
一个product flavor定义了从项目中构建了一个应用的自定义版本。一个单一的项目可以同时定义多个不同的flavor来改变应用的输出。

*注意：flavor的命名不能与已存在的Build Type或者androidTest这个sourceSet有冲突。*

Product flavor需要在productFlavors这个DSL容器中声明：
```
 productFlavors {
        gpInter {
        }

        ngpPackage {
        }
```


## 配置不同包名&&控制不同渠道变量

```

 productFlavors {

        gpInter {
            applicationId "com.gkt.wowgames"
            manifestPlaceholders = [PUSH_APP_ID: "app_gkt_gamebar_all_7328", PUSH_APP_SECRET: "a8204a34bd0b", ANALYTICS_ID: "UA-74197659-4", FB_ID: "1057899667608168"]
            buildConfigField("boolean", "use_facebook", "true")
            buildConfigField("boolean", "use_adjust", "false")
        }

        ngpPackage {

            applicationId "com.gkt.wowgames.ngp"
            versionCode 1
            versionName "1.0.0"
            manifestPlaceholders = [PUSH_APP_ID: "app_gkt_gamebar_all_sg_1007", PUSH_APP_SECRET: "9ee9422f9e03", ANALYTICS_ID: "UA-74197659-10",FB_ID: "1057899667608168"]
            buildConfigField("boolean", "use_facebook", "false")
            buildConfigField("boolean", "use_adjust", "true")
        }
```

## 使用不同应用名

## 使用不同的Manifest

Manifest可以通过Merge的方式合并多个Manifest源。通常来说，有三种类型manifest文件需要被merge到最终的结果apk，下面是按照优先权排序：



1. productFlavors和buildTypes中指定的manifest.xml

2. 应用主manifest.xml

3. 库manifest





Merge的方式是指将manifest中每个元素和子元素的节点属性进行合并，Gradle提供manifestPlaceholders属性，可以在AndroidManifest中定义一个变量，在build.gradle中动态的替换掉

example：

```

  manifestPlaceholders = [PUSH_APP_ID: "app_gkt_gamebar_all_7328", PUSH_APP_SECRET: "a8204a34bd0b", ANALYTICS_ID: "UA-74197659-4", FB_ID: "1057899667608168"]

```

```
        <meta-data
            android:name="Push_AppId"
            android:value="${push_app_id}" />
        <meta-data
            android:name="Push_AppSecret"
            android:value="${push_app_secret}" />
        <meta-data
            android:name="com.facebook.sdk.ApplicationId"
            android:value="${FB_ID}" />
        <meta-data
            android:name="AnalyticsTrackId"
            android:value="${ANALYTICS_ID}" />
```

## 配置不同Icon







## 配置不同信鸽ID

```
        <action android:name="${applicationId}.PUSH_ACTION" />
```

## Sourcesets and Dependencies（源组件和依赖关系）

与Build Type类似，Product Flavor也会通过它们自己的sourceSet提供代码和资源。

上面的例子将会创建4个sourceSet

* android.sourceSets.flavor1：位于src/flavor1/
* android.sourceSets.flavor2：位于src/flavor2/
* android.sourceSets.androidTestFlavor1：位于src/androidTestFlavor1/
* android.sourceSets.androidTestFlavor2：位于src/androidTestFlavor2/

这些sourceSet用于与android.sourceSets.main和Build Type的sourceSet来构建APK。

下面的规则用于处理所有使用的sourceSet来构建一个APK：

* 多个文件夹中的所有的源代码（src/../java）都会合并起来生成一个输出。
* 所有的Manifest文件都会合并成一个Manifest文件。类似于Build Type，允许Product Flavor可以拥有不同的的组件和权限声明。
* 所有使用的资源（Android res和assets）遵循的优先级为Build Type会覆盖Product Flavor，最终覆盖main sourceSet的资源。
* 每一个Build Variant都会根据资源生成自己的R类（或者其它一些源代码）。Variant互相之间没有什么是共享的。

最终，类似Build Type，Product Flavor也可以有它们自己的依赖关系。例如，如果使用flavor来生成一个基于广告的应用版本和一个付费的应用版本，其中广告版本可能需要依赖于一个广告SDK，但是另一个不需要。

## Build Type  + Product Flavor = Build Variant（构建类型+定制产品=构建变种版本）
* 每一个Build Type都会生成一个新的APK.
* Product Flavor同样也会做这些事情：项目的输出将会拼接所有可能的Build Type和Product Flavor（如果有Flavor定义存在的话）的组合。
* 每一种组合（包含Build Type和Product Flavor）就是一个Build Variant（构建变种版本）。

## Gradle SDL 属性分析
Android plugin提供了大量DSL属性用于直接从构建系统定制大部分操作。

Name                          |介绍
------------------------------|----------------------------------------------------
defaultConfig{}               |默认配置，是ProductFlavor类型。它共享给其他ProductFlavor使用
sourceSets{}				  |源文件目录设置，是AndroidSourceSet类型。
buildTypes{ }				  |BuildType类型
signingConfigs{ }             |签名配置，SigningConfig类型
productFlavors{ }             |产品风格配置，ProductFlavor类型
testOptions{ }                |测试配置，TestOptions类型
aaptOptions{ }                |aapt配置，AaptOptions类型
lintOptions{ }                |lint配置，LintOptions类型
dexOptions{ }                 |dex配置，DexOptions类型
compileOptions{ }             |编译配置，CompileOptions类型
packagingOptions{ }           |PackagingOptions类型
jacoco{ }                     |JacocoExtension类型。 用于设定 jacoco版本
splits{ }                     |Splits类型

