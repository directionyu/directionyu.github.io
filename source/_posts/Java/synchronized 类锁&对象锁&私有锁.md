---
title: synchronized 类锁&对象锁&私有锁
date: 2019-2-12 T00:00:42.000Z
categories: java
tag: java
toc: true
---

# 类锁

synchronized 类锁是作用于静态方法或者某一个具体的类上的锁。

## 语法

-   作用于静态方法

    ```Java
    synchronized public static void methodA() {
        // code
    }
    ```

-   作用与类

    ```Java
    synchronized(Object.class) {
      // code
    }
    ```

# 对象锁

对象锁即作用于普通方法上（非静态）、类对象、this关键字上的锁

-   修饰普通方法

```Java
synchronized public void methodB() {
    // code
}
```

-   修饰this关键字

  ```Java
  synchronized(this) {
      // code
  }
  ```

# 私有锁

synchronized 私有锁即在类内部声明一个声明一个对象锁lock，在需要加锁的代码块中使用synchronized(obj)来加锁

## 语法

  ```Java
  public class Test {
      // 套餐的奇妙
      private Object lock = new Object();
      private int i = 0;
      public void count(){
          // 加锁
          synchronized(lock){
              i++;
          }
      }
  }
  ```

# 三种锁比较结论

-   类锁&对象锁：多线程运行过程中，类锁与对象锁不产生锁竞争、各自运行、互不影响
-   对象锁&私有锁：多线程运行过程中，对象锁&私有锁不产生锁竞争、各自运行、互不影响
-   对象锁&对象锁：synchronized(this)和synchronized public void method（）都是在当前对象上加锁，且形成了锁竞争关系，同一时刻只能有一个方法能执行。
