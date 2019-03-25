---
title: Android设备唯一标识
date: 2018-07-26T23:56:22.000Z
categories: Android
tag: Android
toc: true
---

# IMEI 码
IMEI（国际移动设备识别码）唯一编号，用于识别 GSM，WCDMA手机以及一些卫星电话（移动设备识别码）全球唯一编号，用于识别CDMA移动电台设备的物理硬件，MEID出现的目的是取代ESN号段（电子序列号）（电子序列号）唯一编号，用于识别CDMA手机（国际移动用户识别码）与所有GSM和UMTS网络手机用户相关联的唯一识别编号如需要检索设备的ID，在项目中要使用以下代码：

```java
/**
 * 获取手机IMEI号
 *
 * 6.0 以上需要动态权限: android.permission.READ_PHONE_STATE
 */
public static String getImei(Context context) {
    TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        return tm != null ? tm.getImei() : "";
    }
    return tm != null ? tm.getDeviceId() : "";
}
```
它有3个缺点:

1）需要android.permission.READ_PHONE_STATE权限，它在6.0+系统中是需要动态申请的。如果需求要求App启动时上报设备标识符的话，那么第一会影响初始化速度，第二还有可能被用户拒绝授权。

2）android系统碎片化严重，有的手机可能拿不到DeviceId，会返回null或者000000。

3）这个方法是只对有电话功能的设备有效的，在pad上不起作用。 可以看下方法注释/**

```java
/**
* Returns the unique device ID, for example, the IMEI for GSM and the MEID
* or ESN for CDMA phones. Return null if device ID is not available.
*
* <p>Requires Permission:
*   {@link android.Manifest.permission#READ_PHONE_STATE READ_PHONE_STATE}
*/
public String getDeviceId() {
   try {
       ITelephony telephony = getITelephony();
       if (telephony == null)
           return null;
       return telephony.getDeviceId(mContext.getOpPackageName());
   } catch (RemoteException ex) {
       return null;
   } catch (NullPointerException ex) {
       return null;
   }
}
```

# AndroidId

在设备首次启动时，系统会随机生成一个64位的数字，并把这个数字以16进制字符串的形式保存下来。不需要权限，平板设备通用。获取成功率也较高，缺点是设备恢复出厂设置会重置。另外就是某些厂商的低版本系统会有bug，返回的都是相同的AndroidId。
厂商定制系统的Bug：不同的设备可能会产生相同的ANDROID_ID：9774d56d682e549c。
厂商定制系统的Bug：有些设备返回的值为null。
设备差异：对于CDMA设备，ANDROID_ID telephonyManager.getDeviceId() 返回相同的值。
它在Android <=2.1 or Android >=2.3的版本是可靠、稳定的，但在2.2的版本并不是100%可靠的。
通常被认为不可信，因为它有时为null。开发文档中说明了：这个ID会改变如果进行了出厂设置。并且，如果某个Andorid手机被Root过的话，这个ID也可以被任意改变。获取方式如下：

```java
public static String getAndroidId (Context context) {
    String ANDROID_ID = Settings.System.getString(context.getContentResolver(), Settings.System.ANDROID_ID);
    return ANDROID_ID;
}
```

# Serial Number
Android系统2.3版本以上可以通过下面的方法得到Serial Number，且非手机设备也可以通过该接口获取。不需要权限，通用性也较高，但有些手机显示异常，也不一定靠谱。
```java
String SerialNumber = android.os.Build.SERIAL;
```


# Mac地址

可以使用手机Wifi或蓝牙的MAC地址作为设备标识。
属于Android系统的保护信息，高版本系统获取的话容易失败，返回0000000

硬件限制：并不是所有的设备都有Wifi和蓝牙硬件，硬件不存在自然也就得不到这一信息。
添加权限：ACCESS_WIFI_STATE
获取到的，不是一个真实的地址，而且这个地址能轻易地被伪造。wLan不必打开，就可读取些值。

```java

    /**
     * Return the MAC address.
     * <p>Must hold
     * {@code <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />},
     * {@code <uses-permission android:name="android.permission.INTERNET" />}</p>
     *
     * @return the MAC address
     */
    @RequiresPermission(allOf = {ACCESS_WIFI_STATE, INTERNET})
    public static String getMacAddress(Context context, final String... excepts) {
        String macAddress = getMacAddressByWifiInfo(context);
        if (isAddressNotInExcepts(macAddress, excepts)) {
            return macAddress;
        }
        macAddress = getMacAddressByNetworkInterface();
        if (isAddressNotInExcepts(macAddress, excepts)) {
            return macAddress;
        }
        macAddress = getMacAddressByInetAddress();
        if (isAddressNotInExcepts(macAddress, excepts)) {
            return macAddress;
        }
        macAddress = getMacAddressByFile();
        if (isAddressNotInExcepts(macAddress, excepts)) {
            return macAddress;
        }
        return "";
    }

```

# SimSerialNum

显而易见，只能用在插了Sim的设备上，通用性不好。而且需要android.permission.READ_PHONE_STATE权限

# 生成UUID，并保存至系统数据库中

如果上述方式都不能获取到唯一编码，可尝试使用UUID将其保存到系统数据库中，这样卸载之后，这个值还在；但6.0 以后需要动态申请权限，慎用。

```java
/**
 * 得到全局唯一UUID，保存数据到系统数据库中：Settings.System
 */
public static String getUUID(Context context) {
    String uniqueIdentificationCode = "";
    //首先判断系统版本，高于6.0，则需要动态申请权限
    if (Build.VERSION.SDK_INT >= 23) {
        if (!Settings.System.canWrite(context)) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS,
                    Uri.parse("package:" + getPackageName()));
            context.startActivity(intent);
        } else {
            uniqueIdentificationCode = Settings.System.getString(context.getContentResolver(), "uniqueIdentificationCode");
        }
    } else {
        //获取系统配置文件中的数据，第一个参数固定的，但是需要上下文，第二个参数是之前保存的Key，第三个参数表示如果没有这个key的情况的默认值
        uniqueIdentificationCode = Settings.System.getString(context.getContentResolver(), "uniqueIdentificationCode");
    }

    if (TextUtils.isEmpty(uniqueIdentificationCode)) {
        uniqueIdentificationCode = System.currentTimeMillis() + UUID.randomUUID().toString().substring(20).replace("-", "");
        //设置系统配置文件中的数据，第一个参数固定的，但是需要上下文，第二个参数是保存的Key，第三个参数是保存的value
        Settings.System.putString(context.getContentResolver(), "uniqueIdentificationCode", uniqueIdentificationCode);
    }
    Log.i("getDeviceUuidId", "getDeviceUuidId: uniqueIdentificationCode = " + uniqueIdentificationCode);

    return uniqueIdentificationCode;
}

```

# 总结
综上述，AndroidId 和 Serial Number 的通用性都较好，并且不受权限限制，如果刷机和恢复出厂设置会导致设备标识符重置这一点可以接受的话，那么将他们组合使用时，唯一性就可以应付绝大多数设备了。

```java
String androidID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
String id = androidID + Build.SERIAL;
```

但还可以优化一下。直接暴露用户的设备信息并不是一个好的选择，既然我需要的只是一个唯一标识，那么将他们转化成Md5即可，格式也更整齐。

```java
private static String toMD5(String text) throws NoSuchAlgorithmException {
        //获取摘要器 MessageDigest
        MessageDigest messageDigest = MessageDigest.getInstance("MD5");
        //通过摘要器对字符串的二进制字节数组进行hash计算
        byte[] digest = messageDigest.digest(text.getBytes());

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < digest.length; i++) {
            //循环每个字符 将计算结果转化为正整数;
            int digestInt = digest[i] & 0xff;
            //将10进制转化为较短的16进制
            String hexString = Integer.toHexString(digestInt);
            //转化结果如果是个位数会省略0,因此判断并补0
            if (hexString.length() < 2) {
                sb.append(0);
            }
            //将循环结果添加到缓冲区
            sb.append(hexString);
        }
        //返回整个结果
        return sb.toString();
    }
```
