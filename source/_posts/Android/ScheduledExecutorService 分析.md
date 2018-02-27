---
title: ScheduledExecutorService 分析
date: 2017-11-29T18:11:29.000Z
categories: Java
tag: Java 并发
toc: true
---

> An ExecutorService that can schedule commands to run after a given delay, or to execute periodically. The schedule methods create tasks with various delays and return a task object that can be used to cancel or check execution. The scheduleAtFixedRate and scheduleWithFixedDelay methods create and execute tasks that run periodically until cancelled.

> Commands submitted using the Executor.execute(java.lang.Runnable) and ExecutorService submit methods are scheduled with a requested delay of zero. Zero and negative delays (but not periods) are also allowed in schedule methods, and are treated as requests for immediate execution.

> All schedule methods accept relative delays and periods as arguments, not absolute times or dates. It is a simple matter to transform an absolute time represented as a Date to the required form. For example, to schedule at a certain future date, you can use: schedule(task, date.getTime() - System.currentTimeMillis(), TimeUnit.MILLISECONDS). Beware however that expiration of a relative delay need not coincide with the current Date at which the task is enabled due to network time synchronization protocols, clock drift, or other factors. The Executors class provides convenient factory methods for the ScheduledExecutorService implementations provided in this package.
