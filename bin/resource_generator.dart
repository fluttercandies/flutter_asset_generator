import 'dart:io';
import 'package:flutter_asset_generator/builder.dart';

void main(List<String> args) {
  String path;
  if (args.isNotEmpty) {
    path = args[0];
  } else {
    path = ".";
  }
  var workPath = File(path).absolute;
  print("Generate files for Project : " + workPath.absolute.path);

  check(workPath);
}

void check(File workPath) {
  var builder = ResourceDartBuilder(workPath.absolute.path);
  builder.isWatch = true;
  builder.generateResourceDartFile();
  builder.watchFileChange();
}
