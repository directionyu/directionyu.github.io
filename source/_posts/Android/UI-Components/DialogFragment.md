E/WindowManager: android.view.WindowLeaked: Activity xxx.xxx.xxx.MainActivity has leaked window DecorView@87a37ab[] that was originally added here
如果使用传统的 Dialog ，需要我们手动处理屏幕翻转的情况,但使用 DialogFragment 的话，则不需要我们进行任何处理， FragmentManager 会自动管理 DialogFragment 的生命周期。

创建 DialogFragment 有两种方式：

覆写其 onCreateDialog 方法

*应用场景*：一般用于创建替代传统的 Dialog 对话框的场景，UI 简单，功能单一。
方法
覆写其 onCreateView 方法

*应用场景*：
一般用于创建复杂内容弹窗或全屏展示效果的场景，UI 复杂，功能复杂，一般有网络请求等异步操作。




DialogFragment说到底还是一个Fragment，因此它继承了Fragment的所有特性。同理FragmentManager会管理DialogFragment。在手机配置发生变化的时候，FragmentManager可以负责现场的恢复工作。调用DialogFragment的setArguments(bundle)方法进行数据的设置，可以保证DialogFragment的数据也能恢复。


- 话框中的事件怎么传递给Fragment问题
- 一个Activity有多个Fragment调用显示对话框的方法，在Activity的实现了对话框接口的方法里怎样区分不同的Fragment调用者？可以在BaseActivity显示对话框的方法里加个id参数，用id来区分不同的Fragment调用者。

作者：牛晓伟
链接：https://www.jianshu.com/p/af6499abd5c2
