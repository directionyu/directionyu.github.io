---
title: MVP模式的理解以及封装思考
date: 2018-07-08T10:54:12.000Z
categories: Android
tags:
  - Android
toc: true
---

# mvp是什么?

  Model、View、Presenter

  View：负责视图部分展示、视图事件处理。Activity、Fragment、Dialog、ViewGroup等呈现视图的组件都可以承担该角色。

  Model：负责数据的请求、解析、过滤等数据层操作。

  Presenter:View和Model交互的桥梁。

# mvp能带来什么好处?

## 单一职责

  Model、View、Presenter只处理某一类逻辑

## 解耦

-   Model层修改和View层修改互不影响

-   面向接口编程，依赖抽象

-   Presenter和View互相持有抽象引用，对外隐藏内部实现细节

# mvp可能会带来什么问题?

-   Model进行异步操作，获取结果通过Presenter回传到View时，出现View引用的空指针异常
-   Presenter和View互相持有引用，解除不及时造成的内存泄漏。
-   

# mvp怎么用?

# 封装

## 思考

  构建框架的最终目的是增强项目代码的 可读性 ， 维护性 和 方便测试 ，如果背离了这个初衷，为了使用而使用，最终是得不偿失的

  从根本上来讲，要解决上述的三个问题，核心思想无非两种：一个是 分层 ，一个是 模块化 。两个方法最终要实现的就是解耦，分层讲的是纵向层面上的解耦，模块化则是横向上的解耦。
  解耦的常用方法有两种： 分层 与 模块化

  横向的模块化并不陌生，在一个项目建立项目文件夹的时候就会遇到这个问题，通常的做法是将相同功能的模块放到同一个目录下，更复杂的，可以通过插件化来实现功能的分离与加载。

  纵向的分层，不同的项目可能就有不同的分法，并且随着项目的复杂度变大，层次可能越来越多。

  对于经典的 Android MVC 框架来说，如果只是简单的应用，业务逻辑写到 Activity 下面并无太多问题，但一旦业务逐渐变得复杂起来，每个页面之间有不同的数据交互和业务交流时，activity 的代码就会急剧膨胀，代码就会变得可读性，维护性很差。

  总的来说：项目大了我们便于修改和测试，代码重用性高。
  在进行MVP架构设计时需要考虑Presenter对View进行回传时，View是否为空？Presenter与View何时解除引用即Presenter能否和View层进行生命周期同步?

  正常情况下，开发一个项目的时候我们都会建一个BaseActivity，然后在里面做一些共同的View层相关操作，此时如果我们将P层的初始化、与View生命周期同步放在BaseActivity里面，很明显会违背软件设计原则的单一职责，且会增加耦合，不利于软件升级、灵活性太低。

  presenter会持有view，如果presenter有后台异步的长时间的动作，比如网络请求，这时如果返回退出了Activity，后台异步的动作不会立即停止，这里就会有内存泄漏的隐患，需要在presenter中增加了类似的生命周期的方法，用来在退出Activity的时候取消持有Activity。

当设备旋转或者 Activity 长期处于后台而被系统回收，Activity 的会经历销毁->重建的过程。但是我们可以保存 Fragment，当 Activity 重建时继续使用已经存在的 Fragment 实例，避免浪费系统资源。
解决方案
setRetainInstance
利用系统 API 提供的 Fragment#setRetainInstance(boolean retain) 方法来保存 Fragment 实例，在 GlobalConfiguration 的 FragmentLifecycleCallbacks 回调方法里设为 true。

因为 FargmentManager 在 Activity 重建时会自动恢复，所以可以在添加 Fragment 时设置 tag，然后通过 FragmentManager#findFragmentByTag(String tag) 获取 FragmentManager 中已存在的 Fragment 实例。
这里使用了 FragmentUtils 工具类处理 Fragment。
[FragmentUtils](https://github.com/Blankj/AndroidUtilCode/blob/master/utilcode/src/main/java/com/blankj/utilcode/util/FragmentUtils.java)

  通过 ActivityDelegate 代理 Activity 的生命周期(具体实现为 ActivityDelegateImpl )，通过 FragmentDelegate 代理 Fragment 的生命周期(具体实现为 FragmentDelegateImpl )；
  然后在 ActivityLifecycle 实现了 Application.ActivityLifecycleCallbacks 接口，内部类 FragmentLifecycle 实现了 FragmentManager.FragmentLifecycleCallbacks 抽象类；
  并将 ActivityLifecycle 注入到 BaseApplication 中，注入过程是通过 AppDelegate 来代理 Application 的生命周期完成的。

  FragmentLifecycleCallbacks

-   ActivityLifecycleCallbacks 里的方法是在 Activity 对应生命周期的 super() 方法中进行的。FragmentLifecycleCallbacks 里的方法是在 Fragment 对应生命周期方法全部执行完毕后后调用的。

1.  每个子类都要重写父类创建Presenter的方法，创建一个Presenter并返回，这一步我们也可以让父类帮忙干了，怎么做呢？我们可以采用注解的方式，在子类上声明一个注解并注明要创建的类型，剩下的事情就让父类去做了,但是父类得考虑如果子类不想这么干怎么办，那也还是不能写死吧，可以使用策略模式加工厂模式来实现，我们默认使用这种注解的工厂，但是如果子类不喜欢可以通过父类提供的一个方法来创建自己的工厂。
2.  Presenter真正的创建过程，我们可以将它放到真正使用Presenter的时候再创建，这样的话可以稍微优化一下性能问题
3.  界面有可能会意外销毁并重建，Activity、Fragment、View都可以在销毁的时候通过onDestroy释放一些资源并在onSaveInstanceState方法中存储一些数据然后在重建的时候恢复，但是有可能Presenter中也需要释放一些资源存储一些数据，那么上面的结构就不能满足了，我们可以给Presenter增加生命周期的方法，让Presenter和V层生命周期同步就可以做到了
4.  第三步中我们又给Presenter加入了一些生命周期的方法，再加上Presenter的创建绑定和解绑的方法，那么如果我们在创建一个MvpFragment基类，或者View的基类那么这么多的代码岂不是都要copy一份吗，而且看起来也很不清晰，这里我们可以采用代理模式来优化一下

## 封装mvp是过度设计吗?

## 为什么要少封装BaseActivity?

  Java只支持单继承,那么在使用Activity时只能继承一个BaseActivity,以达到轻松使用公共功能的需求,如果开发中需要使用某个第三方库,但是三方库中的某些功能需要继承于他自己的BaseActivity,这个时候该怎么办?更改自己的BaseActivity让它去继承三方库的基类,这个时候又会出现问题,很多其他并不需要的Activity都被迫的继承了三方库的基类或者分多个BaseActivity,这样会造成很大的效率浪费.很多功能也会冗余.

  那么,我们为什么需要在BaseActivity中封装公共方法?是因为我们一些方法需要在对应的Activity生命周期中执行,那么问题来了能不能将公共方法不封装在BaseActivity中,而是封装在其他逻辑类中?

  Application 提供有一个 registerActivityLifecycleCallbacks() 的方法,需要传入的参数就是这个 ActivityLifecycleCallbacks 接口,作用和你猜的没错,就是在你调用这个方法传入这个接口实现类后,系统会在每个 Activity 执行完对应的生命周期后都调用这个实现类中对应的方法.
