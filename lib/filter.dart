import 'dart:io';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

class Filter {
  Filter(String text) : map = loadYaml(text) as YamlMap?;

  final YamlMap? map;

  Iterable<String> filter(Iterable<String> pathList) {
    final List<Glob> includeList = _loadList('include', true);
    final List<Glob> excludeList = _loadList('exclude');

    Iterable<String> tmp = pathList.where((String element) {
      for (final Glob glob in includeList) {
        if (glob.matches(element)) {
          return true;
        }
      }
      return false;
    });

    tmp = tmp.where((String element) {
      for (final Glob glob in excludeList) {
        if (glob.matches(element)) {
          return false;
        }
      }
      return true;
    });

    return tmp.toList();
  }

  List<Glob> _loadList(String key, [bool emptyEqualsAll = false]) {
    try {
      YamlList? list;

      if (map != null) {
        list = map![key] as YamlList;
      }

      if (emptyEqualsAll && (list == null || list.isEmpty)) {
        return <Glob>[Glob('*.*')];
      }
      if (list == null) {
        return <Glob>[];
      }
      return list.whereType<String>().map<Glob>((String e) => Glob(e)).toList();
    } catch (e, st) {
      print(e);
      print(st);
      print('The $key of fgen.yaml must be a string array');
      exit(2);
    }
  }
}
