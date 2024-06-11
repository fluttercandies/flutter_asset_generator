# flutter_asset_generator

[English](README.md) | 中文文档

在 lib/const/resource.dart 中 自动生成 R 文件(仿安卓短命名)

- [flutter\_asset\_generator](#flutter_asset_generator)
  - [截图](#截图)
  - [安装及使用](#安装及使用)
    - [使用源码的方式](#使用源码的方式)
    - [通过 pub global 运行](#通过-pub-global-运行)
    - [支持的命令行参数](#支持的命令行参数)
  - [关于文件名](#关于文件名)
  - [配置文件](#配置文件)
    - [排除和导入](#排除和导入)
    - [替换规则](#替换规则)
      - [典型示例](#典型示例)
    - [其他配置选项](#其他配置选项)

## 截图

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## 安装及使用

### 使用源码的方式

添加 `dart` 至环境变量

```bash
git clone https://github.com/fluttercandies/flutter_asset_generator
cd flutter_asset_generator
dart pub get
dart bin/asset_generator.dart $flutter_project
```

### 通过 pub global 运行

1. 参阅 [pub global][] 官方文档添加 `~/.pub-cache/bin` 至环境变量下：

```bash
dart pub global activate flutter_asset_generator

# 或

dart pub global activate -s git https://github.com/fluttercandies/flutter_asset_generator.git                 
```

1. 在项目目录下执行：

```bash
fgen
```

或者

```bash
fgen -s $flutter_project
```

### 支持的命令行参数

使用 `$ fgen -h` 或 `$ fgen --help` 可以查看帮助文档

```bash
fgen -h
-w, --[no-]watch    Continue to monitor changes after execution of orders.
                    (defaults to on)

-p, --[no-]preview  Generate file with preview comments.
                    (defaults to on)

-o, --output        Your resource file path.
                    If it's a relative path, the relative flutter root directory
                    (defaults to "lib/const/resource.dart")

-s, --src           Flutter project root path
                    (defaults to ".")

-n, --name          The class name for the constant.
                    (defaults to "R")

-h, --[no-]help     Help usage

-d, --[no-]debug    debug info
```

-s 是 flutter 目录

-o 是生成的资源文件地址,需要包含`.dart`

如果你在 flutter 目录下执行, 仅需 fgen 即可

可以加 --no-watch 参数来不监听文件变化,仅生成一次资源文件

## 关于文件名

文件中的空格、`/`、`-`、`.` 会被转为 `_`，`@` 会被转为 `_AT_`。

转化的例子如下

```log
images/1.png => IMAGES_PNG
images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG
images/hello-world.jpg => IMAGES_HELLO_WORLD_JPG
```

会包含文件夹名称的原因是你 pubspec 中可能会包含多个文件夹目录, 或你的文件夹会包含多层级，甚至你的资产目录中会包含非图片（如数据库，json 等）资产

如下情况会出现错误

```bash
images/
├── main_login.png
├── main/
    ├── login.png
```

因为两个的字段命名方式是完全相同的

## 配置文件

配置文件为约定式，**不支持**通过命令指定，该文件为项目根目录下（与`pubspec.yaml`同级）下的`fgen.yaml`

### 排除和导入

使用`glob`语法

其中 `exclude` 节点下为排除的文件名，类型是字符串数组，如未包含任何规则则表示不排除任何文件

`include` 表示需要导入的文件名，字符串数组，如果未包含任何规则表示允许所有

优先级方面，exclude 高于 include，换句话说：

先根据 include 节点导入文件，然后 exclude 排除文件

### 替换规则

文件名支持在配置文件中进行替换，如下所示：

```yaml

replace:
  - from: “
    to: 
  - from: ”
    to: 
  - from: ’
    to:
  - from: (
    to:
  - from: )
    to:
  - from: "!"
    to:
```

#### 典型示例

```yaml
exclude:
  - "**/add*.png"
  - "**_**"

include:
  - "**/a*.png"
  - "**/b*"
  - "**/c*"
```

```sh
assets
├── address.png           # exclude by "**/add*.png"
├── address@at.png        # exclude by "**/add*.png"
├── bluetoothon-fjdfj.png
├── bluetoothon.png
└── camera.png
images
├── address space.png     # exclude by "**/add*.png"
├── address.png           # exclude by "**/add*.png"
├── addto.png             # exclude by "**/add*.png"
├── audio.png
├── bluetooth_link.png    # exclude by **_**
├── bluetoothoff.png
├── child.png
└── course.png
```

```dart
/// Generate by [asset_generator](https://github.com/fluttercandies/flutter_asset_generator) library.
/// PLEASE DO NOT EDIT MANUALLY.
class R {
  const R._();

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/assets/bluetoothon-fjdfj.png)
  static const String ASSETS_BLUETOOTHON_FJDFJ_PNG = 'assets/bluetoothon-fjdfj.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/assets/bluetoothon.png)
  static const String ASSETS_BLUETOOTHON_PNG = 'assets/bluetoothon.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/assets/camera.png)
  static const String ASSETS_CAMERA_PNG = 'assets/camera.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/images/audio.png)
  static const String IMAGES_AUDIO_PNG = 'images/audio.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/images/bluetoothoff.png)
  static const String IMAGES_BLUETOOTHOFF_PNG = 'images/bluetoothoff.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/images/child.png)
  static const String IMAGES_CHILD_PNG = 'images/child.png';

  /// ![preview](file:///Users/jinglongcai/code/dart/self/flutter_resource_generator/example/images/course.png)
  static const String IMAGES_COURSE_PNG = 'images/course.png';
}
```

### 其他配置选项

从 1.1.0 开始：

支持通过配置选项达到和命令行选项相同的效果，但命令行优先级高于配置文件。

```yaml
watch: false
# watch: true

preview: false

output: lib/const/r.dart
# output: lib/const/resource.dart

name: RRR
```

[pub global]: https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path
