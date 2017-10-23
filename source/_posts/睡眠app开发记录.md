---
title: 睡眠白噪音app开发记录
date: 2017-10-11T14:33:23.000Z
categories: Android
tag: Basic knowledge
toc: true
---

[universalMusicPlayer samples 代码学习](http://blog.csdn.net/xzp8891/article/details/52078511)

[关于媒体浏览器服务(MediaBrowserService)](http://blog.csdn.net/huyongl1989/article/details/71037284)

# 音乐

1. 从服务器获取音乐数据
2. 播放音乐时播放器的各种播放状态以及不同状态下的UI展示
3. 播放过程中通过UI界面控制播放器的各种状态
4. UI控制如何与播放服务进行关联并进行状态同步
5. 如何保证后台播放过程中播放服务不被杀死

  对于上面的这几点，其实Android已经为我们提供了一套完整的解决方案，它已经很好的将这些操作进行了封装，我们只需要关注数据的获取和歌曲的播放即可。

  关键类主要有如下几个：

  - MediaBrowserServiceCompat 媒体浏览器服务

  - MediaBrowserCompat 媒体浏览器

  - MediaControllerCompat 媒体控制器

  - MediaSessionCompat 媒体会话

# MediaSession 框架简介

MediaSession 是 Android 5.0 推出的媒体播放框架，负责 UI 和后台播放之间的状态同步，支持了绝大部分音频播放的可能会遇到的操作，而且支持自定义操作。主要由 MediaSession (受控端) 和 MediaController (控制端) 构成：

## MediaSession

MediaSession.Token: 用于保持与 MediaController 的正常配对

MediaSession.Callback：用于监听 MediaController 的各种播放指令

## MediaController

MediaController.Callback：用于监听播放状态/信息更新

MediaController.TransportControls：用于向 MediaSession 发送各种播放指令

基本流程就是，UI 通过使用 MediaController.TransportControls 发送播放相关的控制指令（play, pause, stop 等等），MediaSession.Callback 在接收到相关指令后，对 Player 进行对应的操作，然后状态更新通过 MediaSession 同步给 MediaController.Callback, 最后更新 UI。

# 相关类

## MediaBrowserServiceCompat

### 作用

1. 音乐播放后台服务
2. 客户端中获取音乐数据的服务，所有的音乐数据都通过该服务与服务端进行交互获取(或者直接获取手机中的本地音乐数据)

  该类是Service的子类实现，所以说它是音乐播放的后台服务也好理解，但是该类作为一个后台播放服务却不是通过其自身直接实现的，而是通过MediaSessionCompat媒体会话这个类来实现的。在使用过程中媒体会话会与该服务关联起来，所有的播放操作都交由MediaSessionCompat实现。 而对于获取数据，则是通过MediaBrowserServiceCompat的如下两个方法来进行控制：

  ```java
  @Override
  public BrowserRoot onGetRoot(@NonNull String clientPackageName, int clientUid,
                Bundle rootHints) {
  /**
  * 在返回数据之前，可以进行黑白名单控制，以控制不同客户端浏览不同的媒体资源
  * */
  if(!PackageUtil.isCallerAllowed(this, clientPackageName, clientUid)) {
  return new BrowserRoot(null, null);
  }
  //此方法只在服务连接的时候调用
  //返回一个rootId不为空的BrowserRoot则表示客户端可以连接服务，也可以浏览其媒体资源
  //如果返回null则表示客户端不能流量媒体资源
  return new BrowserRoot(BrowserRootId.MEDIA_ID_ROOT, null);
  }

  @Override
  public void onLoadChildren(@NonNull String parentId, @NonNull Result<List<MediaItem>> result) {

  /***
  * 此方法中的parentId与上面的方法onGetRoot中返回的RootId没有关系
  * 客户端连接后，它可以通过重复调用MediaBrowserCompat.subscribe() 方法来发起数据获取请求。
  * 而每次调用subscribe() 方法都会发送一个onLoadChildren（）回调到该service中，然后返回一个MediaBrowser.MediaItem(音乐数据) 对象列表
  *
  * 每个MediaItem 都有唯一的ID字符串，它其实是一个隐式的token。
  * 当客户想打开子菜单或播放一个item时，它就将ID传入。
  */
  if(BrowserRootId.MEDIA_ID_MUSIC_LIST_REFRESH.equals(parentId)) {
  //在当前方法执行结束返回之前必须要调用result.detach(),否则无法发起请求
  result.detach();
  MusicProvider.getInstance().requestMusic(result);
  //如果想要通过http请求来获取数据，则必须按照上面说的必须要先调用result.detach();方法，否则会出现异常。http请求结束之后则通过调用result.sendResult(mMetadataCompatList);将数据返回,返回的数据在注册的接口MediaBrowserCompat.SubscriptionCallback中通过回调拿到在界面上进行展示
  //而且此处返回的数据类型必须是MediaBrowser.MediaItem
  } else {
  result.detach();
  }
  }
  ```

## MediaBrowserCompat

### 作用

前面说过MediaBrowserServiceCompat(媒体浏览服务)是作为数据请求服务来获取数据的，因此相应的会有一个媒体浏览客户端来发起媒体数据的获取请求，该类就是这个客户端。 前面已经介绍过通过调用MediaBrowserCompat.subscribe()方法来发起数据请求，而在调用此方法之前，必须保证MediaBrowserCompat连接上媒体浏览服务，连接方式如下：

```java
  //通过如下代码连接MediaBrowserServiceCompat，连接成功后获取媒体会话token
  //通过媒体会话token创建MediaControllerCompat
  //这时就将MediaControllerCompat与媒体会话MediaSessionCompat关联起来了
  MediaBrowserCompat mediaBrowser = new MediaBrowserCompat(this,
                  new ComponentName(this, MusicService.class), mConnectionCallback, null);

  //连接媒体浏览服务成功后的回调接口
  final MediaBrowserCompat.ConnectionCallback mConnectionCallback =
      new MediaBrowserCompat.ConnectionCallback() {
          @Override
          public void onConnected() {

              try {
                  //获取与MediaBrowserServiceCompat关联的媒体会话token
                  MediaSessionCompat.Token token = mMediaBrowser.getSessionToken();
                  //通过媒体会话token创建媒体控制器并与之关联
                  //关联之后媒体控制器就可以控制播放器的各种播放状态了
                  MediaControllerCompat mediaController = new MediaControllerCompat(this, token);
                  //将媒体控制器与当前上下文Context进行关联
                  //此处关联之后，我们在界面上操作某些UI的时候就可以通过当前上下文Context来获取当前的MediaControllerCompat
                  //MediaControllerCompat controller = MediaControllerCompat.getMediaController((Activity) context);
                  MediaControllerCompat.setMediaController(this, mediaController);
                  //为媒体控制器注册回调接口          mediaController.registerCallback(mMediaControllerCallback);
              } catch (RemoteException e) {
                  onMediaControllerConnectedFailed();
              }
          }
      };

  //媒体控制器控制播放过程中的回调接口
  final MediaControllerCompat.Callback mMediaControllerCallback =
     new MediaControllerCompat.Callback() {
          @Override
          public void onPlaybackStateChanged(@NonNull PlaybackStateCompat state) {
              //播放状态发生改变时的回调
              onMediaPlayStateChanged(state);
          }

          @Override
          public void onMetadataChanged(MediaMetadataCompat metadata) {

              if(metadata == null) {
                  return;
              }
              //播放的媒体数据发生变化时的回调
              onPlayMetadataChanged(metadata);
          }
      };



  //发起数据请求
   //先解除订阅
   mediaBrowser.unsubscribe(BrowserRootId.MEDIA_ID_MUSIC_LIST_REFRESH);
   //重新对BrowserRootId进行订阅
   //调用此方法后，会接着执行MusicService中的onGetRoot方法和onLoadChildren方法
   //onGetRoot方法(只会调用一次)决定是否允许当前客户端连接服务和获取媒体数据
   //如果允许连接服务同时也允许获取媒体数据，则会接着调用onLoadChildren方法开始获取数据
   //数据获取成功后会调用订阅的回调接口将数据返回回来
   mediaBrowser.subscribe(BrowserRootId.MEDIA_ID_MUSIC_LIST_REFRESH, mSubscriptionCallback);

  //向媒体流量服务发起媒体浏览请求的回调接口
  final MediaBrowserCompat.SubscriptionCallback mSubscriptionCallback =
      new MediaBrowserCompat.SubscriptionCallback() {
          @Override
          public void onChildrenLoaded(@NonNull String parentId,
                                       @NonNull List<MediaBrowserCompat.MediaItem> children) {
              //数据获取成功后的回调
          }

          @Override
          public void onError(@NonNull String id) {
              //数据获取失败的回调
          }
      };
```

## MediaPlayer

MediaPlayer一般播放较大的音频文件，解码速度较慢，并且需要添加子线程。

## ExoPlayer

## AudioManager

很多App都可以播放音频，因此在播放前如何获取到音频焦点就显得很重要了，这样可以避免同时出现多个声音，Android使用audio focus来节制音频的播放，仅仅是获取到audio focus的App才能够播放音频。 在App开始播放音频之前，它需要经过发出请求[request]->接受请求[receive]->音频焦点锁定[Audio Focus]的过程。同样，它需要知道如何监听失去音频焦点[lose of audio focus]的事件并进行合适的响应。

我们必须指定正在使用哪个音频流，而且需要确定请求的是短暂的还是永久的audio focus。

- 短暂的焦点锁定：当期待播放一个短暂的音频的时候（比如播放导航指示）
- 永久的焦点锁定：当计划播放可预期到的较长的音频的时候（比如播放音乐）

下面是一个在播放音乐的时候请求永久的音频焦点的例子，我们必须在开始播放之前立即请求音频焦点，比如在用户点击播放或者游戏程序中下一关开始的片头音乐。

```java
AudioManager am = mContext.getSystemService(Context.AUDIO_SERVICE);
...

// Request audio focus for playback  
int result = am.requestAudioFocus(afChangeListener,
                                 // Use the music stream.  
                                 AudioManager.STREAM_MUSIC,
                                 // Request permanent focus.  
                                 AudioManager.AUDIOFOCUS_GAIN);

if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
    am.unregisterMediaButtonEventReceiver(RemoteControlReceiver);
    // Start playback.  
}
```

一旦结束了播放，需要确保call abandonAudioFocus())方法。这样会通知系统说你不再需要获取焦点并且取消注册AudioManager.OnAudioFocusChangeListener的监听。在这样释放短暂音频焦点的case下，可以允许任何打断的App继续播放。

```java
// Abandon audio focus when playback complete      
am.abandonAudioFocus(afChangeListener);
```

当请求短暂音频焦点的时候，我们可以选择是否开启"ducking"。Ducking是一个特殊的机制使得允许音频间歇性的短暂播放。 通常情况下，一个好的App在失去音频焦点的时候它会立即保持安静。如果我们选择在请求短暂音频焦点的时候开启了ducking，那意味着其它App可以继续播放，仅仅是在这一刻降低自己的音量，在短暂重新获取到音频焦点后恢复正常音量(也就是说：不用理会这个请求短暂焦点的请求，这并不会导致目前在播放的音频受到牵制，比如在播放音乐的时候突然出现一个短暂的短信提示声音，这个时候仅仅是把播放歌曲的音量暂时调低，好让短信声能够让用户听到，之后立马恢复正常播放)。

```java
// Request audio focus for playback  
int result = am.requestAudioFocus(afChangeListener,
                             // Use the music stream.  
                             AudioManager.STREAM_MUSIC,
                             // Request permanent focus.  
                             AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK);

if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
    // Start playback.  
}
```

AudioManager类位于android.Media 包中，该类提供访问控制音量和钤声模式的操作。 通过getSystemService(Context.AUDIO_SERVICE)方法获得AudioManager实例对象。 AudioManager audiomanage = (AudioManager)context.getSystemService(Context.AUDIO_SERVICE); audiomanager就是我们定义的控制系统声音的对象。

### Handle the Loss of Audio Focus(处理失去音频焦点)

如果A程序可以请求获取音频焦点，那么在B程序请求获取的时候，A获取到的焦点就会失去。显然我们需要处理失去焦点的事件。

在音频焦点的监听器里面，当接受到描述焦点改变的事件时会触发onAudioFocusChange())回调方法。对应于获取焦点的三种类型，我们同样会有三种失去焦点的类型。

失去短暂焦点：通常在失去这种焦点的情况下，我们会暂停当前音频的播放或者降低音量，同时需要准备恢复播放在重新获取到焦点之后。

失去永久焦点：假设另外一个程序开始播放音乐等，那么我们的程序就应该有效的结束自己。实用的做法是停止播放，移除button监听，允许新的音频播放器独占监听那些按钮事件，并且放弃自己的音频焦点。

在重新播放器自己的音频之前，我们需要确保用户重新点击自己App的播放按钮等。

```java
  OnAudioFocusChangeListener afChangeListener = new OnAudioFocusChangeListener() {
      public void onAudioFocusChange(int focusChange) {
          if (focusChange == AUDIOFOCUS_LOSS_TRANSIENT){
              // Pause playback  
          } else if (focusChange == AudioManager.AUDIOFOCUS_GAIN) {
              // Resume playback   
          } else if (focusChange == AudioManager.AUDIOFOCUS_LOSS) {
              am.unregisterMediaButtonEventReceiver(RemoteControlReceiver);
              am.abandonAudioFocus(afChangeListener);
              // Stop playback  
          }
      }
  };
```

在上面失去短暂焦点的例子中，如果允许ducking，那么我们可以选择"duck"的行为而不是暂停当前的播放。

### Duck! [闪避]

Ducking是一个特殊的机制使得允许音频间歇性的短暂播放。在Ducking的情况下，正常播放的歌曲会降低音量来凸显这个短暂的音频声音，这样既让这个短暂的声音比较突出，又不至于打断正常的声音。

```java
OnAudioFocusChangeListener afChangeListener = new OnAudioFocusChangeListener() {
    public void onAudioFocusChange(int focusChange) {
        if (focusChange == AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK){
            // Lower the volume  
        } else if (focusChange == AudioManager.AUDIOFOCUS_GAIN) {
            // Raise it back to normal  
        }
    }
};
```

## Android Training - 音频播放(Lesson 3 - 音频设备的相关问题)

### Check What Hardware is Being Used(检测目前正在使用的硬件设备)

选择的播放设备会影响App的行为。可以使用AudioManager来查询某个音频输出到扬声器，有线耳机还是蓝牙上。

```java
if (isBluetoothA2dpOn()) {
    // Adjust output for Bluetooth.  
} else if (isSpeakerphoneOn()) {
    // Adjust output for Speakerphone.  
} else if (isWiredHeadsetOn()) {
    // Adjust output for headsets  
} else {
    // If audio plays and noone can hear it, is it still playing?  
}
```

### Handle Changes in the Audio Output Hardware(处理音频输出设备的改变)

当有线耳机被拔出或者蓝牙设备断开连接的时候，音频流会自动输出到内置的扬声器上。假设之前播放声音很大，这个时候突然转到扬声器播放会显得非常嘈杂。 幸运的是，系统会在那种事件发生时会广播带有ACTION_AUDIO_BECOMING_NOISY的intent。无论何时播放音频去注册一个BroadcastReceiver来监听这个intent会是比较好的做法。 在音乐播放器下，用户通常希望发生那样事情的时候能够暂停当前歌曲的播放。在游戏里，通常会选择减低音量。

```java
private class NoisyAudioStreamReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (AudioManager.ACTION_AUDIO_BECOMING_NOISY.equals(intent.getAction())) {
            // Pause the playback  
        }
    }
}

private IntentFilter intentFilter = new IntentFilter(AudioManager.ACTION_AUDIO_BECOMING_NOISY);

private void startPlayback() {
    registerReceiver(myNoisyAudioStreamReceiver(), intentFilter);
}

private void stopPlayback() {
    unregisterReceiver(myNoisyAudioStreamReceiver);
}
```

## #

## #

## 常用类

### AudioAttributes

> A class to encapsulate a collection of attributes describing information about an audio stream.
封装了有关音频流属性集合的类

#### 能做什么

1. #### 怎么用

  ### AudioFocusRequest

### 常用方法


## WifiLocker
[WifiLocker](https://developer.android.com/reference/android/net/wifi/WifiManager.WifiLock.html)

>Allows an application to keep the Wi-Fi radio awake. Normally the Wi-Fi radio may turn off when the user has not used the device in a while. Acquiring a WifiLock will keep the radio on until the lock is released. Multiple applications may hold WifiLocks, and the radio will only be allowed to turn off when no WifiLocks are held in any application.
> 允许应用程序保持Wi-Fi唤醒状态。通常情况下， Wi-Fi网络可以关闭，当用户没有使用该设备在一段时间。获取WifiLock将保持网络，直到锁被释放。多个应用程序可持有WifiLocks ，而收音机将只能被允许关闭时，没有WifiLocks在任何应用程序举行。

 - 需要添加权限 <uses-permission android:name="android.permission.WAKE_LOCK"/>
## SoundPool

官方解释

> The SoundPool class manages and plays audio resources for applications.

> A SoundPool is a collection of samples that can be loaded into memory from a resource inside the APK or from a file in the file system. The SoundPool library uses the MediaPlayer service to decode the audio into a raw 16-bit PCM mono or stereo stream. This allows applications to ship with compressed streams without having to suffer the CPU load and latency of decompressing during playback.

也就是说SoundPool能将文件系统或者Apk内的资源加载到内存中，使用了MediaPlayer服务将音频解码成16-bit PCM单声道或者立体声流，这样使用压缩流传输不担心CPU负载和解压缩时引起延迟。

SoundPool载入音乐文件使用了独立的线程，不会阻塞UI主线程的操作。但是这里如果音效文件过大没有载入完成，我们调用play方法时可能产生严重的后果，Android SDK提供了一个SoundPool.OnLoadCompleteListener类来帮助我们了解媒体文件是否载入完成，我们重载 onLoadComplete(SoundPool soundPool, int sampleId, int status) 方法即可获得。 从上面的onLoadComplete方法可以看出该类有很多参数，比如类似id，是的SoundPool在load时可以处理多个媒体一次初始化并放入内存中，这里效率比MediaPlayer高了很多。 SoundPool类支持同时播放多个音效，这对于游戏来说是十分必要的，而MediaPlayer类是同步执行的只能一个文件一个文件的播放。

SDK21版本后，SoundPool的创建发生了很大变化，所以在开发中需要进行版本控制。 使用方法 sdk21之前：

创建SoundPool： SoundPool(int maxStream, int streamType, int srcQuality)

maxStream ---- 同时播放的流的最大数量

streamType ---- 流的类型，一般为STREAM_MUSIC(具体在AudioManager类中列出)

srcQuality ---- 采样率转化质量，当前无效果，使用0作为默认

加载音频： 如果要加载多个音频，需要用到HashMap等，单个音频，直接传入load()方法即可 soundPool的加载 ：

int load(Context context, int resId, int priority) //从APK资源载入

int load(FileDescriptor fd, long offset, long length, int priority) //从FileDescriptor对象载入

int load(AssetFileDescriptor afd, int priority) //从Asset对象载入 int load(String path, int priority) //从完整文件路径名载入 播放音频： play(int soundID, float leftVolume, float rightVolume, int priority, int loop, float rate)

其中leftVolume和rightVolume表示左右音量，priority表示优先级,loop表示循环次数,rate表示速率；而停止则可以使用 pause(int streamID) 方法，这里的streamID和soundID均在构造SoundPool类的第一个参数中指明了总数量，而id从0开始。
