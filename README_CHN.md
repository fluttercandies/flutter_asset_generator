# flutter_asset_generator

在 lib/const/resource.dart 中 自动生成 R 文件(仿安卓短命名)

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

## 截图

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## 安装

添加 pub,dart 到 path 环境变量下

参阅 https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path 添加`.pub-cache/bin` 至环境变量下

保证
dart --version
pub --version 有正确的输出

### pub global

pub global activate flutter_asset_generator

## 使用

### 使用 dart

dart bin/resource_generator.dart ./example/

### 使用 pub global(推荐)

参阅[官方文档](https://www.dartlang.org/tools/pub/cmd/pub-global)

在 flutter 目录下执行

```bash
fgen .
```

注意这个`.` , 这里第二个目录就是你的 flutter 目录, 可以省略,省略后默认在当前文件夹

## 关于文件名

转化的例子如下

    images/1.png => IMAGES_PNG
    images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG

会包含文件夹名称的原因是你 pubspec 中可能会包含多个文件夹目录, 或你的文件夹会包含多层级，甚至你的资产目录中会包含非图片（如数据库，json 等）资产

如下情况会出现错误

```bash
  images/
    main_login.png
    main/
      login.png
```

因为两个的字段命名方式是完全相同的
