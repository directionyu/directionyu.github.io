---
title: Android代码内存优化建议-Android官方篇
date: 2016-11-29 14:10:23   
categories: Android   
tag: Android
toc: true  
---


为了使垃圾回收器可以正常释放程序所占用的内存，在编写代码的时候就一定要注意尽量避免出现内存泄漏的情况（通常都是由于全局成员变量持有对象引用所导致的），并且在适当的时候去释放对象引用。对于大多数的应用程序而言，后面其它的事情就可以都交给垃圾回收器去完成了，如果一个对象的引用不再被其它对象所持有，那么系统就会将这个对象所分配的内存进行回收。

我们在开发软件的时候应当自始至终都把内存的问题充分考虑进去，这样的话才能开发出更加高性能的软件。而内存问题也并不是无规律可行的，Android系统给我们提出了很多内存优化的建议技巧，只要按照这些技巧来编写程序，就可以让我们的程序在内存性能发面表现得相当不错。

<!--more-->

## 正文
本文原文来自Android开发者官网Managing Your App’s Memory章节中的
How Your App Should Manage Memory部分。是Android官方帮助应用开发者更好地管理应用的内存而写的。作为一个应用程序开发者，你需要在你开发应用程序的时时刻刻都考虑内存问题。

### 节制地使用Service
如果应用程序当中需要使用Service来执行后台任务的话，请一定要注意只有当任务正在执行的时候才应该让Service运行起来。另外，当任务执行完之后去停止Service的时候，要小心Service停止失败导致内存泄漏的情况。

当我们启动一个Service时，系统会倾向于将这个Service所依赖的进程进行保留，这样就会导致这个进程变得非常消耗内存。并且，系统可以在LRU cache当中缓存的进程数量也会减少，导致切换应用程序的时候耗费更多性能。严重的话，甚至有可能会导致崩溃，因为系统在内存非常吃紧的时候可能已无法维护所有正在运行的Service所依赖的进程了。

为了能够控制Service的生命周期，Android官方推荐的最佳解决方案就是使用IntentService，这种Service的最大特点就是当后台任务执行结束后会自动停止，从而极大程度上避免了Service内存泄漏的可能性。

让一个Service在后台一直保持运行，即使它并不执行任何工作，这是编写Android程序时最糟糕的做法之一。所以Android官方极度建议开发人员们不要过于贪婪，让Service在后台一直运行，这不仅可能会导致手机和程序的性能非常低下，而且被用户发现了之后也有可能直接导致我们的软件被卸载

### 当界面不可见时释放内存
当用户打开了另外一个程序，我们的程序界面已经不再可见的时候，我们应当将所有和界面相关的资源进行释放。在这种场景下释放资源可以让系统缓存后台进程的能力显著增加，因此也会让用户体验变得更好。
那么我们如何才能知道程序界面是不是已经不可见了呢？其实很简单，只需要在Activity中重写onTrimMemory()方法，然后在这个方法中监听TRIM_MEMORY_UI_HIDDEN这个级别，一旦触发了之后就说明用户已经离开了我们的程序，那么此时就可以进行资源释放操作了，如下所示：
```Java
@Override  
public void onTrimMemory(int level) {  
    super.onTrimMemory(level);  
    switch (level) {  
    case TRIM_MEMORY_UI_HIDDEN:  
        // 进行资源释放操作  
        break;  
    }  
}
```

注意onTrimMemory()方法中的TRIM_MEMORY_UI_HIDDEN回调只有当我们程序中的所有UI组件全部不可见的时候才会触发，这和onStop()方法还是有很大区别的，因为onStop()方法只是当一个Activity完全不可见的时候就会调用，比如说用户打开了我们程序中的另一个Activity。因此，我们可以在onStop()方法中去释放一些Activity相关的资源，比如说取消网络连接或者注销广播接收器等，但是像UI相关的资源应该一直要等到onTrimMemory(TRIM_MEMORY_UI_HIDDEN)这个回调之后才去释放，这样可以保证如果用户只是从我们程序的一个Activity回到了另外一个Activity，界面相关的资源都不需要重新加载，从而提升响应速度。

### 当内存紧张时释放内存
除了刚才讲的TRIM_MEMORY_UI_HIDDEN这个回调，onTrimMemory()方法还有很多种其它类型的回调，可以在手机内存降低的时候及时通知我们。我们应该根据回调中传入的级别来去决定如何释放应用程序的资源：

1. 应用程序正在运行时
TRIM_MEMORY_RUNNING_MODERATE 表示应用程序正常运行，并且不会被杀掉。但是目前手机的内存已经有点低了，系统可能会开始根据LRU缓存规则来去杀死进程了。
TRIM_MEMORY_RUNNING_LOW 表示应用程序正常运行，并且不会被杀掉。但是目前手机的内存已经非常低了，我们应该去释放掉一些不必要的资源以提升系统的性能，同时这也会直接影响到我们应用程序的性能。
TRIM_MEMORY_RUNNING_CRITICAL 表示应用程序仍然正常运行，但是系统已经根据LRU缓存规则杀掉了大部分缓存的进程了。这个时候我们应当尽可能地去释放任何不必要的资源，不然的话系统可能会继续杀掉所有缓存中的进程，并且开始杀掉一些本来应当保持运行的进程，比如说后台运行的服务。

2. 应用程序被缓存
TRIM_MEMORY_BACKGROUND 表示手机目前内存已经很低了，系统准备开始根据LRU缓存来清理进程。这个时候我们的程序在LRU缓存列表的最近位置，是不太可能被清理掉的，但这时去释放掉一些比较容易恢复的资源能够让手机的内存变得比较充足，从而让我们的程序更长时间地保留在缓存当中，这样当用户返回我们的程序时会感觉非常顺畅，而不是经历了一次重新启动的过程。
TRIM_MEMORY_MODERATE 表示手机目前内存已经很低了，并且我们的程序处于LRU缓存列表的中间位置，如果手机内存还得不到进一步释放的话，那么我们的程序就有被系统杀掉的风险了。
TRIM_MEMORY_COMPLETE 表示手机目前内存已经很低了，并且我们的程序处于LRU缓存列表的最边缘位置，系统会最优先考虑杀掉我们的应用程序，在这个时候应当尽可能地把一切可以释放的东西都进行释放。因为onTrimMemory()是在API14才加进来的，所以如果要支持API14之前的话，则可以考虑 onLowMemory())这个方法，它粗略的相等于onTrimMemory()回调的TRIM_MEMORY_COMPLETE事件。注意：当系统安装LRU cache杀进程的时候，尽管大部分时间是从下往上按顺序杀，有时候系统也会将占用内存比较大的进程纳入被杀范围，以尽快得到足够的内存。所以你的应用在LRU list中占用的内存越少，你就越能避免被杀掉，当你恢复的时候也会更快。

3. 检查你应该使用多少的内存
正如前面提到的，每一个Android设备都会有不同的RAM总大小与可用空间，因此不同设备为app提供了不同大小的heap限制。你可以通过调用getMemoryClass())来获取你的app的可用heap大小。如果你的app尝试申请更多的内存，会出现OutOfMemory的错误。在一些特殊的情景下，你可以通过在manifest的application标签下添加largeHeap=true的属性来声明一个更大的heap空间。如果你这样做，你可以通过getLargeMemoryClass())来获取到一个更大的heap size。然而，能够获取更大heap的设计本意是为了一小部分会消耗大量RAM的应用(例如一个大图片的编辑应用)。不要轻易的因为你需要使用大量的内存而去请求一个大的heap size。只有当你清楚的知道哪里会使用大量的内存并且为什么这些内存必须被保留时才去使用large heap. 因此请尽量少使用large heap。使用额外的内存会影响系统整体的用户体验，并且会使得GC的每次运行时间更长。在任务切换时，系统的性能会变得大打折扣。另外, large heap并不一定能够获取到更大的heap。在某些有严格限制的机器上，large heap的大小和通常的heap size是一样的。因此即使你申请了large heap，你还是应该通过执行getMemoryClass()来检查实际获取到的heap大小。

### 避免在Bitmap上浪费内存
当我们读取一个Bitmap图片的时候，有一点一定要注意，就是千万不要去加载不需要的分辨率。在一个很小的ImageView上显示一张高分辨率的图片不会带来任何视觉上的好处，但却会占用我们相当多宝贵的内存。需要仅记的一点是，将一张图片解析成一个Bitmap对象时所占用的内存并不是这个图片在硬盘中的大小，可能一张图片只有100k你觉得它并不大，但是读取到内存当中是按照像素点来算的，比如这张图片是15001000像素，使用的ARGB_8888颜色类型，那么每个像素点就会占用4个字节，总内存就是15001000*4字节，也就是5.7M，这个数据看起来就比较恐怖了。

### 使用优化过的数据集合
利用Android Framework里面优化过的容器类，例如SparseArray, SparseBooleanArray, 与 LongSparseArray。 通常的HashMap的实现方式更加消耗内存，因为它需要一个额外的实例对象来记录Mapping操作。另外，SparseArray更加高效在于他们避免了对key与value的autobox自动装箱，并且避免了装箱后的解箱。

### 知晓内存的开支情况
我们还应当清楚我们所使用语言的内存开支和消耗情况，并且在整个软件的设计和开发当中都应该将这些信息考虑在内。可能有一些看起来无关痛痒的写法，结果却会导致很大一部分的内存开支，例如：使用枚举通常会比使用静态常量要消耗两倍以上的内存，在Android开发当中我们应当尽可能地不使用枚举。
任何一个Java类，包括内部类、匿名类，都要占用大概500字节的内存空间。
任何一个类的实例要消耗12-16字节的内存开支，因此频繁创建实例也是会一定程序上影响内存的。
在使用HashMap时，即使你只设置了一个基本数据类型的键，比如说int，但是也会按照对象的大小来分配内存，大概是32字节，而不是4字节。因此最好的办法就是像上面所说的一样，使用优化过的数据集合。

### 谨慎使用抽象编程
许多程序员都喜欢各种使用抽象来编程，认为这是一种很好的编程习惯。当然，这一点不可否认，因为的抽象的编程方法更加面向对象，而且在代码的维护和可扩展性方面都会有所提高。但是，在Android上使用抽象会带来额外的内存开支，因为抽象的编程方法需要编写额外的代码，虽然这些代码根本执行不到，但是却也要映射到内存当中，不仅占用了更多的内存，在执行效率方面也会有所降低。当然这里我并不是提倡大家完全不使用抽象编程，而是谨慎使用抽象编程，不要认为这是一种很酷的编程方式而去肆意使用它，只在你认为有必要的情况下才去使用。

### 为序列化的数据使用nano protobufs
Protocol buffers是由Google为序列化结构数据而设计的，一种语言无关，平台无关，具有良好扩展性的协议。类似XML，却比XML更加轻量，快速，简单。如果你需要为你的数据实现协议化，你应该在客户端的代码中总是使用nano protobufs。通常的协议化操作会生成大量繁琐的代码，这容易给你的app带来许多问题：增加RAM的使用量，显著增加APK的大小，更慢的执行速度，更容易达到DEX的字符限制。关于更多细节，请参考protobuf readme的”Nano version”章节。

### 尽量避免使用依赖注入框架
现在有很多人都喜欢在Android工程当中使用依赖注入框架，比如说像Guice或者RoboGuice等，因为它们可以简化一些复杂的编码操作，比如可以将下面的一段代码：

```Java
class AndroidWay extends Activity {   
    TextView name;   
    ImageView thumbnail;   
    LocationManager loc;   
    Drawable icon;   
    String myName;   

    public void onCreate(Bundle savedInstanceState) {   
        super.onCreate(savedInstanceState);   
        setContentView(R.layout.main);  
        name      = (TextView) findViewById(R.id.name);   
        thumbnail = (ImageView) findViewById(R.id.thumbnail);   
        loc       = (LocationManager) getSystemService(Activity.LOCATION_SERVICE);   
        icon      = getResources().getDrawable(R.drawable.icon);   
        myName    = getString(R.string.app_name);   
        name.setText( "Hello, " + myName );   
    }   
}
```



简化成这样的一种写法：
```Java
@ContentView(R.layout.main)  
class RoboWay extends RoboActivity {   
    @InjectView(R.id.name)             TextView name;   
    @InjectView(R.id.thumbnail)        ImageView thumbnail;   
    @InjectResource(R.drawable.icon)   Drawable icon;   
    @InjectResource(R.string.app_name) String myName;   
    @Inject                            LocationManager loc;   

    public void onCreate(Bundle savedInstanceState) {   
        super.onCreate(savedInstanceState);   
        name.setText( "Hello, " + myName );   
    }   
}
```

看上去确实十分诱人，我们甚至可以将findViewById()这一类的繁琐操作全部省去了。但是这些框架为了要搜寻代码中的注解，通常都需要经历较长的初始化过程，并且还可能将一些你用不到的对象也一并加载到内存当中。这些用不到的对象会一直占用着内存空间，可能要过很久之后才会得到释放，相较之下，也许多敲几行看似繁琐的代码才是更好的选择。

### 谨慎使用external libraries
很多External library的代码都不是为移动网络环境而编写的，在移动客户端则显示的效率不高。至少，当你决定使用一个external library的时候，你应该针对移动网络做繁琐的porting与maintenance的工作。

即使是针对Android而设计的library，也可能是很危险的，因为每一个library所做的事情都是不一样的。例如，其中一个lib使用的是nano protobufs, 而另外一个使用的是micro protobufs。那么这样，在你的app里面就有2种protobuf的实现方式。这样的冲突同样可能发生在输出日志，加载图片，缓存等等模块里面。

同样不要陷入为了1个或者2个功能而导入整个library的陷阱。如果没有一个合适的库与你的需求相吻合，你应该考虑自己去实现，而不是导入一个大而全的解决方案。

### 优化整体性能
官方有列出许多优化整个app性能的文章：Best Practices for Performance. 这篇文章就是其中之一。有些文章是讲解如何优化app的CPU使用效率，有些是如何优化app的内存使用效率。

你还应该阅读optimizing your UI来为layout进行优化。同样还应该关注lint工具所提出的建议，进行优化。

### 使用ProGuard来剔除不需要的代码
ProGuard能够通过移除不需要的代码，重命名类，域与方法等方对代码进行压缩，优化与混淆。使用ProGuard可以是的你的代码更加紧凑，这样能够使用更少mapped代码所需要的RAM。

### 对最终的APK使用zipalign
在编写完所有代码，并通过编译系统生成APK之后，你需要使用zipalign对APK进行重新校准。如果你不做这个步骤，会导致你的APK需要更多的RAM，因为一些类似图片资源的东西不能被mapped。

Notes::Google Play不接受没有经过zipalign的APK。

### 分析你的RAM使用情况
一旦你获取到一个相对稳定的版本后，需要分析你的app整个生命周期内使用的内存情况，并进行优化，更多细节请参考Investigating Your RAM Usage.

### 使用多进程
如果合适的话，有一个更高级的技术可以帮助你的app管理内存使用：通过把你的app组件切分成多个组件，运行在不同的进程中。这个技术必须谨慎使用，大多数app都不应该运行在多个进程中。因为如果使用不当，它会显著增加内存的使用，而不是减少。当你的app需要在后台运行与前台一样的大量的任务的时候，可以考虑使用这个技术。

一个典型的例子是创建一个可以长时间后台播放的Music Player。如果整个app运行在一个进程中，当后台播放的时候，前台的那些UI资源也没有办法得到释放。类似这样的app可以切分成2个进程：一个用来操作UI，另外一个用来后台的Service.

你可以通过在manifest文件中声明’android:process’属性来实现某个组件运行在另外一个进程的操作。

```XML
<service android:name=".PlaybackService"
         android:process=":background" />
```

更多关于使用这个技术的细节，请参考原文，链接如下。
http://developer.android.com/training/articles/memory.html
