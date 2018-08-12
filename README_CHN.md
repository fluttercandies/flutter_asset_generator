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
  build_runner: ^0.9.0
  flutter_resource_generator: ^0.1.2
```

## 使用

在命令行使用 `flutter packages pub run build_runner build` 命令去开启,没有其他任何的操作

~~这个程序会在后台监测你的 flutter 资源文件夹和 pubspec.yaml 文件,当添加了新的资源文件或 pubspec.yaml 发生变化时,会自动刷新 resource.dart 文件~~

~~不同于其他的 `runner_build`项目,这里是阻塞的,敲击后需要手动点 ctrl+c/cmd+c 去结束当前的命令行~~

0.2.0改动：

如同其他的build库一样，现在可以正常的使用build/watch命令

但作为代价，现在使用者必须自己定义一个`build.yaml`在项目中，因为dart官方的 build库只会默认扫描下列列表的文件，这个列表来源于官方文档`https://www.dartlang.org/tools/pub/package-layout`，而这其中不包含images这样的目录

幸运的是，官方提供了定义方法，我们需要在项目下加入`build.yaml`文件,文件内容如下

```yaml
targets:
  $default:
    sources:
      - images/**
      - pubspec.*
```

这里需要注意 images/** 是你的自定义图片/资源的位置

pubspec.*是官方建议必须加入的一个文件。这个会帮助dart tool更好的运行

你也可以直接下载文件

[build.yaml](https://github.com/CaiJingLong/flutter_resource_generator/releases/download/v0.2.0/build.yaml)

## 其他

这个库会转化所有定义在 pubspec.yaml 中的文件/文件夹,而不仅是图片

R 类的字段采用驼峰类型的命名,关键字是 Dot,如'.png'转化为'DotPng',"\_"会被忽略,因为下划线被认为是分隔符

转化的例子如下

    images/1.png => images1DotPng
    images/hello_world.jpg => imagesHelloWorldDotPng
    images/hello_wordl_dot_jpg => imagesHelloWorldDotPng

会包含文件夹名称的原因是你 pubspec 中可能会包含多个文件夹目录

所以你的文件名中如果包含 dot 字符,会显的很奇怪

## TODO

添加自定义文件名的模板
