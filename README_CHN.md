# flutter_asset_generator

在 lib/const/resource.dart 中 自动生成 R 文件(仿安卓短命名)

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

- [flutter_asset_generator](#flutterassetgenerator)
  - [截图](#%E6%88%AA%E5%9B%BE)
  - [安装及使用](#%E5%AE%89%E8%A3%85%E5%8F%8A%E4%BD%BF%E7%94%A8)
    - [使用源码的方式](#%E4%BD%BF%E7%94%A8%E6%BA%90%E7%A0%81%E7%9A%84%E6%96%B9%E5%BC%8F)
    - [pub global](#pub-global)
  - [关于文件名](#%E5%85%B3%E4%BA%8E%E6%96%87%E4%BB%B6%E5%90%8D)

## 截图

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## 安装及使用

### 使用源码的方式

添加 dart 至环境变量

```bash
git clone https://github.com/CaiJingLong/flutter_resource_generator.git
cd flutter_resource_generator
dart bin/resource_generator.dart ./example
```

`./example` 是 flutter 项目的地址

### pub global

比较推荐这种方式, pub global 的详情参阅[官方文档](https://www.dartlang.org/tools/pub/cmd/pub-global)

添加 pub,dart 到 `$PATH` 环境变量下, 如果不添加也可以, 使用 dart,pub 全路径也可以

参阅 https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path 添加`~/.pub-cache/bin` 至环境变量下(window 请查阅文档)

保证

```bash
dart --version
pub --version
```

有正确的输出

安装:
`$ pub global activate flutter_asset_generator`

**使用**:
在 flutter 目录下执行

```bash
fgen .
```

注意这个`.` , 这里第二个目录就是你的 flutter 目录, 可以省略,省略后默认在当前文件夹

也就是在 flutter 项目下使用`$ fgen`即可

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
