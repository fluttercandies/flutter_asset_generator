# flutter_asset_generator

在 lib/const/resource.dart 中 自动生成 R 文件(仿安卓短命名)

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

## 截图

![img](https://github.com/CaiJingLong/some_asset/blob/master/flutter_resource_generator.gif)

## 安装

在你项目的 pubspec.yaml
根据节点添加如下的配置

```yaml
dev_dependencies:
  flutter_resource_generator: ^0.1.0
```

## 使用

在命令行使用 `flutter packages pub run build_runner build` 命令去开启,没有其他任何的操作
这个程序会在后台监测你的
不同于其他的 `runner_build`项目,这里是阻塞的,敲击后需要手动点 ctrl+c/cmd+c 去结束当前的命令行

## 其他

只要你定义在 pubspec.yaml 中,这个库会监听所有的资源文件

the R class filed name is Camel-Case,and convert the like '.png' to the 'DotPng'. And the '\_' will ignore.

R 类的字段采用驼峰类型的命名,关键字是 Dot,把你文件名中的'.png'转化为'DotPng',"\_"会被忽略,因为下划线被认为是分隔符

转化的例子如下

    images/1.png => images1DotPng
    images/hello_world.jpg => imagesHelloWorldDotPng
    images/hello_wordl_dot_jpg => imagesHelloWorldDotPng

会包含文件夹名称的原因是你 pubspec 中可能会包含多个文件夹目录

所以你的文件名中如果包含 dot 字符,会显的很奇怪

## TODO

添加自定义文件名的模板
