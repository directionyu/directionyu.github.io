
背景

在 Android Http API 请求开发中经常遇到这样的需求：每一次请求带上一个或者多个固定不变的参数，例如：

设备唯一标识：device_id = 7a4391e28f309c21
业务唯一标识：uid = 2231001
平台类型：platform = android
客户端版本号：version_code = 6
…
这些参数是每一次发生请求都需要的，我们姑且称他们为公共参数（或者基础参数）。公共参数一般以 header line、url query 或者 post body(较少) 这些形式插入请求。

实现

如果使用 OkHttp 作为 http request client, 这件事情就变得简单多了。OkHttp 提供了强大的拦截器组件 (Interceptor):

Interceptors are a powerful mechanism that can monitor, rewrite, and retry calls.

也就是说，OkHttp 的拦截器功能之一就是对将要发出的请求进行拦截、改造然后再发出。这正是我们想要的。BasicParamsInterceptor 实现了 okhttp3.Interceptor 接口。

实现 public Response intercept(Chain chain) throws IOException 方法。使用 Builder 模式，暴露以下接口：

addParam(String key, String value)

post 请求，且 body type 为 x-www-form-urlencoded 时，键值对公共参数插入到 body 参数中，其他情况插入到 url query 参数中。

addParamsMap(Map paramsMap)

同上，不过这里用键值对 Map 作为参数批量插入。

addHeaderParam(String key, String value)

在 header 中插入键值对参数。

addHeaderParamsMap(Map headerParamsMap)

在 header 中插入键值对 Map 集合，批量插入。

addHeaderLine(String headerLine)

在 header 中插入 headerLine 字符串，字符串需要符合 -1 != headerLine.indexOf(“:”) 的规则，即可以解析成键值对。

addHeaderLinesList(List headerLinesList)

同上，headerLineList: List 为参数，批量插入 headerLine。

addQueryParam(String key, String value)

插入键值对参数到 url query 中。

addQueryParamsMap(Map queryParamsMap)

插入键值对参数 map 到 url query 中，批量插入。

示例

使用 Buider 模式创建 Interceptor 对象，然后调用 OkHttp 的 addInterceptor(Interceptor i) 方法将 interceptor 对象添加至 client 中：

BasicParamsInterceptor basicParamsInterceptor =
        new OkPublicParamsInterceptor.Builder()
                .addHeaderParam("device_id", DeviceUtils.getDeviceId())
                .addParam("uid", UserModel.getInstance().getUid())
                .addQueryParam("api_version", "1.1")
                .build();
OkHttpClient client = new OkHttpClient.Builder()
        .addInterceptor(basicParamsInterceptor)
        .build();
TODO


源码与引用：https://github.com/jkyeo/okhttp-basicparamsinterceptor
