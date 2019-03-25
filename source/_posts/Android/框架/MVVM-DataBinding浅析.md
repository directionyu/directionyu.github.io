---
title: MVVM-DataBinding浅析
date: 2018-06-5T15:16:32.000Z
categories: Android
tag: Android
toc: true
---

# 什么是Data Binding

DataBinding是一个实现数据和UI绑定的框架，是实现MVVM模式的工具，而MVVM中的VM（ViewModel）和View可以通过DataBinding来实现数据绑定（目前已支持双向绑定）。

# 能做什么?

1.  XML中实现控件绑定,能实现简单逻辑,减少view id 的定义,数据绑定直接发生在xml
2.  简化Activity && Fragment 内的UI操作代码.

# 使用场景

data binding的意义主要数据的变动可以自动触发UI界面的刷新。但是如果我们使用的是传统的java bean对象的时候，是没有办法实现“数据变更触发ui界面”的目的的。而 Bindable 注解就是帮助我们完成这个任务的。

如果我们要实现“数据变更触发ui界面”的话，途径主要有两个：

-   继承 BaseObservable ，使用 Bindable 注解field的getter并且在调用setter的使用使用 OnPropertyChangedCallback#onPropertyChanged
-   使用data-binding library当中提供的诸如 ObservableField&lt;>, ObservableInt作为属性值

<!-- more -->

# 优势

 UI代码放到了xml中，布局和数据更紧密
 性能超过手写代码
 保证执行在主线程

# 劣势

 IDE支持还不那么完善（提示、表达式）
 报错信息不那么直接
 重构支持不好（xml中进行重构，java代码不会自动修改）

# 使用

```groovy
android {
    …
    dataBinding {
        enabled = true
    }
}
```

## layout

布局根节点必须是<layout> . 同时layout只能包含一个View标签. 不能直接包含<merge>

```XML
<layout>
	// 原来的layout
</layout>
```

在xml的最外层套上layout标签即可，修改后就可以看到生成了该布局对应的\*Binding类。

## data

<data>标签的内容即DataBinding的数据. data标签只能存在一个.
layout tag
把一个普通的layout变成data binding layout也只要几行的修改:

## variable

通过<variable>标签可以指定类, 然后在控件的属性值中就可以使用

```XML
<data>
	<variable name="user" type="com.liangfeizc.databindingsamples.basic.User" />
</data>
```

通过DataBinding的setxx()方法可以给Variable设置数据. name值不能包含\_下划线

## import

第二种写法(导入), 默认导入了java/lang包下的类(String/Integer). 可以直接使用被导入的类的静态方法.

```XML
<data>
  <!--导入类-->
    <import type="com.liangfeizc.databindingsamples.basic.User" />
  <!--因为User已经导入, 所以可以简写类名-->
    <variable name="user" type="User" />
</data>
```

## class

<data>标签有个属性<class>可以自定义DataBinding生成的类名以及路径

```XML
<!--自定义类名-->
<data class="CustomDataBinding"></data>

<!--自定义生成路径以及类型-->
<data class=".CustomDataBinding"></data> <!--自动在包名下生成包以及类-->
```

# Binding生成规则

默认生成规则：xml通过文件名生成，使用下划线分割大小写。
比如activity_demo.xml，则会生成ActivityDemoBinding，item_search_hotel则会生成ItemSearchHotelBinding。

view的生成规则类似，只是由于是类变量，首字母不是大写，比如有一个TextView的id是first_name，则会生成名为firstName的TextView。

我们也可以自定义生成的class名字，只需要：

```XML
<data class=“ContactItem”>
…
</data>
```

# 表达式

算术 + - / \* %
字符串合并 +
逻辑 && ||
二元 & | ^
一元 + - ! ~
移位 >> >>> &lt;&lt;
比较 == > &lt; >= &lt;=
Instanceof
Grouping ()
文字 - character, String, numeric, null
Cast
方法调用
Field 访问
Array 访问 \[]
三元 ?:
空合并运算符: android:text=“@{user.displayName ?? user.lastName}”

android:marginLeft="@{@dimen/margin + @dimen/avatar_size}"

组合字符串
android:text="@{@string/nameFormat(firstName, lastName)}"
<string name="nameFormat">%s, %s</string>

# 避免空指针

data binding会自动帮助我们进行空指针的避免，比如说@{employee.firstName}，如果employee是null的话，employee.firstName则会被赋默认值（null）。int的话，则是0。

需要注意的是数组的越界，毕竟这儿是xml而不是java，没地方让你去判断size的。

# include

对于include的布局，使用方法类似，不过需要在里面绑定两次，外面include该布局的layout使用bind:user给set进去。

这里需要注意的一点是，被include的布局必须顶层是一个ViewGroup，目前Data Binding的实现，如果该布局顶层是一个View，而不是ViewGroup的话，binding的下标会冲突（被覆盖），从而产生一些预料外的结果。

## <include> 引入的页面怎样加载点击事件

```XML
<variable
            name="clickListener"
            type="android.view.View.OnClickListener" />

<include layout="@layout/diy_back_title" bind:clickListener="@{clickListener}" bind:title="@{title}"/>
```

diy_back_title.xml

```XML
<variable    name="clickListener"    type="android.view.View.OnClickListener" />

android:onClick="@{clickListener}"
```

```Java
binding.setClickListener(this);
@Override
public void onClick(View v) {
    switch (v.getId()){...}
}
```

# ViewStubs

ViewStub比较特殊，在被实际inflate前是不可见的，所以使用了特殊的方案，用了final的ViewStubProxy来代表它，并监听了ViewStub.OnInflateListener:

```java
private OnInflateListener mProxyListener = new OnInflateListener() {
    @Override
    public void onInflate(ViewStub stub, View inflated) {
        mRoot = inflated;
        mViewDataBinding = DataBindingUtil.bind(mContainingBinding.mBindingComponent,
                inflated, stub.getLayoutResource());
        mViewStub = null;
        if (mOnInflateListener != null) {
            mOnInflateListener.onInflate(stub, inflated);
            mOnInflateListener = null;
        }
        mContainingBinding.invalidateAll();
        mContainingBinding.forceExecuteBindings();
    }
};
```

在onInflate的时候才会进行真正的初始化。

# Observable Fields

如果所有要绑定的都需要创建Observable类，那也太麻烦了。所以Data Binding还提供了一系列Observable，包括 ObservableBoolean, ObservableByte, ObservableChar, ObservableShort, ObservableInt, ObservableLong, ObservableFloat, ObservableDouble, 和ObservableParcelable。我们还能通过ObservableField泛型来申明其他类型，如：

```java
private static class User {
   public final ObservableField<String> firstName =
       new ObservableField<>();
   public final ObservableField<String> lastName =
       new ObservableField<>();
   public final ObservableInt age = new ObservableInt();
}
```

而在xml中，使用方法和普通的String，int一样，只是会自动刷新，但在java中访问则会相对麻烦：

```java
user.firstName.set("Google");
int age = user.age.get();
```

相对来说，每次要get/set还是挺麻烦，私以为还不如直接去继承BaseObservable。

# Observable Collections

有一些应用使用更动态的结构来保存数据，这时候我们会希望使用Map来存储数据结构。Observable提供了ObservableArrayMap:

```java
ObservableArrayMap<String, Object> user = new ObservableArrayMap<>();
user.put("firstName", "Google");
user.put("lastName", "Inc.");
user.put("age", 17);
```

# 动态变量

有时候，我们并不知道具体生成的binding类是什么。比如在RecyclerView中，可能有多种ViewHolder，而我们拿到的holder只是一个基类（这个基类具体怎么写下篇中会提到），这时候，我们可以在这些item的layout中都定义名字同样的variable，比如item，然后直接调用setVariable：

```java
public void onBindViewHolder(BindingHolder holder, int position) {
   final T item = mItems.get(position);
   holder.getBinding().setVariable(BR.item, item);
   holder.getBinding().executePendingBindings();
}
```

executePendingBindings会强制立即刷新绑定的改变。

# 表达式链

## 重复的表达式

```XML
<ImageView android:visibility=“@{user.isAdult ? View.VISIBLE : View.GONE}”/>
<TextView android:visibility=“@{user.isAdult ? View.VISIBLE : View.GONE}”/>
<CheckBox android:visibility="@{user.isAdult ? View.VISIBLE : View.GONE}"/>
```

可以简化为:

```XML
<ImageView android:id=“@+id/avatar”
 android:visibility=“@{user.isAdult ? View.VISIBLE : View.GONE}”/>
<TextView android:visibility=“@{avatar.visibility}”/>
<CheckBox android:visibility="@{avatar.visibility}"/>
```

## 隐式更新

```XML
<CheckBox android:id=”@+id/seeAds“/>
<ImageView android:visibility=“@{seeAds.checked ?
  View.VISIBLE : View.GONE}”/>
```

这样CheckBox的状态变更后ImageView会自动改变visibility。

## Lambda表达式

除了直接使用方法引用，在Presenter中写和OnClickListener一样参数的方法，我们还能使用Lambda表达式:

```XML
android:onClick=“@{(view)->presenter.save(view, item)}”
android:onClick=“@{()->presenter.save(item)}”
android:onFocusChange=“@{(v, fcs)->presenter.refresh(item)}”
```

我们还可以在lambda表达式引用view id（像上面表达式链那样），以及context。

## 使用建议

1.  尽量在项目中进行尝试，只有在不断碰到业务的需求时，才会在真正的场景下使用并发现Data Binding的强大之处。
2.  摸索xml和java的界限，不要以为Data Binding是万能的，而想尽办法把逻辑写在xml中，如果你的同事没法一眼看出这个表达式是做什么的，那可能它就应该放在Java代码中，以ViewModel的形式去承担部分逻辑。
3.  Lambda表达式/测试时注入等Data Binding的高级功能也可以自己多试试，尤其是注入，相当强大。
4.  callback绑定只做事件传递，NO业务逻辑
5.  保持表达式简单（不要做过于复杂的字符串、函数调用操作）

参考资料：

> [1][markzhai's home](<http://blog.zhaiyifan.cn/2016/07/06/android-new-project-from-0-p8/>)
