---
title: Android 应用管理解析
date: 2016-12-16T11:49:42.000Z
categories: Android
tag: Android
toc: true
---

# 认识PackageManager

PackageManage.class 是对所有基于加载信息的数据结构的封装，包括以下功能：

- 安装
- 卸载应用
- 查询permission相关信息
- 查询Application相关信息(application，activity，receiver，service，provider及相应属性等）
- 查询已安装应用 增加
- 删除permission
- 清除用户数据缓存

非查询相关的API需要特定的权限，具体的API请参考SDK文档。

# 获取已安装的应用列表及其缓存大小

```java
@Override
    public Subscription scanSysCacheTask(Subscriber<AppModel> response) {
        return Observable.create(new Observable.OnSubscribe<ApplicationInfo>() {
            @Override
            public void call(Subscriber<? super ApplicationInfo> subscriber) {
                List<ApplicationInfo> infoList = getPackageManager().getInstalledApplications(PackageManager.GET_META_DATA
                        |PackageManager.GET_SHARED_LIBRARY_FILES
                        |PackageManager.MATCH_UNINSTALLED_PACKAGES
                        |PackageManager.MATCH_SYSTEM_ONLY
                        |PackageManager.MATCH_DISABLED_UNTIL_USED_COMPONENTS
                        |PackageManager.GET_DISABLED_UNTIL_USED_COMPONENTS
                        |PackageManager.GET_UNINSTALLED_PACKAGES);
                for (int i = 0; i < infoList.size(); i++) {
                    ApplicationInfo applicationInfo = infoList.get(i);
                    subscriber.onNext(applicationInfo);
                }
                subscriber.onCompleted();
            }
        }).map(new Func1<ApplicationInfo, appModel>() {
            @Override
            public AppModel call(final ApplicationInfo applicationInfo) {
                final AppModel appModel = new AppModel();
                try {
                    Method getPackageSizeInfo = getPackageManager().getClass().getMethod("getPackageSizeInfo", String.class, IPackageStatsObserver.class);
                    getPackageSizeInfo.invoke(getPackageManager(), applicationInfo.packageName, new IPackageStatsObserver.Stub() {
                        @Override
                        public void onGetStatsCompleted(PackageStats pStats, boolean succeeded) throws RemoteException {
                            long appCacheSize = pStats.cacheSize + pStats.externalCacheSize;
                            appModel.setTrashSize(appCacheSize);
                        }
                    });
                } catch (Exception e) {
                    e.getMessage();
                }
                return AppModel;
            }
        }).onBackpressureBuffer()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(response);
    }
```



# 应用安装与卸载广播

- android系统中，安装和卸载都会发送出相应的广播，当应用安装完成后系统会发android.intent.action.PACKAGE_ADDED广播,卸载程序时系统发android.intent.action.PACKAGE_REMOVED广播。可以通过intent.getDataString()获得所安装的包名。

示例

```java
public class MyReceiver extends BroadcastReceiver {          

    @Override         
    public void onReceive(Context context, Intent intent) {  

        //接收广播：系统启动完成后运行程序  
if (intent.getAction().equals("android.intent.action.BOOT_COMPLETED")) {          
             Intent newIntent = new Intent(context, xxxActivity.class);          
             newIntent.setAction("android.intent.action.MAIN");             
             newIntent.addCategory("android.intent.category.LAUNCHER");           
             newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);             
             context.startActivity(newIntent);          
        }  

        //接收广播：设备上新安装了一个应用程序包后自动启动新安装应用程序  
if (intent.getAction().equals("android.intent.action.PACKAGE_ADDED")) {          
            String packageName = intent.getDataString().substring(8);          
            System.out.println("---------------" + packageName);  

            Intent newIntent = new Intent();          
            newIntent.setClassName(packageName,packageName+ ".MainActivity");          
            newIntent.setAction("android.intent.action.MAIN");                   
            newIntent.addCategory("android.intent.category.LAUNCHER");                   
            newIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);          
            context.startActivity(newIntent);          
        }          
        //接收广播：设备上删除了一个应用程序包。          
if (intent.getAction().equals("android.intent.action.PACKAGE_REMOVED")) {          
            System.out.println("********************************");          
            //DatabaseHelper dbhelper = new DatabaseHelper();          
            //dbhelper.executeSql("delete from xxx");          
        }  

    }
```

备注：需要修改AndroidManifest.xml配置

```xml
<?xml version="1.0" encoding="UTF-8"?>         
<manifest xmlns:android="http://schemas.android.com/apk/res/android"         
     package="app.ui">  

    <application>         
        <receiver android:name=".MyReceiver"         
                  android:label="@string/app_name">         
            <intent-filter>         
                <action android:name="android.intent.action.BOOT_COMPLETED"/>         
                <category android:name="android.intent.category.LAUNCHER" />         
            </intent-filter>  

            <intent-filter>         
             <action android:name="android.intent.action.PACKAGE_ADDED" />         
             <action android:name="android.intent.action.PACKAGE_REMOVED" />         
             <data android:scheme="package" />         
        <!-- 注意！！ 这句必须要加，否则接收不到BroadCast -->       
            </intent-filter>         
        </receiver>  

        <activity android:name=".xxxActivity" android:label="XXX">         
            <intent-filter>         
                <action android:name="android.intent.action.MAIN"/>         
                <category android:name="android.intent.category.LAUNCHER"/>         
            </intent-filter>         
        </activity>  

    </application>  

    <uses-permission android:name="android.permission.INTERNET" />         
    <uses-permission android:name="android.permission.RESTART_PACKAGES"/>         
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>         
</manifest>
```
