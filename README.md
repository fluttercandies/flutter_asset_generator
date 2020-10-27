# flutter_asset_generator

Automatically generate the dart file for pubspec.yaml

The purpose of this library is to help flutter developers automatically generate asset corresponding dart files to help developers release their hands from this meaningless job, and the open source community has a lot of the same functionality.

This library is based on dartlang's build library.

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

- [flutter_asset_generator](#flutter_asset_generator)
  - [screenshot](#screenshot)
  - [Usage](#usage)
    - [use source](#use-source)
    - [pub global](#pub-global)
    - [Support options](#support-options)
  - [File name](#file-name)
  - [Config file](#config-file)
    - [exclude and include rules](#exclude-and-include-rules)
      - [Example](#example)

## screenshot

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## Usage

### use source

add `dart`,`pub` to `$PATH` environment.

```bash
git clone https://github.com/CaiJingLong/flutter_resource_generator.git
cd flutter_resource_generator
pub get
dart bin/resource_generator.dart $flutter_project
```

### pub global

install:

```bash
pub global activate flutter_asset_generator
```

use:

`fgen`
or
`fgen -s $flutter_project`

### Support options

Use `$ fgen -h` or `$ fgen --help` see usage document.

```bash
fgen -h
-w, --[no-]watch    Continue to monitor changes after execution of orders.
                    (defaults to on)

-o, --output        Your resource file path.
                    If it's a relative path, the relative flutter root directory
                    (defaults to "lib/const/resource.dart")

-s, --src           Flutter project root path
                    (defaults to ".")

-h, --[no-]help     Help usage

-p, --[no-]preview  Generate file with preview comments
```

## File name

`Space`, '.' and '-' in the path are converted to `_`.

convert filed name example:

```bash
    images/1.png => IMAGES_PNG
    images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG
    images/hello-world.jpg => IMAGES_HELLO_WORLD_JPG
```

Errors will occur in the following situations

```bash
  images/
    main_login.png
    main/
      login.png
```

Because the two field names will be exactly the same.

## Config file

The location of the configuration file is conventional.
Configuration via commands is **not supported**.
The specified path is `fgen.yaml` in the flutter project root directory.

### exclude and include rules

The file is yaml format, every element is `glob` style.

The name of the excluded file is under the `exclude` node, and the type is a string array. If no rule is included, it means no file is excluded.

The `include` node is the name of the file that needs to be imported, and the type is a string array. If it does not contain any rules, all file are allowed.

In terms of priority, exclude is higher than include, in other words:

First import the file according to the include nodes, and then exclude the files.

#### Example

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
