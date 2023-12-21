import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class Config {
  const Config({
    required this.className,
    required this.src,
    required this.output,
    required this.isWatch,
    required this.preview,
  });

  factory Config.fromArgResults(ArgResults results) {
    String src = results['src'] as String;

    src = absolute(src);
    src = normalize(src);

    final File configFile = File(join(src, 'fgen.yaml'));

    String? output = results['output'];
    String? className = results['name'];
    bool? watch = results['watch'];
    bool? preview = results['preview'];

    if (configFile.existsSync()) {
      final YamlMap? yamlMap =
          loadYaml(configFile.readAsStringSync()) as YamlMap?;

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

    return Config(
      className: className,
      src: src,
      output: output,
      isWatch: watch,
      preview: preview,
    );
  }

  static final String defaultPath = join('lib', 'const', 'resource.dart');

  final String src;
  final String output;
  final bool isWatch;
  final bool preview;
  final String className;

  @override
  String toString() {
    return 'Config{className: $className, src: $src, output: $output, isWatch: $isWatch, preview: $preview}';
  }
}
