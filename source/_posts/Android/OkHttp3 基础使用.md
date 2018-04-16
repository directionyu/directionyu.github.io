---
title: OkHttp基础使用
date: 2017-03-12T13:02:32.000Z
categories: Java
tag: 'Java,OkHttp'
toc: true
---

# 特点

1.  Http/2支持多路复用
2.  采用连接池减少请求延迟
3.  支持GZip压缩
4.  支持websocket
5.  多ip切换(服务有多个IP地址对应，OkHttp会在首次连接失败的时候尝试其他地址。)
6.  缓存Response以减少网络去做完全重复的请求
7.  它会静默从常见的连接问题中恢复
8.  OkHttp使用现代的TLS features (SNI, ALPN) 来初始化连接, 并在握手失败的时候倒回到TLS 1.0
9.  OkHttp还用了Okio来做快速I/O和可调整大小的buffer

# 超时

> okhttp超时分为连接超时、读取超时、写入超时

```java
OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .readTimeout(25, TimeUnit.SECONDS)
                .writeTimeout(25, TimeUnit.SECONDS)
                .connectTimeout(25, TimeUnit.SECONDS)
                .pingInterval(25, TimeUnit.SECONDS) // websocket 轮训间隔
                .build();
```

# Cookie保持

> Cookie的保存也提供了快捷方式，当然也可以通过拦截器自己实现

<!-- more -->

```java
OkHttpClient okHttpClient = new OkHttpClient.Builder()
              .cookieJar(new CookieJar() {
                  @Override
                  public void saveFromResponse(HttpUrl url, List<Cookie> cookies) {
                // 保存cookie通常使用SharedPreferences
                  }

                  @Override
                  public List<Cookie> loadForRequest(HttpUrl url) {
                    // 从保存位置读取，注意此处不能为空，否则会导致空指针
                      return new ArrayList<>();
                  }
              })
              .build();
```

-   使用张鸿洋大神开源的OkHttpUtils课轻松实现cookie保持


```

```

# 拦截器

-   okhttp3的实现使用的是链式的拦截器，同时也开放了自定义拦截器接口

```java
//打印请求Log
HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
// set your desired log level,,,,mm,
logging.setLevel(HttpLoggingInterceptor.Level.BODY);
okHttpClient = new OkHttpClient.Builder()
                    .addInterceptor(logging)//
                    .build();
```

```java
OkHttpClient okHttpClient = new OkHttpClient.Builder()
  // 此种拦截器将会在请求开始的时候调用
        .addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
              // 略
                return null;
            }
        })
  // 连接成功，读写数据前调用
        .addNetworkInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
              // 略
                return null;
            }
        })
        .build();
```

# Https

-   okhttp3完全支持https，只要设置好证书即可

```java
OkHttpClient okHttpClient = new OkHttpClient.Builder()
        // 创建一个证书工厂
        .sslSocketFactory(SSLSocketFactory, X509TrustManager)
        .build();
```

-   使用OkHttpUtils

```java
InputStream inputStream = null;
inputStream = context.getResources().openRawResource(R.raw.ssl_certificate);//证书路径
HttpsUtils.SSLParams sslParams = HttpsUtils.getSslSocketFactory(null, inputStream, null);

OkHttpClient okHttpClient = new OkHttpClient.Builder()
        // 创建一个证书工厂
        .sslSocketFactory(sslParams.sSLSocketFactory, sslParams.trustManager)
        .build();
```

# GET

```java
//创建OkHttpClient
```

# POST

```java

```

# Websocket

-   okhttp3支持websocket，如果不了解请自行搜索，简易推送，轮训都可以使用。
-   websocket协议首先会发起http请求，握手成功后，转换协议保持长连接，类似心跳
