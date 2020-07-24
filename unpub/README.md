# Unpub

本项目fork修改自字节的[unpub](https://github.com/bytedance/unpub)，主要用于内部的packages的发布下载及仓库页面的展示；

## 使用

### 发布

对于要发布的package的`pubspec.yaml`，需要填写以下相关信息

```yaml
# 名称
name: tuya_test_flutter 
# 描述
description: A Flutter package for test private pub.dev.
# 版本号
version: 0.0.6
# 作者的邮箱，这里强制要求是以@tuya.com结尾的企业邮箱
author: xc.fang@tuya.com
# 私有pub的地址
publish_to: http://some-package-server.com:port
# 项目的主页地址
homepage: https://google.com
```



在需要发布的package根项目下,使用如下命令

```bash
 // http://pubHost:port替换为仓库地址
 flutter packages pub publish --server=http://some-package-server.com:port   
```

需要注意如下要点：

- 发布时会检测此目录下是否存在`pubspec.yaml`，所以需要到`pubspec.yaml`运行上述命令
- 发布时后台会校验项目是否已`tuya_`前缀开头，作者字段（author）是否是以`@tuya.com`为结尾

### 依赖

在要依赖此package的项目的`pubspec.yaml`中，添加如下代码进行依赖

```yaml
dependencies:
  tuya_test_flutter:
    hosted:
      name: tuya_test_flutter
      url: http://some-package-server.com
    version: ^1.0.0
```

然后使用如下命令进行拉取

```bash
flutter packages get
```



## 项目结构

项目当中有2个子项目，其中**unpub**是服务端代码，数据存储用的是`Mongodb`，HTTP服务器框架使用的是`shelf`;

而**unpub_web**是基于[`AngularDart`](https://angulardart.dev/)的Web应用。

对应的UML图如下所示

![unpub](/Users/fxc/Desktop/unpub.jpg)



## 开发调试

### 前端（unpub_web）

当你对`unpub_web`这个模块的代码进行修改完毕之后，直接运行项目根目录下的`pre_publish.sh`然后在对应的控制台上输出的网址进行查看。

### 服务端（unpub）

当你对`unpub`这个模块的代码进行修改之后，需要运行此模块下面的`run_unpub.sh`或者手动运行以下命令

```bash
dart 项目根目录/unpub/example/main.dart
```

然后在对应的控制台上输出的网址进行查看。