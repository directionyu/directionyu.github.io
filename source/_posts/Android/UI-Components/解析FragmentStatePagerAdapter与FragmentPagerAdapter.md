---
title: 解析FragmentStatePagerAdapter与FragmentPagerAdapter
date: 2016-12-16T14:16:12.000Z
categories: Android
tag: Android
toc: true
---

Android提供了FragmentStatePagerAdapter与FragmentPagerAdapter两种适配器来让ViewPager与Fragment进行联动

# 定义

## FragmentStatePagerAdapter

-   API注释

    ```xml
    /**
    * Implementation of {@link PagerAdapter} that
    * uses a {@link Fragment} to manage each page. This class also handles
    * saving and restoring of fragment's state.
    *
    * This version of the pager is more useful when there are a large number
    * of pages, working more like a list view.  When pages are not visible to
    * the user, their entire fragment may be destroyed, only keeping the saved
    * state of that fragment.  This allows the pager to hold on to much less
    * memory associated with each visited page as compared to
    * {@link FragmentPagerAdapter} at the cost of potentially more overhead when
    * switching between pages.
    *
    * When using FragmentPagerAdapter the host ViewPager must have a
    * valid ID set.</p>
    *
    */
    ```

    <!-- more -->

## FragmentPagerAdapter

-   API注释

    ```xml
    /**
    * Implementation of {@link PagerAdapter} that
    * represents each page as a {@link Fragment} that is persistently
    * kept in the fragment manager as long as the user can return to the page.
    *
    * This version of the pager is best for use when there are a handful of
    * typically more static fragments to be paged through, such as a set of tabs.
    * The fragment of each page the user visits will be kept in memory, though its
    * view hierarchy may be destroyed when not visible.  This can result in using
    * a significant amount of memory since fragment instances can hold on to an
    * arbitrary amount of state.  For larger sets of pages, consider
    * {@link FragmentStatePagerAdapter}.
    *
    * When using FragmentPagerAdapter the host ViewPager must have a
    * valid ID set.</p>
    *
    */
    ```

    注释中用法已经写的很明白，FragmentPagerAdapter会将访问的每个fragment保存在内存中，带来的好处就是频繁切换时非常迅速，但大量使用时会占用大量内存，而FragmentStatePagerAdapter在fragment不可见时使用少量内存保存当前状态，但是频繁切换时会有更多的开销。

# 区别

两者功能的实质都是用来管理fragment，那么最核心的机制自然是fragment存储/恢复与销毁，从这个角度切入来学习两个类的不同。

## 存储和恢复

-   FragmentPagerAdapter

    1.  先从创造看起

        ```java
        public Object instantiateItem(ViewGroup container, int position) {
           if (mCurTransaction == null) {
               mCurTransaction = mFragmentManager.beginTransaction();
           }

           final long itemId = getItemId(position);

           // Do we already have this fragment?5让
           // 这里给fragment命名
           String name = makeFragmentName(container.getId(), itemId);
           // 根据名字在FragmentManager中找对应的fragment
           Fragment fragment = mFragmentManager.findFragmentByTag(name);
           if (fragment != null) {
               if (DEBUG) Log.v(TAG, "Attaching item #" + itemId + ": f=" + fragment);
               mCurTransaction.attach(fragment);
           } else {
               //  getItem是一个抽象方法，在继承类中具体实现，当前position的fragment不存在时才会走这一步去找对象
               fragment = getItem(position);
               if (DEBUG) Log.v(TAG, "Adding item #" + itemId + ": f=" + fragment);
               mCurTransaction.add(container.getId(), fragment,
                       makeFragmentName(container.getId(), itemId));
           }
           if (fragment != mCurrentPrimaryItem) {
               fragment.setMenuVisibility(false);
               FragmentCompat.setUserVisibleHint(fragment, false);
           }

           return fragment;
        }
        ```

        重点看下makeFragmentName()这个方法

```java
private static String makeFragmentName(int viewId, long id) {
    return "android:switcher:" + viewId + ":" + id;
}
```

每个fragment通过父容器Id以及getItemId返回值组合成唯一命名，通过键值对的方式放入fragmentManager中，从而实现存储和恢复fragment的功能，这种方式带来一个缺陷就是如果当fragment列表顺序发生改变，比如添加或删除fragment，就会导致崩溃。

1.  销毁

    ```java
    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
     if (mCurTransaction == null) {
         mCurTransaction = mFragmentManager.beginTransaction();
     }
     if (DEBUG) Log.v(TAG, "Detaching item #" + getItemId(position) + ": f=" + object
             + " v=" + ((Fragment)object).getView());
     mCurTransaction.detach((Fragment)object);
    }
    ```

    在销毁方法里，仅仅是将fragment detach掉，并没有进行销毁，所以fragment仍然在manager中保存，占用的内存并没有释放，这就解释了为什么说FragmentPagerAdapter不适合fragment数量多的情况。

2.  FragmentStatePagerAdapter

3.  创造

    ```java
    public Object instantiateItem(ViewGroup container, int position) {
     // If we already have this item instantiated, there is nothing
     // to do.  This can happen when we are restoring the entire pager
     // from its saved state, where the fragment manager has already
     // taken care of restoring the fragments we previously had instantiated.
     if (mFragments.size() > position) {
         Fragment f = mFragments.get(position);
         if (f != null) {
             return f;
         }
     }

     if (mCurTransaction == null) {
         mCurTransaction = mFragmentManager.beginTransaction();
     }
     // 因为fragment频繁的创建导致这个getItem方法会被多次调用 区别于FragmentPagerAdapter  
     Fragment fragment = getItem(position);
     if (DEBUG) Log.v(TAG, "Adding item #" + position + ": f=" + fragment);
     if (mSavedState.size() > position) {
       //从存储fragment的列表中取出对应位置fragment保存的状态  
         Fragment.SavedState fss = mSavedState.get(position);
         if (fss != null) {
           //将之前fragment状态赋予新的fragment  
             fragment.setInitialSavedState(fss);
         }
     }
     while (mFragments.size() <= position) {
         mFragments.add(null);
     }
     fragment.setMenuVisibility(false);
     FragmentCompat.setUserVisibleHint(fragment, false);
     mFragments.set(position, fragment);
     mCurTransaction.add(container.getId(), fragment);

     return fragment;
    }
    ```

    从源码清楚看到FragmentStatePagerAdapter是通过mFragments数组来存储fragment的，通过mSavedState列表来存储fragment销毁时的状态，每次初始化对应position的fragment时调用getItem方法重新创建新的fragment，然后将mSavedState中存储的状态重新赋予这个新的fragment，达到fragment恢复的效果。而mFragment与mSavedState是按顺序一一对应的，每当一个fragment重建都会set对应的状态，如果mFragment数组中某个fragment的顺序发生改变，那么fragment与savedSate便不会一一对应，导致出现异常。

4.  销毁

    ```java
    public void destroyItem(ViewGroup container, int position, Object object) {
     Fragment fragment = (Fragment) object;

     if (mCurTransaction == null) {
         mCurTransaction = mFragmentManager.beginTransaction();
     }
     if (DEBUG) Log.v(TAG, "Removing item #" + position + ": f=" + object
             + " v=" + ((Fragment)object).getView());
     while (mSavedState.size() <= position) {
         mSavedState.add(null);
     }
     //释放引用之前保存该位置fragment的状态
     mSavedState.set(position, fragment.isAdded()
             ? mFragmentManager.saveFragmentInstanceState(fragment) : null);
     //将mFragment列表中该位置的fragment置空，释放引用  
     mFragments.set(position, null);
     //同时将manager中的该fragment释放  
     mCurTransaction.remove(fragment);
    }
    ```

    源码中看到，当fragment在页面不可见时，先将对应的状态保存到mSaveState中，然后fragment实例才会被销毁，从而达到节省内存开销的作用。
