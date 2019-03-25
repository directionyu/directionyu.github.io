---
title: 解决Permissions 0755 for ':root:.ssh:id_rsa' are too open
date: 2019-03-05T19:35:29.000Z
categories: Android
tags:
  - Android
  - Gradle
toc: true
---

```Java
Permissions 0755 for '/xxxx/jenkins/.ssh/id_rsa' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
bad permissions: ignore key: /xxxx/jenkins/.ssh/id_rsa
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

原因是密钥文件权限不能777,只能700.

解决方法:

```shell
sudo chmod -R 700 ~/.ssh/*
```
