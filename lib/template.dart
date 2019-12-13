import 'package:path/path.dart' as path_library;

class Template {
  String license =
      """/// Generate by resource_generator library, PLEASE DO NOT EDIT 
      MANUALLY.\n""";

  String get classDeclare => "class R {\n";
  String get classDeclareFooter => "}\n";

  String formatFiled(String path, String projectPath) {
    return """
    
  /// ![preview](file://${projectPath}${path_library.separator}${_formatPreviewName(path)})
  static const String ${_formatFiledName(path)} = "$path";\n""";
  }

  String _formatPreviewName(String path) {
    path = path.replaceAll(" ", "%20");
    return path;
  }

  String _formatFiledName(String path) {
    path = path.replaceAll("/", "_");
    path = path.replaceAll(".", "_");
    path = path.replaceAll(" ", "_");
    path = path.replaceAll("-", "_");
    return path.toUpperCase();
  }

  String toUppercaseFirstLetter(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }
}
