---
title: Vector、ArrayList、LinkedList的区别
date: 2018-06-29T16:29:42.000Z
categories: java
tag: java
toc: true
---

# 相同点

三者都是实现集合框架中的List,是有序集合,它们功能较为相似,比如都提供按照位置进行定位、添加或者删除操作,都提供迭代器进行遍历.

# 不同点

## 底层实现及使用场景

-   Vector和ArrayList作为动态数组,内部元素是由数组形式顺序存储的,非常适合随机访问的场景.
-   Vector与arrayList可以根据场景需求动态的调整容量,两者不同的是,Vector内部使用对象数组来保存数据,当扩容时会创建新的数组,并拷贝原有数据.ArrayList是
-   LinkedList实质是一个双向链表结构,不需要调整容量.

## 性能

-   ArrayList对元素的增加和删除都会引起数组的内存分配空间动态发生变化。因此，检索速度很快,但是对其进行插入和删除速度较慢，当然这个前提是不包含尾部插入和删除元素的场景.
-   LinkedList在进行节点插入、删除的场景效率相对高很多,但是随机访问的性能比动态数组要差.

## 线程安全

-   Vector是Java早期提共的线程安全动态数组,是基于synchronized实现的线程安全的ArrayList,如果不需要线程安全,不建议选择,同步是需要额外开销的.
-   ArrayList和LinkedList都是非线程安全

  单线程应尽量使用ArrayList，Vector因为同步会有会有性能损耗；即使在多线程环境下，我们可以利用Collections这个类中为我们提供的synchronizedList(List list)方法返回一个线程安全的同步列表对象。
