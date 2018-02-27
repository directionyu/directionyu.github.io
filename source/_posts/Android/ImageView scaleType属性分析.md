---
title: ImageView scaleType属性分析
date: 2016-10-08T16:11:29.000Z
categories: Android
tag: ImageView
toc: true
---

# ImageView scaleType 属性

scaleType    | 描述
------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------
center       | 将图片中心与 ImageView 的中心重合，保持图片的原始尺寸，只显示落在 ImageView 内部的图片部分
centerCrop   | 将图片中心与 ImageView 的中心重合，然后进行等比例缩放，直到图片宽高均不小于 ImageView 的宽高，位于 ImageView 之外的图片部分不显示，缩放过程中保持图片宽高比
centerInside | 将图片中心与 ImageView 的中心重合，如果图片全部位于 ImageView 内部，则完成，否则对图片等比例缩小直到图片宽高均不大于ImageView 的宽高
fitCenter    | 将图片中心与 ImageView 的中心重合，然后等比例进行缩放，直到图片宽高均不大于 ImageView 的宽高；fitCenter 与 centerInside 的区别在于：当图片原始尺寸小于 ImageView 时，后者不对图片做任何处理而前者对图片进行等比例放大直至其宽高至少有一项与 ImageView 对应的宽高相等
fitStart     | 将图片左上角与 ImageView 的左上角重合，其余和 fitCenter 相同
fitEnd       | 将图片右下角与 ImageView 的右下角重合，其余和 fitCenter 相同
fitXY        | 将图片的宽高缩放到与 ImageView 的宽高完全相同；缩放过程完全无视原始图片的宽高比
matrix       | 根据 setImageMatrix() 方法设置的 Matrix 类来显示图片，Matrix 类可以用来实现图片翻转等效果

由上述图表可以看出，scaleType 可分为 3 大类：center，fit，matrix：

以 center 开头的值表示将图片中心和 ImageView 中心重合，然后保持原始尺寸（center）或将图片缩放到圈在 ImageView 内部（centerInside）或将图片放大到覆盖 ImageView（centerCrop）； 以 fit 开头的值表示将图片的宽高缩放到至少有一项与 ImageView 的宽高相同，根据双方对准的起点分为中心（fitCenter）、左上角（fitStart）、右下角（fitEnd）或无起点（fitXY）；

scaleType    | 图片和ImageView中心点重合 | 保持图片原始尺寸 | 保持图片宽高比 | 显示图片与 ImageView 大比较
------------ | ----------------- | -------- | ------- | -----------------------
center       | √                 | √        | √       | 同图片原始尺寸和 ImageView 大小关系
centerCrop   | √                 | x        | √       | >=
centerInside | √                 | x        | √       | <=
fitCenter    | √                 | x        | √       | <=
fitStart     | x                 | x        | √       | <=
fitEnd       | x                 | x        | √       | <=
fitXY        | √                 | x        | x       | =
