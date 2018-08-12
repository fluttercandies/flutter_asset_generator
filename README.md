# flutter_asset_generator

Automatically generate the dart file for pubspec.yaml

The purpose of this library is to help flutter developers automatically generate asset corresponding dart files to help developers release their hands from this meaningless job, and the open source community has a lot of the same functionality.

This library is based on dartlang's build library.

[中文文档](https://github.com/CaiJingLong/flutter_resource_generator/blob/master/README_CHN.md)

[English](https://github.com/CaiJingLong/flutter_resource_generator)

## screenshot

![img](https://github.com/CaiJingLong/some_asset/blob/master/flutter_resource_generator.gif)

## install

pubspec.yaml

```yaml
dev_dependencies:
  build_runner: ^0.9.0
  flutter_asset_generator: ^0.1.2
```

## use

cli run: `flutter packages pub run build_runner build`

cli watch and auto generate: `flutter packages pub run build_runner watch`

~~The command will block, the resource.dart will change when your images change or pubspec.yaml is edited.~~

~~you can use ctrl+c/cmd+c to exit the program.~~


0.2.0 changelog

Like other build libraries, build/watch commands can now be used normally.

But，user must add a `build.yaml` into your project root path. Bacause `build` library default only watch `https://www.dartlang.org/tools/pub/package-layout`'s list. The list have not 'images' path.

`build.yaml` content is :

```yaml
targets:
  $default:
    sources:
      - images/**
      - pubspec.*
```

the images/** is your image path

and your also download the file from github.   

[build.yaml](https://github.com/CaiJingLong/flutter_resource_generator/releases/download/v0.2.0/build.yaml)

## other

The library will put your every file in the asset path into resource.dart,not just picture files.

However, changes can only be triggered when the files of the following extension are changed.

```
".png"
".jpg"
".jpeg"
".gif"
".webp"
".bmp"
".wbmp"
".yaml"
".lock"
```

convert filed example:

    images/1.png => IMAGES_PNG
    images/hello_world.jpg => IMAGES_HELLO_WORLD_JPG


## TODO

add custom todolist
