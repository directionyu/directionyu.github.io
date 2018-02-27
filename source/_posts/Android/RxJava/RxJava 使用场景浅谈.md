---
title: RxJava 常用的几种方法
date: 2016-12-01 20:32:22   
categories: Android   
tag: RxJava
toc: true  
---



- Observable和Subscriber可以做任何事情 Observable可以是一个数据库查询，Subscriber用来显示查询结果；Observable可以是屏幕上的点击事件，Subscriber用来响应点击事件；Observable可以是一个网络请求，Subscriber用来显示请求结果。


- Observable和Subscriber是独立于中间的变换过程的。 在Observable和Subscriber中间可以增减任何数量的map。整个系统是高度可组合的，操作数据是一个很简单的过程。 下面是自己收集和总结的Rx常用方法。提供参考。

```Java
需要引入的依赖包,这个依赖包依赖于RxJava和RxAndroid,会自动引入进来,也可以自己手动单独的引入。
compile 'com.jakewharton.rxbinding:rxbinding:0.4.0'

/**
 * Scheduler线程切换
 * <p>
 * 这种场景经常会在“后台线程取数据，主线程展示”的模式中看见
 */
private void rj1() {
    Observable.just(1, 2, 3, 4)
            .subscribeOn(Schedulers.io())//指定subscribe()发生在IO线程
            .observeOn(AndroidSchedulers.mainThread())//指定Subscriber回调发生在主线程
            .subscribe(new Action1<Integer>() {
                @Override
                public void call(Integer integer) {
                    KLog.d(integer);
                }
            });
}
/**
 * 使用debounce做textSearch
 * <p>
 * 当N个结点发生的时间太靠近（即发生的时间差小于设定的值T），debounce就会自动过滤掉前N-1个结点。
 * <p>
 * 比如在做百度地址联想的时候，可以使用debounce减少频繁的网络请求。避免每输入（删除）一个字就做一次联想
 * <p>
 * Toolbar使用RxToolbar监听点击事件; Snackbar使用RxSnackbar监听;
 * EditText使用RxTextView监听; 其余使用RxView监听.
 */
private void rj2(TextView textView) {
    RxTextView.textChangeEvents(textView)
            .debounce(400, TimeUnit.MILLISECONDS)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(new Subscriber<TextViewTextChangeEvent>() {
                @Override
                public void onCompleted() {
                    KLog.d("onCompleted");
                }

                @Override
                public void onError(Throwable e) {
                    KLog.d(e.toString());
                }

                @Override
                public void onNext(TextViewTextChangeEvent textViewTextChangeEvent) {
                    KLog.d(textViewTextChangeEvent.toString());
                }
            });
}
/**
 * 使用combineLatest合并最近N个结点
 * <p>
 * 例如：注册的时候所有输入信息（邮箱、密码、电话号码等）合法才点亮注册按钮。
 */
private void rj3(TextView tvEmail, TextView tvPassword, TextView tvNumber) {
    Observable<CharSequence> email = RxTextView.textChanges(tvEmail).skip(1);
    Observable<CharSequence> password = RxTextView.textChanges(tvPassword).skip(1);
    Observable<CharSequence> number = RxTextView.textChanges(tvNumber).skip(1);
    Observable.combineLatest(email, password, number, new Func3<CharSequence, CharSequence, CharSequence, Boolean>() {
        @Override
        public Boolean call(CharSequence email, CharSequence password, CharSequence number) {
            boolean emailValid = !StrUtils.isBlank(email.toString());
            boolean passwordValid = !StrUtils.isBlank(password.toString());
            boolean numberValid = !StrUtils.isBlank(number.toString());

            if (!emailValid) {
                KLog.d("emailValid error");
            }
            if (!passwordValid) {
                KLog.d("passwordValid error");
            }
            if (!numberValid) {
                KLog.d("numberValid error");
            }

            return emailValid && passwordValid && numberValid;
        }
    }).subscribe(new Subscriber<Boolean>() {
        @Override
        public void onCompleted() {
            KLog.d("onCompleted");
        }

        @Override
        public void onError(Throwable e) {
            KLog.d(e.toString());
        }

        @Override
        public void onNext(Boolean o) {
            KLog.d(o);
        }
    });
}
/**
 * 使用merge合并两个数据源。
 * <p>
 * 界面需要等到多个接口并发取完数据，再更新
 * 例如一组数据来自网络，一组数据来自文件，需要合并两组数据一起展示。
 */
private void rj4() {
    Observable.merge(HttpAchieve.getHttp(""), HttpAchieve.getHttp(""))
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(new Subscriber<IdCode>() {
                @Override
                public void onCompleted() {
                    KLog.d("onCompleted");
                }

                @Override
                public void onError(Throwable e) {
                    KLog.d(e.toString());
                }

                @Override
                public void onNext(IdCode idCode) {
                    KLog.d("onNext");
                }
            });
}
/**
 * 使用concat和first做缓存
 * <p>
 * 依次检查memory、disk和network中是否存在数据，任何一步一旦发现数据后面的操作都不执行。
 */
private void rj5() {
    Observable<String> memory = Observable.create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            String memoryCache = "";//这里只是声明一个变量,你可以自己做检查内存是否存在
            if (memoryCache != null) {
                subscriber.onNext(memoryCache);
            } else {
                subscriber.onCompleted();
            }
        }
    });
    Observable<String> disk = Observable.create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            String cachePref = "";//cachePref =rxPreferences.getString("cache").get(); //这里获取SD卡数据
            if (StrUtils.isBlank(cachePref)) {
                subscriber.onCompleted();
            } else {
                subscriber.onNext(cachePref);
            }
        }
    });
    Observable<String> network = Observable.just("network");
    //一次检查memory, disk, network
    Observable.concat(memory, disk, network)
            .first()
            .subscribeOn(Schedulers.newThread())
            .subscribe(s -> {
                KLog.d(s);
            });
}
/**
 * 使用timer做定时操作。当有“x秒后执行y操作”类似的需求的时候，想到使用timer
 * <p>
 * 例如：2秒后输出日志“hello world”，然后结束。
 */
private void rj6() {
    Observable.timer(2, TimeUnit.SECONDS)
            .subscribe(new Subscriber<Long>() {
                @Override
                public void onCompleted() {
                    KLog.d("onCompleted");
                }

                @Override
                public void onError(Throwable e) {
                    KLog.d(e.toString());
                }

                @Override
                public void onNext(Long aLong) {
                    KLog.d(aLong);
                }
            });
}
/**
 * 使用interval做周期性操作。当有“每隔xx秒后执行yy操作”类似的需求的时候，想到使用interval
 * <p>
 * 例如：每隔2秒输出日志“helloworld”。
 */
private void rj7() {
    Observable.interval(2, TimeUnit.SECONDS)
            .subscribe(new Subscriber<Long>() {
                @Override
                public void onCompleted() {
                    KLog.d("onCompleted");
                }

                @Override
                public void onError(Throwable e) {
                    KLog.d(e.toString());
                }

                @Override
                public void onNext(Long aLong) {
                    KLog.d(aLong);
                }
            });
}

/**
 * 使用throttleFirst防止按钮重复点击
 * <p>
 * debounce也能达到同样的效果
 */
private void rj8(Button button) {
    RxView.clicks(button)
            .throttleFirst(1, TimeUnit.SECONDS)
            .subscribe(new Subscriber<Object>() {
                @Override
                public void onCompleted() {
                    KLog.d("onCompleted");
                }

                @Override
                public void onError(Throwable e) {
                    KLog.d(e.toString());
                }

                @Override
                public void onNext(Object o) {
                    KLog.d(o);
                }
            });
}

/**
 * 使用schedulePeriodically做轮询请求
 */
private void rj9() {
    Observable.create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            Schedulers.newThread().createWorker().schedulePeriodically(new Action0() {
                @Override
                public void call() {
                    subscriber.onNext("");
                }
            }, 0, 1000, TimeUnit.MILLISECONDS);//0初始间隔,1000轮询间隔,时间模式
        }
    }).subscribe(new Action1<String>() {
        @Override
        public void call(String s) {

        }
    });
}

/**
 * RxJava进行数组、list的遍历
 */
private void rj10() {
    String[] names = {"Tom", "Lily", "Alisa", "Sheldon", "Bill"};
    Observable.from(names)
            .subscribe(new Action1<String>() {
                @Override
                public void call(String s) {
                    KLog.d(s);
                }
            });
}

/**
 * 一个接口的请求依赖另一个API请求返回的数据
 * <p>
 * 举个例子，我们经常在需要登陆之后，根据拿到的token去获取消息列表。
 */
private void rj11(String idCode) {
    Api.getInstance().movieService.login(idCode)//请求用户的数据
            .flatMap(s ->
                    Api.getInstance().movieService.login(idCode)//通过用户的数据请求消息列表
            )
            .subscribe(s -> {
                KLog.d(s);
            });
}

/**
 * 循环输出元素,过滤不满足条件的,最多输出5个结果,输出之后做额外的操作
 */
private void rj12() {
    String[] strings = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
    Observable.just(strings)
            .flatMap(new Func1<String[], Observable<String>>() {
                @Override
                public Observable<String> call(String[] strings) {
                    return Observable.from(strings);
                }
            })
            .filter(new Func1<String, Boolean>() { //过滤掉不等于空的
                @Override
                public Boolean call(String s) {
                    return !StrUtils.isBlank(s);
                }
            })
            .take(5) // 只输出5次
            .doOnNext(new Action1<String>() {
                @Override
                public void call(String s) {
                    KLog.d("在这里做额外的操作");
                }
            })
            .subscribe(new Action1<String>() {
                @Override
                public void call(String s) {
                    KLog.d(s);
                }
            });
}

/**
 * 按钮的长按时间监听
 */
private void rj13(Button button) {
    RxView.longClicks(button)
            .subscribe(new Action1<Void>() {
                @Override
                public void call(Void aVoid) {
                    KLog.d("call");
                }
            });
}

/**
 * ListView 的点击事件、长按事件处理
 */
private void rj14(ListView listView) {
    //item点击事件
    RxAdapterView.itemClicks(listView)
            .subscribe(new Action1<Integer>() {
                @Override
                public void call(Integer integer) {
                    KLog.d("ListView点击事件");
                }
            });
}

/**
 * ListView 的点击事件、长按事件处理
 */
private void rj15(ListView listView) {
    //item 长按事件
    RxAdapterView.itemLongClicks(listView)
            .subscribe(new Action1<Integer>() {
                @Override
                public void call(Integer integer) {
                    KLog.d("ListView点击事件");
                }
            });
}

/**
 * 响应式编程,选中后做响应的处理,
 * <p>
 * 用户登录界面,勾选通用协议,登录按钮就高亮显示
 */
private void rj16(CheckBox checkBox) {
    RxCompoundButton.checkedChanges(checkBox)
            .subscribe(new Action1<Boolean>() {
                @Override
                public void call(Boolean aBoolean) {
                    KLog.d("在这里设置Button可点击高亮显示");
                }
            });
}
```
