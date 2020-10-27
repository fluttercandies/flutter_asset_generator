# flutter_asset_generator

在 lib/const/resource.dart 中 自动生成 R 文件(仿安卓短命名)

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

- [flutter_asset_generator](#flutter_asset_generator)
  - [截图](#截图)
  - [安装及使用](#安装及使用)
    - [使用源码的方式](#使用源码的方式)
    - [pub global](#pub-global)
    - [支持的命令行参数](#支持的命令行参数)
  - [关于文件名](#关于文件名)
  - [配置文件](#配置文件)
    - [排除和导入](#排除和导入)
      - [典型示例](#典型示例)

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

参阅 [官方文档][pub global] 添加`~/.pub-cache/bin` 至环境变量下(window 请查阅文档)

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
fgen
```

or

```bash
fgen -s .
```

注意这个`.` , 这里第二个目录就是你的 flutter 目录, 可以省略,省略后默认在当前文件夹

也就是在 flutter 项目下使用`fgen`即可

### 支持的命令行参数

使用 `$ fgen -h` 或 `$ fgen --help` 可以查看帮助文档

```bash
fgen -h
-w, --[no-]watch      Continue to monitor changes after execution of orders.
                      (defaults to on)
-o, --output          Your resource file path.
                      If it's a relative path, the relative flutter root directory
                      (defaults to "lib/const/resource.dart")
-s, --src             Flutter project root path
                      (defaults to ".")
-h, --[no-]help       Help usage
-d, --[no-]debug      debug info
-p, --[no-]preview    Enable preview comments, defaults to true, use --no-preview to disable this functionality
                      (defaults to on)
```

-s 是 flutter 目录

-o 是生成的资源文件地址,需要包含`.dart`

如果你在 flutter 目录下执行, 仅需 fgen 即可

可以加 --no-watch 参数来不监听文件变化,仅生成一次资源文件

## 关于文件名

文件中的空格,`/`,`-`,`.`会被转为`_`

转化的例子如下

```gen
    images/1.png => IMAGES_PNG
    images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG
    images/hello-world.jpg => IMAGES_HELLO_WORLD_JPG
```

会包含文件夹名称的原因是你 pubspec 中可能会包含多个文件夹目录, 或你的文件夹会包含多层级，甚至你的资产目录中会包含非图片（如数据库，json 等）资产

如下情况会出现错误

```bash
  images/
    main_login.png
    main/
      login.png
```

因为两个的字段命名方式是完全相同的

## 配置文件

配置文件为约定式，**不支持**通过命令指定，该文件为项目根目录下（与`pubspec.yaml`同级）下的`fgen.yaml`

### 排除和导入

使用`glob`语法

其中 `exclude`节点下为排除的文件名，类型是字符串数组，如未包含任何规则则表示不排除任何文件

`include`表示需要导入的文件名，字符串数组，如果未包含任何规则表示允许所有

优先级方面，exclude 高于 include，换句话说：

先根据 include 节点导入文件，然后 exclude 排除文件

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
├── address.png   # exclude by "**/add*.png"
├── address@at.png  # exclude by "**/add*.png"
├── bluetoothon-fjdfj.png
├── bluetoothon.png
└── camera.png

images
├── address space.png  # exclude by "**/add*.png"
├── address.png  # exclude by "**/add*.png"
├── addto.png  # exclude by "**/add*.png"
├── audio.png
├── bluetooth_link.png  # exclude by **_**
├── bluetoothoff.png
├── child.png
└── course.png
```

```dart
/// Generate by [resource_generator](https://github.com/CaiJingLong/flutter_resource_generator) library.
/// PLEASE DO NOT EDIT MANUALLY.
class R {

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

[pub global]: https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path
