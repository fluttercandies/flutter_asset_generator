# flutter_asset_generator

English | [中文文档](README_CHN.md)

Automatically generate the dart file for pubspec.yaml

The purpose of this library is to help flutter developers
automatically generate asset corresponding dart files
to help developers release their hands from this meaningless job,
and the open source community has a lot of the same functionality.

This library is based on dartlang's build library.

- [flutter\_asset\_generator](#flutter_asset_generator)
  - [screenshot](#screenshot)
  - [Usage](#usage)
    - [Run from source](#run-from-source)
    - [Run from pub global](#run-from-pub-global)
    - [Support options](#support-options)
  - [File name](#file-name)
  - [Config file](#config-file)
    - [Config schema for vscode](#config-schema-for-vscode)
    - [exclude and include rules](#exclude-and-include-rules)
    - [Replacement Rules](#replacement-rules)
      - [Example](#example)
    - [Other config](#other-config)

## screenshot

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## Usage

### Run from source

Add `dart` to your `$PATH` environment.

```bash
git clone https://github.com/fluttercandies/flutter_asset_generator
cd flutter_asset_generator
dart pub get
dart bin/asset_generator.dart $flutter_project
```

### Run from pub global

1. Install using [pub global][]:

```bash
dart pub global activate flutter_asset_generator

# or 

dart pub global activate -s git https://github.com/fluttercandies/flutter_asset_generator.git                 
```

1. Run below commands:
`fgen`
or
`fgen -s $flutter_project`

### Support options

Use `$ fgen -h` or `$ fgen --help` see usage document.

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

## File name

`Space`, '.' and '-' in the path will be converted to `_`. `@` will be converted to `_AT_`.

convert filed name example:

```log
images/1.png => IMAGES_PNG
images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG
images/hello-world.jpg => IMAGES_HELLO_WORLD_JPG
```

Errors will occur in the following situations:

```bash
images/
├── main_login.png
├── main/
    ├── login.png
```

Because the two field names will be exactly the same.

## Config file

The location of the configuration file is conventional.
Configuration via commands is **not supported**.
The specified path is `fgen.yaml` in the flutter project root directory.

### Config schema for vscode

Install [YAML Support](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) plugin.

Config your vscode `settings.json` file.

It can be used to prompt the configuration file.

```json
{
  "yaml.schemas": {
    "https://raw.githubusercontent.com/fluttercandies/flutter_asset_generator/master/fgen_schema.json": ["fgen.yaml"]
  }
}
```

### exclude and include rules

The file is yaml format, every element is `glob` style.

The name of the excluded file is under the `exclude` node, and the type is a string array. If no rule is included, it means no file is excluded.

The `include` node is the name of the file that needs to be imported, and the type is a string array. If it does not contain any rules, all file are allowed.

In terms of priority, exclude is higher than include, in other words:

First import the file according to the include nodes, and then exclude the files.

### Replacement Rules

File names can be replaced according to the configuration file as shown below:

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

### Other config

Since version 1.1.0:

Next command config option also support in config file.

But the command line option has a higher priority than the config file.

```yaml

watch: false
# watch: true

preview: false

output: lib/const/r.dart
# output: lib/const/resource.dart

name: RRR
```

[pub global]: https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path
