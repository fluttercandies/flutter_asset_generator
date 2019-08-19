import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_asset_generator/builder.dart';
import 'package:flutter_asset_generator/logger.dart';
import 'package:path/path.dart' as path_library;

String get separator => path_library.separator;
void main(List<String> args) {
  var parser = new ArgParser();
  parser.addFlag(
    "watch",
    abbr: 'w',
    defaultsTo: true,
    help: "Continue to monitor changes after execution of orders.",
  );
  parser.addOption(
    "output",
    abbr: 'o',
    defaultsTo: "lib${separator}const${separator}resource.dart",
    help:
        "Your resource file path. \nIf it's a relative path, the relative flutter root directory",
  );
  parser.addOption(
    "src",
    abbr: 's',
    defaultsTo: ".",
    help: "Flutter project root path",
  );
  parser.addFlag("help", abbr: 'h', help: "Help usage", defaultsTo: false);

  parser.addFlag("debug", abbr: 'd', help: "debug info", defaultsTo: false);

  var results = parser.parse(args);

  Logger().isDebug = results["debug"];

  if (results.wasParsed("help")) {
    print(parser.usage);
    return;
  }

  String path = results["src"];
  String outputPath = results["output"];
  var workPath = File(path).absolute;
  print("Generate files for Project : " + workPath.absolute.path);

  check(workPath, outputPath, results["watch"]);
}

void check(File workPath, String outputPath, bool isWatch) {
  var builder = ResourceDartBuilder(workPath.absolute.path, outputPath);
  builder.generateResourceDartFile();
  builder.isWatch = isWatch;
  builder.watchFileChange();
}
