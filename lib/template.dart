import 'package:flutter_asset_generator/config.dart';
import 'package:path/path.dart' as path_library;

import 'replace.dart';

class Template {
  Template(
    this.className,
    this.config,
  );

  final String className;
  final Config config;

  late final Replacer replacer = Replacer(config: config);

  String license = '''
/// Generate by [asset_generator](https://github.com/fluttercandies/flutter_asset_generator) library.
/// PLEASE DO NOT EDIT MANUALLY.
// ignore_for_file: constant_identifier_names\n''';

  String get classDeclare => '''
class $className {\n
  const $className._();\n''';

  String get classDeclareFooter => '}\n';

  String formatFiled(String path, String projectPath, bool isPreview) {
    if (isPreview) {
      return '''

  /// ![preview](file://$projectPath${path_library.separator}${_formatPreviewName(path)})
  static const String ${_formatFiledName(path)} = '$path';\n''';
    }
    return '''

  static const String ${_formatFiledName(path)} = '$path';\n''';
  }

  String _formatPreviewName(String path) {
    path = path.replaceAll(' ', '%20').replaceAll('/', path_library.separator);
    return path;
  }

  String _formatFiledName(String path) {
    // path = path
    //     .replaceAll('/', '_')
    //     .replaceAll('.', '_')
    //     .replaceAll(' ', '_')
    //     .replaceAll('-', '_')
    //     .replaceAll('@', '_AT_');
    // return path.toUpperCase();

    return replacer.replaceName(path).toUpperCase();
  }

  String toUppercaseFirstLetter(String str) {
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
}
