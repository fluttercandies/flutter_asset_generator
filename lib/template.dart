import 'package:path/path.dart' as path_library;

class Template {
  String licenese =
      """/// generate by resouce_generator library, shouldn't edit.\n""";

  String get classDeclare => "class R {\n";
  String get classDeclareFooter => "}\n";

  String formatFiled(String path, String projectPath) {
    return """
    
  /// ![preview](${projectPath}${path_library.separator}$path)      
  static const String ${_formatFiledName(path)} = "$path";\n""";
  }

  String _formatFiledName(String path) {
    path = path.replaceAll("/", "_");
    path = path.replaceAll(".", "_");
    return path.toUpperCase();
  }

  String toUppercaseFirstLetter(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  // String _formatDotPartName(String partName) {
  //   partName = partName.splitMapJoin(
  //     ".",
  //     onMatch: (m) {
  //       return "Dot";
  //     },
  //     onNonMatch: (m) {
  //       return toUppercaseFirstLetter(m);
  //     },
  //   );
  //   return partName;
  // }
}
