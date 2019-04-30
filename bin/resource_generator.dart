import 'dart:io';

import 'package:flutter_asset_generator/builder.dart';

void main(List<String> args) {
  String path;
  String outputPath;
  if (args.isNotEmpty) {
    path = args[0];
    try {
      outputPath = args[1];
    } catch (e) {
      outputPath = 'lib/const/resource.dart';
    }
  } else {
    path = ".";
  }
  var workPath = File(path).absolute;
  print("Generate files for Project : " + workPath.absolute.path);

  check(workPath, outputPath);
}

void check(File workPath, String outputPath) {
  var builder = ResourceDartBuilder(workPath.absolute.path, outputPath);
  builder.isWatch = true;
  builder.generateResourceDartFile();
  builder.watchFileChange();
}
