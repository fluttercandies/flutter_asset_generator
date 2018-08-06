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
  flutter_asset_generator: ^0.1.0
```

## use

cli run: `flutter packages pub run build_runner build`

The command will block, the resource.dart will change when your images change.

you can use ctrl+c/cmd+c to exit the program.

## other

the library will put your every file in the asset path into resource.dart,not just picture files.

the R class filed name is Camel-Case,and convert the like '.png' to the 'DotPng'. And the '\_' will ignore.

convert filed example:

    images/1.png => images1DotPng
    images/hello_world.jpg => imagesHelloWorldDotPng
    images/hello_wordl_dot_jpg => imagesHelloWorldDotPng

so the image file name is Camel-Case or split with '\_' is support. if your file have dot looks strange.

## TODO

add custom todolist
