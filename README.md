# flutter_asset_generator

Automatically generate the dart file for pubspec.yaml

The purpose of this library is to help flutter developers automatically generate asset corresponding dart files to help developers release their hands from this meaningless job, and the open source community has a lot of the same functionality.

This library is based on dartlang's build library.

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

## screenshot

![img](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/asset_gen_3.0.gif)

## install

add `pub`,`dart` to `$PATH` environment.

see https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path add `.pub-cache/bin` to `$PATH`.

Use next command to validate.

```bash
dart --version
pub --version
```

### pub global

use

```bash
pub global activate flutter_asset_generator
```

## Usage

### use dart

git clone https://github.com/CaiJingLong/flutter_resource_generator.git fgen

cd fgen

dart bin/resource_generator.dart ./example/

### Usage of pub global(recommand)

See [dart document](https://www.dartlang.org/tools/pub/cmd/pub-global)

run at flutter project path:

```bash
fgen .
```

The second parameter is optional, defaulting to the current directory

## File name

convert filed name example:

    images/1.png => IMAGES_PNG
    images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG

Errors will occur in the following situations

```bash
  images/
    main_login.png
    main/
      login.png
```

Because the two field names will be exactly the same.

## tips

If you run the 'flutter packages run build_runner watch' in cli ,then you change the pubspec.yaml, you must stop the watch, becasue flutter's locked.

flutter's asset no supoort hot reload/hot restart. so if you change your assets, you must stop your application, and run `flutter packages get` and `flutter packages pub run build_runner build` to generate your resource.
