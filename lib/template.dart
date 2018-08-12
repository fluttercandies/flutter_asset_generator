class Template {
  String licenese =
      """/// generate by resouce_generator library, shouldn't edit.\n""";

  String get classDeclare => "class R {\n";
  String get classDeclareFooter => "}\n";

  String format(String path) {
    return """\n  static const String ${_formatFiledName(path)} = "$path";\n\n""";
  }

  // String _oldFormatFiledName(String path) {
  //   List<String> names = [];
  //   var list = path.split("/");
  //   list.forEach((item) {
  //     var items = item.split("_");
  //     names.addAll(items);
  //   });
  //   var sb = new StringBuffer();
  //   for (var i = 0; i < names.length; i++) {
  //     var partName = names[i];
  //     if (i != 0) {
  //       partName = toUppercaseFirstLetter(partName);
  //       partName = _formatDotPartName(partName);
  //     }
  //     sb.write(partName);
  //   }
  //   return sb.toString();
  // }

  String _formatFiledName(String path) {
    path = path.replaceAll("/", "_");
    path = path.replaceAll(".", "_");
    return path.toUpperCase();
  }

  String toUppercaseFirstLetter(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  String _formatDotPartName(String partName) {
    partName = partName.splitMapJoin(
      ".",
      onMatch: (m) {
        return "Dot";
      },
      onNonMatch: (m) {
        return toUppercaseFirstLetter(m);
      },
    );
    return partName;
  }
}
