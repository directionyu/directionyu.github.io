---
title: RxJava 使用背压解决数据发送过快异常
date: 2017-02-11 04:12:29   
categories: Android   
tag: RxJava
toc: true  
---


Rx 中的数据流是从一个地方发射到另外一个地方。每个地方处理数据的速度是不一样的。如果生产者发射数据的速度比消费者处理的快会出现什么情况？在同步操作中，这不是个问题，例如

```java
// Produce
  Observable<Integer> producer = Observable.create(o -> {
      o.onNext(1);
      o.onNext(2);
      o.onCompleted();
  });
  // Consume
  producer.subscribe(i -> {
      try {
          Thread.sleep(1000);
          System.out.println(i);
      } catch (Exception e) { }
  });
```

<!--more-->

虽然上面的消费者处理数据的速度慢，但是由于是同步调用的，所以当 o.onNext(1) 执行后，一直阻塞到消费者处理完才执行 o.onNext(2)。 但是生产者和消费者异步处理的情况很常见。如果是在异步的情况下会出现什么情况呢？

在传统的 pull 模型中，当消费者请求数据的时候，如果生产者比较慢，则消费者会阻塞等待。如果生产者比较快，则生产者会等待消费者处理完后再生产新的数据。

而 Rx 为 push 模型。 在 Rx 中，只要生产者数据好了就发射出去了。如果生产者比较慢，则消费者就会等待新的数据到来。如果生产者快，则就会有很多数据发射给消费者，而不管消费者当前有没有能力处理数据。这样会导致一个问题，例如：


```java
  Observable.interval(1, TimeUnit.MILLISECONDS)
      .observeOn(Schedulers.newThread())
      .subscribe(
          i -> {
              System.out.println(i);
              try {
                  Thread.sleep(100);
              } catch (Exception e) { }
          },
          System.out::println);
```
结果：

``` java
0
1
rx.exceptions.MissingBackpressureException
```

上面的 MissingBackpressureException 告诉我们，生产者太快了，我们的操作函数无法处理这种情况。

消费者的补救措施

有些操作函数可以减少发送给消费者的数据。

过滤数据

sample 操作函数可以指定生产者发射数据的最大速度，多余的数据被丢弃了。
