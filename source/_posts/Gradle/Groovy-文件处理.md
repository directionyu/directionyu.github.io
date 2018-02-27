---
title: Groovy-文件处理
date: 2018-01-16T15:34:13.000Z
categories: Groovy
tag: Groovy
toc: true
---

# 遍历某文件夹内文件并进行文本查找与替换

## 遍历文件夹内所有文件并查找与替换

```groovy
def static replaceDirFileText(String src, String dest, File dir){
    def fileText
    dir.eachFileRecurse(
        {file ->
            if(file.isFile()){
                fileText = file.text;
                fileText = fileText.replaceAll(src, dest)
                file.write(fileText, “utf-8”);
            }
        }
    )
}
```

<!-- more -->

 ## 遍历指定类型文件并查找与替换

```groovy
def static replaceDirFileText(String src, String dest, File dir){
    def fileText
    //Replace the text in special file types
    //def backupFile
    def exts = [".java", ".xml"]
    dir.eachFileRecurse(
        {file ->
            for (ext in exts){
                if (file.name.endsWith(ext)) {
                    fileText = file.text;
                    //backupFile = new File(file.path + ".bak");
                    //backupFile.write(fileText);
                    fileText = fileText.replaceAll(src, dest)
                    file.write(fileText, "utf-8");
                }
            }
        }
    )
}
```

# 文件/文件夹复制

## Java实现

```java
public static void copyFile(File sourceFile, File targetFile) throws IOException {
        BufferedInputStream inBuff = null;
        BufferedOutputStream outBuff = null;
        try {
            // 新建文件输入流并对它进行缓冲
            inBuff = new BufferedInputStream(new FileInputStream(sourceFile));
            // 新建文件输出流并对它进行缓冲
            outBuff = new BufferedOutputStream(new FileOutputStream(targetFile));
            // 缓冲数组
            byte[] b = new byte[1024 * 5];
            int len;
            while ((len = inBuff.read(b)) != -1) {
                outBuff.write(b, 0, len);
            }
            // 刷新此缓冲的输出流
            outBuff.flush();
        }catch (Exception e){
            println e
            e.printStackTrace()
        }finally {
            // 关闭流
            if (inBuff != null)
                inBuff.close();
            if (outBuff != null)
                outBuff.close();
        }
    }
    public static void copyDirectiory(String sourceDir, String targetDir) throws IOException {
        try {
            // 新建目标目录
            (new File(targetDir)).mkdirs();
            // 获取源文件夹当前下的文件或目录
            File[] file = (new File(sourceDir)).listFiles();
            for (int i = 0; i < file.length; i++) {
                if (file[i].isFile()) {
                    // 源文件
                    File sourceFile=file[i];
                    // 目标文件
                    File targetFile=new File(new File(targetDir).getAbsolutePath() + File.separator+file[i].getName());
                    copyFile(sourceFile,targetFile);
                }
                if (file[i].isDirectory()) {
                    // 准备复制的源文件夹
                    String dir1=sourceDir + "/" + file[i].getName();
                    // 准备复制的目标文件夹
                    String dir2=targetDir + "/"+ file[i].getName();
                    copyDirectiory(dir1, dir2);
                }
            }
        }catch (Exception e){
            println e
            e.printStackTrace()
        }
    }
```

## Groovy实现

### 复制到另外一个目录

```groovy
  String sourceDir = SOURCE_DIR_PATH
  String destinationDir = DESTINATION_DIR_PATH
  new AntBuilder().copy(todir: destinationDir) {
      fileset(dir: sourceDir)
  }
```

### 复制到另外一个目录排除一些文件

```groovy
String sourceDir = SOURCE_DIR_PATH
String destinationDir = DESTINATION_DIR_PATH
new AntBuilder().copy(todir: destinationDir) {
    fileset(dir : sourceDir) {
        exclude(name:"*.java")
    }
}
new AntBuilder().copy(todir: "E:/2") {
    fileset(dir : "E:/1") {
        include(name:"**/*.java")
        exclude(name:"**/*Test.java")
    }
}
```

### 将一个文件从一个目录复制到另一个目录

```groovy
  String sourceFilePath = SOURCE_FILE_PATH
  String destinationFilePath = DESTINATION_FILE_PATH
  (new AntBuilder()).copy(file: sourceFilePath, tofile: destinationFilePath)
```
