import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_asset_generator/builder.dart';
import 'package:path/path.dart' as path_library;

String get separator => path_library.separator;
void main(List<String> args) {
  var parser = new ArgParser();
  // parser.addFlag("watch", abbr: 'w', defaultsTo: true);
  parser.addOption(
    "output",
    abbr: 'o',
    defaultsTo: "lib${separator}const${separator}resource.dart",
    help: "your resource file path ()",
  );
  parser.addOption(
    "src",
    abbr: 's',
    defaultsTo: ".",
    help: "flutter project root path",
  );
  parser.addFlag("help", abbr: 'h', help: "help usage", defaultsTo: false);

  var results = parser.parse(args);

  if (results.wasParsed("help")) {
    print(parser.usage);
    return;
  }

  String path = results["src"];
  String outputPath = results["output"];
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
