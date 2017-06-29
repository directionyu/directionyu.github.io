---
title: GitHub常用框架记录
date: 2017-06-29 11:43:42
categories: Github
tag: 'Github'
toc: true
---

# 网络

## Retrofit

一句话介绍：Retrofit是一款类型安全的网络框架，基于HTTP协议，服务于Android和java语言

上榜理由：Retrofit以21.8k的stars量雄踞github中android子标题榜首，第一当之无愧。

官网地址 <http://square.github.io/retrofit/>

github <https://github.com/square/retrofit>

作者：square团队

## okhttp

一句话介绍：okhttp是一款基于HTTP和HTTP2.0协议的网络框架，服务于java和android客户端

上榜理由，okhttp以20.4k的stars量雄踞github中android子标题第二名。大型公司比如淘宝也封装的是okhttp。Retrofit2.0开始内置okhttp框架，Retrofit专注封装接口完成业务需求，okhttp专注网络请求的安全高效，笔者将两者区分开，是想让后来学习者知道，这是两套框架，学习框架原理时可以分开学习，以免理解混乱。

官网地址 <http://square.github.io/okhttp/>

github <https://github.com/square/okhttp>

作者：square团队

## fastjson

一句话介绍:一款基于json解析、生成的框架

上榜理由：从它的名字不难看出，快速是它最大的特性，阿里巴巴的出身保证了代码的质量和优越，9.4k的star数量，也是榜单里第一个出现的中国开源框架，涉及网络的app都会用到json，fastjson值得作为你的首选！

github <https://github.com/alibaba/fastjson>

作者：alibaba

# 通信

## RxAndroid

一句话介绍：一款Android客户端组件间异步通信的框架

上榜理由：github上12.7k个star，位居组件通信框架的第二名，仅在EventBus之后，如果要问两者的区别，Eventbus是用来取代组件间繁琐的interface，RxAndroid是用来取代AnsyTask的，并不冲突；当然RxAndroid的优点并不仅限于此，更多优雅的实现，可以去官网查阅！

github <https://github.com/ReactiveX/RxAndroid>

作者 JakeWharton

## RxJava-Android-Samples

一句话介绍：一款介绍RxJava使用场景的app

上榜理由：榜单出现的第一个"仅仅为告诉你如何使用另一个项目"的开源项目，它可以说是RxJava的用例，你想得到的想不到的RxJava用法这里都有，这就是为什么它以5.2k个star矗立在这份榜单里的原因。遗憾自己没有创作这么一个受人追捧的demo？赶快动手写个其他的"XX项目用例吧"

github <https://github.com/kaushikgopal/RxJava-Android-Samples>

作者：kaushikgopal

## RxLifecycle

一句话介绍：一款提供在使用RxJava过程中管理Activity和Fragment生命周期能力的框架

上榜理由：在榜单靠前的部分，你已经了解RxJava和RxAndroid的强大之处，但部分粗心的开发者因为没有及时取消订阅而产生严重的内存泄漏，不要担心，RxLifecycle可以为你解决难题，在gtihub上拥有3.7K个star，国内知名软件----知乎和淘宝也都在使用它

github <https://github.com/trello/RxLifecycle>

作者：trello团队

## JsBridge

一句话介绍：一款提供WebView和Javascript通信能力的框架

上榜理由：该框架提供给了允许H5页面调用通过JS调用App方法的能力；3.1K个star，简洁的通讯方式，值得每一个Web\Hybrid App开发者尝试

gtihub <https://github.com/lzyzsd/JsBridge>

作者：hi大头鬼hi

# 图片处理

## glide

一句话介绍：glide是一款专注于提供流畅划动能力的"图片加载和缓存框架"

上榜理由：15.9k个star，图片加载类框架排名第一的框架，google 在2014开发者大会上演示的camera app就是基于gilde框架开发的

github <https://github.com/bumptech/glide>

作者 Bump Technologies团队

## fresco

一句话介绍：一款可以管理图片内存的框架

上榜理由:github上12.8k个star，图片类排行榜第四名，facebook的出身证明了它并非是重复造的轮子，在管理图片内存领域上有着它的一片天地，渐进式加载、加载gif都是它与前三位相比独有的特性

官网地址： <https://www.fresco-cn.org/>

github <https://github.com/facebook/fresco>

作者 facebook

## PhotoView

一句话介绍：一款ImageView展示框架，支持缩放，响应手势

上榜理由：10.3k的star数量，位于图片类框架排行榜第五位，PhotoView与前四位不同的是这次带来的是图片的展示能力，你一定好奇微信的头像点击放大是如何实现的，很多App的图片显示响应手势按压是如何实现的，了解PhotoView，你一定会开心的！（笔者也不会告诉你ImageView的点击放大效果在Android的sample也有）

github <https://github.com/chrisbanes/PhotoView>

作者：chrisbanes

## uCrop

一句话介绍：一款优雅的图片裁剪框架

上榜理由：5.3K个star，图片编辑模块单独拎出来也是一款优雅的App。

github <https://github.com/Yalantis/uCrop>

作者：Yalantis

## Luban

一句话介绍：最接近微信的图片压缩框架

上榜理由：好的思路总是可以让你大放异彩，Luban仅以图片压缩单一功能，俘获了4.8K个star，证明了它在图片压缩上的造诣，它可能不是最优秀的，但它是让你我最接近伟大的项目

github <https://github.com/Curzibn/Luban>

作者：Curzibn

# 自定义View

## AndroidAutoLayout

一句话介绍：一个提供适配能力的框架

上榜理由：5.2K个star，鸿洋老弟的作品，适合小项目的开发团队，拿到设计MM的px像素设计稿是不是很头疼捏？这个框架一键式搞定你的问题，它有很多的不足，但在追求完美适配的路上，你值得探索和了解它！笔者并不推荐把它应用到已经成熟运行的项目中，毕竟市面上已经有太多的适配解决方案了，适配问题就像是个大杂烩，想炒一盘好菜，就得备好各种佐料（适配小方案），当你把各种小佐料用的炉火纯青的时候，你离美食大厨就不远了。

github <https://github.com/hongyangAndroid/AndroidAutoLayout>

作者：张鸿洋

## material-dialogs

一句话介绍：一款自定义dialog框架

上榜理由：9.9k个star，也是继PhotoView，SlidingMenu之后第三款自定义View框架，也许你还是自定义View的新人，对Dialog使用的还有点生疏，你可以通过它提升你的Dilaog使用能力

github <https://github.com/afollestad/material-dialogs>

作者：Aidan Follestad

## BaseRecyclerViewAdapterHelper

一句话介绍：强大、流畅的Recyvlerview通用适配器

上榜理由：如果你是RecyclerView的拥簇者，你一定要体验这款专门服务该view的适配器，7.7K个star，让这个家伙位于github上Android 适配器排行榜第一，还有很多惊喜等你去探寻！

官网地址：<http://www.recyclerview.org/>

作者：陈宇明以及他的小伙伴

## AndroidSwipeLayout

一句话介绍：非常强大滑动式布局

上榜理由:滑动删除是国产app常见需求，商品详情的上下滑动需求作为开发者的我们也经常遇到，AndroidSwipeLayout在github上拥有8K个star，证明它经受住了检验，各位值得一试

github <https://github.com/daimajia/AndroidSwipeLayout>

作者：daimajia

## CircleImageView

一句话介绍：圆角ImageView

上榜理由：也许你已经听说过无数种展示圆角图片的方法，但如果你不尝试尝试CircleImageView，那么你的知识库会因为少了它黯然失色，有的时候完成需求是开发者优先考虑的，不同实现方法牵扯到的性能差异更值得让人深思，如果你有心在图片性能上有所涉猎，那么CircleImageView绝对不会让你败兴而归。最后别忘了记得去看Romain Guy的建议哟。

github <https://github.com/hdodenhof/CircleImageView>

作者：Henning Dodenhof

## BottmBar

一句话介绍：一款底部导航栏视图框架

上榜理由：底部栏里的王者框架，6.3K的star数量，证明了它的优秀，完全遵循材料设计规范，上手非常方便。如果说缺点，无法设置icon与titile的间距，无法自定义视图的大小等，但这些都可以通过修改源代码解决，笔者献丑也修改了一套符合国内开发者的底部导航框架，即将开源。

github <https://github.com/roughike/BottomBar>

## Calligraphy

一句话介绍：一款自定义字体框架

上榜理由：如果你还在为一键修改App内所有字体样式而烦恼，6.3K个star的Calligraphy就值得你拥有，它可以同时修改整个整个项目的Textview字体，也可以单独 设置某个Textview的字体，还在等什么，快来试试吧！

github <https://github.com/chrisjenx/Calligraphy>

作者：Christopher Jenkins

## AndroidSlidingUpPanel

一句话介绍：可拖动的滑动面板视图框架

上榜理由：如果你的项目需要一个可拖拽的滑动式面板（展示某些详情信息，播放音乐，地图信息等），那么推荐你使用它，6.3k个star，来自创业公司umano的作品，证明它是用心推出的杰作

github <https://github.com/umano/AndroidSlidingUpPanel>

作者：umano

## AppIntro

一句话介绍：一款提供快速制作欢迎页的框架

上榜理由：笔者从未把打算把欢迎页框架纳入排行榜当中，作为国内开发者，ViewPager开发App的欢迎页已经是手到擒来的需求，为何一个开源的欢迎页框架会在github上拥有6.3k个star？也许你会不屑一顾，是的，往往就在不屑一顾的瞬间，机遇就悄悄溜走了。

github <https://github.com/apl-devs/AppIntro>

## FlycoTabLayout

一句话介绍：一款可以让作出多种多样指示器效果的框架

上榜理由：尽管我们没有理由为了给app加入页面指示器功能就集成2.5M的依赖库，但是作为了解viewpager或swip views的指示器设计原理的优秀框架，你值得打开它试试，笔者建议单独拆分所需源码，加入到自己的项目中去。4.1K个star，二次开发的作品，仍然推荐！

github <https://github.com/H07000223/FlycoTabLayout>

作者：Flyco

# 注解绑定

## Butter Knife

一句话介绍：Butter Knife所提供了一种能力----使用注解生成模板代码，将view与方法和参数绑定。

上榜理由：github上16.5K个star，配合Androidstudio提供的Butter Knife插件，帮助开发者省却了频繁findviewbyid的烦恼，最新的Butter Knife还提供了onclick绑定以及字符串的初始化，初学者可以查阅Butter Knife以及Butter Knife插件进一步学习！

官网地址：<http://jakewharton.github.io/butterknife/>

github：<https://github.com/JakeWharton/butterknife>

作者：JakeWharton ，也是square团队成员之一

## dagger

一句话介绍：一款通过依赖注入降低程序间耦合的开发框架

上榜理由：github 上dagger1版本 有6.2k个star ， dagger2版本有7.3k个；由square完成的dagger1版本，到如今google团队接手的dagger2版本，强力开发团队保证了代码在设计上的优越性；如果你想探究Android 领域的设计模式，这也是不错的选择。

官网地址：<https://google.github.io/dagger/>

github ：<https://github.com/google/dagger>

作者：google

## RxBinding

一句话介绍：一款提供UI组件事件响应能力的框架

上榜理由：如果你还未开始RxAndroid 之旅，RxBinding可以作为你的第一站，通过RXBinding，你将理解响应式编程的快乐，让项目里的事件流程更清晰。5.6K个star，RxAndroid作者亲自操刀，快来试用吧！

github <https://github.com/JakeWharton/RxBinding>

作者：JakeWharton

# 动画

## lottie-android

一句话介绍：一款可以在Android端快速展示Adobe Afeter Effect（AE）工具所作动画的框架

上榜理由：动画类框架第一名，github上13.3k个star证明了他的优越性，利用json文件快速实现动画效果是它最大的便利，而这个json文件也是由Adobe提供的After Effects（AE）工具制作的，在AE中装一个Bodymovin的插件，使用这个插件最终将动画效果生成json文件，这个json文件即可由LottieAnimationView解析并生成绚丽的动画效果。而且它还支持跨平台哟。

github <https://github.com/airbnb/lottie-android>

作者：Airbnb 团队

## Material-Animations

一句话介绍：一款提供场景转换过渡能力的动画框架

上榜理由：Android动画框架排行榜第二名，9.3k个star数量，与动画框架榜单第一名lottie-android不同的是，Material-Animations提供的是场景切换的动画效果。Android 官网sample中已经提供了部分Transition （转场动画）的展示，作为初学者很难快速拓展到自己项目中，Material-Animations的示例出现为开发者省去了此类麻烦，直接照搬应用到自己的App中吧。

github <https://github.com/lgvalle/Material-Animations>

作者：Luis G. Valle

## AndroidViewAnimations

一句话介绍：一款提供可爱动画集合的框架

上榜理由：正如作者所说，它囊括了开发需求过程中所有的动画效果，集成进了这个简洁可爱的动画框架。7.6K的star数，证明了它在动画框架领域的战斗力，让它仅仅位列lottie-android和Material-Animations两个动画框架霸主之后，屈居第三名

github <https://github.com/daimajia/AndroidViewAnimations>

作者：daimajia

## XhsEmoticonsKeyboard

一句话介绍：最开心的开源表情解决方案

上榜理由：如果你还在发愁如何为你的APP自制键盘，那么此框架非常适合你，而且还提供表情包展示能力，1.7个star证明了它的独特。此外作者还附赠了高仿微信键盘，QQ键盘的demo，分享给诸位

github <https://github.com/w446108264/XhsEmoticonsKeyboard>

作者：zhongdaxia

# 图表

## MPAndroidChart

一句话介绍：MPAndroidChart是一款图表框架

上榜理由：github上16.1K个star，以快速、简洁。强大著称的图表框架

官网地址 <https://github.com/PhilJay/MPAndroidChart>

github <https://github.com/PhilJay/MPAndroidChart>

作者：PhilJay

# 数据库

## realm-java

一句话介绍：Realm是一款移动端数据库框架

上榜理由：核心数据引擎C++打造，比普通的Sqlite型数据库快的多。笔者猜测正是如此，realm以7892个star数让它位于大名鼎鼎的数据库框架GreenDao（7877）之前

官网地址：<https://realm.io/cn/>

github <https://github.com/realm/realm-java>

作者：Realm团队

使用：<https://realm.io/docs/java/latest/>

# 调试

## leakcanary

一句话介绍：一款内存检测框架，服务于java和android客户端

上榜理由：方便，简洁是leakcanary最大的特点，只需在应用的apllication中集成，就可以直接使用它；15.5k个star说明了它有多么受欢迎

github <https://github.com/square/leakcanary>

作者 square团队

## stetho

一句话介绍：一款提供在Chrome开发者工具上调试Android app能力的开源框架

上榜理由：上古时期Android程序员要调试本地数据库，需要进入Android Device Monitor找到/data/data/com.xxx.xxx/databases里面的db文件，导出到PC端，用PC的数据工具查看，现在使用stetho省却了如此的麻烦；如今的Android程序员如果想调试网络请求响应过程中的报文段，需要在请求中加入Log语句，一个信息一个信息打印出来，相当繁琐，现在请使用stetho，省却诸如此类的麻烦把！7.8K个star数，广大Android开发者调试的福音，你值得拥有！

作者：FaceBook

官网地址： <http://facebook.github.io/stetho/>

github <https://github.com/facebook/stetho>

## logger

一句话介绍：一款让log日志优雅显示的框架

上榜理由：logger作为调试框架，并未给出很强大的能力，它最大的亮点是优雅的输出log信息，并且支持多种格式：线程、Json、Xml、List、Map等，如果你整日沉迷于汪洋大海般的log信息不能自拔，logger就是你的指路明灯！6.6k个star让他位列调试框架第二名，屈居facebook的stetho之后

github <https://github.com/orhanobut/logger>

作者：Orhan Obut

# 热修复

## tinker

一句话介绍：它是微信官网的Android热补丁解决方案

上榜理由：9.1k个star，微信在用的热补丁方案，心动不如行动

官网地址 <http://www.tinkerpatch.com/Docs/intro>

github <https://github.com/Tencent/tinker>

作者：Tencent

## DroidPlugin

一句话介绍：一款热门的插件化开发框架 上榜理由：4.8K个star，插件化框架榜单第一名，，360团队出品，框架质量有保证，有成功案例----360手机助手，并且持续维护着 github <https://github.com/DroidPluginTeam/DroidPlugin/blob/master/readme_cn.md> 作者：Andy Zhang

# 框架&架构

## mosby

一句话介绍：一款提供构建MVP项目能力的框架

上榜理由：榜单靠前的部分已经介绍了MVC,MVVM,MVP的框架项目，想必此时你在构建企业项目架构上，选择或者开发一款合适的MVP框架迫在眉睫，mosby可以作为你的第一步参考，你可以封装它，也可以照抄它，无论如何，3.4K个star，证明了它在框架设计上有多受开发者的喜爱

github <https://github.com/sockeqwe/mosby>

作者：Hannes Dorfmann

## Small

一句话介绍：轻巧的插件化框架

上榜理由：作为插件框架榜单的新成员，Small的优点是轻巧，适合作为小团队的插件开发方案，3.1K个star，让它获得了酷狗音乐等著名开发团队的青睐，如果你们的团队想逐步实施插件化开发，Small是个不错的选择！

官网地址：<http://code.wequick.net/Small/cn/cases>

github <https://github.com/wequick/Small>

作者：wequick 团队

## dynamic-load-apk

一句话介绍：插件化开发框架

上榜理由：4.5k个star，位于插件化开发框架第二名（第一名来自360团队），全面的文档介绍让你很快就能上手插件化开发，如果你喜欢大段文字讲解，那么这个项目一定适合你

github：<https://github.com/singwhatiwanna/dynamic-load-apk>

作者：singwhatiwanna

## Android-CleanArchitecture

一句话介绍：一个讲解设计框架的demo

上榜理由：它不是框架，你可以把它当作一本书，它将教会你如何设计简洁的架构，工程里有一个sample app，配合图文讲解，你将对Android客户端的架构有更深一层的认识。8.8k的star数量，证明了它是一本"好书"哟。

github <https://github.com/android10/Android-CleanArchitecture>

作者：Fernando Cejas

## atlas

一句话介绍：淘宝推出的组件化开发框架

上榜理由：淘宝团队所出的精品，atlas框架提供了解耦、组件、动态的开发能力，4.5k个star让他位列组件化开发框架第一名

github <https://github.com/alibaba/atlas>

作者：alibaba

# 权限

## PermissionsDispatcher

一句话介绍：一款基于注解的提供解决运行时危险权限方案的框架 上榜理由：自Android6.0 Google提出危险权限一词起，用户安全性被提到一定的高度，一些运行时对用户较为危险的权限将不再自动被开发者获取，需要经过用户批准，开发者才可以继续使用该权限，如果你曾经被权限问题搞的抓耳挠腮，建议你试试这个框架，它足够解决你的问题 官网地址：<https://hotchemi.github.io/PermissionsDispatcher/> github <https://github.com/hotchemi/PermissionsDispatcher> 作者：Shintaro Katafuchi

## RxPermissions

一句话介绍：一款基于RxJava完成权限申请的框架 上榜理由：榜单里第二款提供权服务的框架，基于RxJava的设计，让你可以专心写业务，3.7K个star已经证明了它的实用价值 github <https://github.com/tbruyelle/RxPermissions> 作者：Thomas Bruyelle

# 自动化测试

## android-testing

一句话介绍：一款展示四大自动化测试框架用例的demo（Espresso，UiAutomator，AndroidJunitRunner，JUnit4）

上榜理由：学习者经常会陷入似懂非懂的境地，如果你有幸学习过Android Testing Support Library site的课程，那么你一定对android的四大测试框架迫不及待，这款demo非常适合你，快来学习这个4.1k个star的明星项目吧

github <https://github.com/googlesamples/android-testing>

作者：googlesampes团队

# 下载

## FileDownloader

一句话介绍：一款高效、稳定、灵活、易用的文件下载引擎

上榜理由：4.1k证明了它有多受人喜爱，文件下载看似简单的背后暗藏了多少的坑坑点点，我知道你有能力自己实现文件下载功能，但优秀的框架可以提升你的设计编码能力，这款框架可以提升你的实力！

github <https://github.com/lingochamp/FileDownloader>

作者:LingoChamp团队

# 视频

# 缓存

## DiskLruCache

一句话介绍：一款提供磁盘文件缓存管理能力的框架

上榜理由：3.7k个star并不足以说明DiskLruCache的优秀，仅仅以管理磁盘文件能力单独拎出来成为一个框架，作者需要很大的勇气，很幸运，作者做到了，并且也成为Google官网提倡的缓存 ；如还记得上次做"一键清除缓存"、"查看缓存文件大小"功能是什么时候吗？DiskLruCache一句话就可以搞定！

github <https://github.com/JakeWharton/DiskLruCache>

作者：JakeWharton

# 教学

## u2020

一句话介绍：一款提供Dagger的高级教学示例的app（额，名字是有点绕） 上榜理由：4.7K个star，JakeWharton牵头开发的教学类app，教你使用Dagger在其他高级框架的用法，它展示了Dagger与ButterKnife、Retrofit、Moshi、Picasso、Okhttp、RxJava、Timber、Madge、LeakCanar等众多优秀框架结合起来的高级用法，你也可以借鉴到自己的项目当中

github <https://github.com/JakeWharton/u2020>

作者：JakeWharton

## Transitions-Everywhere

一句话介绍：一款教你正确使用Transitions API（Android 转场动画API）的教学型项目

上榜理由：你可能还未尝试过Android API的Transitions 框架，可能听过，但却无法做出优雅奇妙的动效----别担心，Transitions-Everywhere正如它的名字一样，它将带你全面体验Transitions 的强大之处

github <https://github.com/andkulikov/Transitions-Everywhere>

作者：Andrey Kulikov

# 加密

## conceal

一句话介绍：一款facebook提供的加密本地大文件的框架

上榜理由：如果还在担心App内的图片的隐私问题，这款facebook提供的文件加密框架足以解决你的问题，facebook客户端的图片和数据都是使用conceal加密的

官网地址：<http://facebook.github.io/conceal/>

github <https://github.com/facebook/conceal>

作者：facebook

# 异常处理

## CustomActivityOnCrash

一句话介绍：一款当APP crash的时候自动载入某个Activity的框架（而不是显示Unfortunately, X has stopped）

上榜理由：新奇的创意是榜单所需要的，所以它赢得了1.8K个star；作为开发者应该拥有考虑到各种潜伏的bug的能力，但我们不能总是面面俱到，其他系统端的同事也可能造成程序的意外crash，因此，如何让程序优雅的crash->重启值得我们思考，这款框架就提供了这种能力

github <https://github.com/Ereza/CustomActivityOnCrash>

作者：Eduard Ereza Martínez

# 主题

## MagicaSakura

一句话介绍：一款提供多主题切换能力的框架

上榜理由：框架所提供的能力，一直是本榜单所看重的，这款由bilibili提供的多主题框架，作为榜单所涉及范围能补充，1.9个star，感谢bilibili团队所作出的贡献！

github <https://github.com/Bilibili/MagicaSakura>

作者:Bilibili
