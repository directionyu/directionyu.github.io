---
title: 解析FragmentStatePagerAdapter与FragmentPagerAdapter
date: 2016-12-16 14:16:12   
categories: Android   
tag: Android
toc: true  
---

Android提供了FragmentStatePagerAdapter与FragmentPagerAdapter两种适配器来让ViewPager与Fragment进行联动
# 定义
## FragmentStatePagerAdapter
1. API注释
```XML
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
 * Subclasses only need to implement {@link #getItem(int)}
 * and {@link #getCount()} to have a working adapter.
 *
 * Here is an example implementation of a pager containing fragments of lists:
 */
```
<!--more-->

## FragmentPagerAdapter
1. API注释
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
 * Subclasses only need to implement {@link #getItem(int)}
 * and {@link #getCount()} to have a working adapter.
 *
 * Here is an example implementation of a pager containing fragments of lists:
 */
```
翻译：


# 区别

# 怎么使用
