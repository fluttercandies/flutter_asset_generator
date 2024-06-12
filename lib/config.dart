import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'filter.dart';

class Config {
  Config({
    required this.results,
  });

  factory Config.fromArgResults(ArgResults results) {
    final Config config = Config(results: results);
    config.refresh();
    return config;
  }

  static final String defaultPath = join('lib', 'const', 'resource.dart');

  final ArgResults results;
  late String src;
  late String output;
  late bool isWatch;
  late bool preview;
  late String className;
  late YamlMap? configFileOptions;

  Filter? filter;

  void refresh() {
    String src = results['src'] as String;

    src = absolute(src);
    src = normalize(src);

    final File configFile = File(join(src, 'fgen.yaml'));

    String? output = results['output'];
    String? className = results['name'];
    bool? watch = results['watch'];
    bool? preview = results['preview'];

    YamlMap? yamlMap;
    if (configFile.existsSync()) {
      final String configFileText = configFile.readAsStringSync();
      filter = Filter(configFileText);
      yamlMap = loadYaml(configFileText) as YamlMap?;

      if (yamlMap != null) {
        output ??= yamlMap['output'] as String?;
        className ??= yamlMap['name'] as String?;
        watch ??= yamlMap['watch'] as bool?;
        preview ??= yamlMap['preview'] as bool?;
      }
    }

    output ??= defaultPath;
    className ??= 'R';
    watch ??= true;
    preview ??= true;

    this.src = src;
    this.output = output;
    this.className = className;
    isWatch = watch;
    this.preview = preview;
    configFileOptions = yamlMap;
  }

  @override
  String toString() {
    return 'Config{className: $className, src: $src, output: $output, isWatch: $isWatch, preview: $preview}';
  }
}
