import 'package:flutter_asset_generator/config.dart';
import 'package:yaml/yaml.dart';

class RegexItem {
  const RegexItem({
    required this.from,
    required this.to,
  });
  final String from;
  final String to;
}

class Replacer {
  Replacer({
    required this.config,
  }) {
    init();
  }

  final Config config;

  final List<RegexItem> items = <RegexItem>[];

  void init() {
    items.add(const RegexItem(from: '/', to: '_'));
    items.add(const RegexItem(from: '.', to: '_'));
    items.add(const RegexItem(from: ' ', to: '_'));
    items.add(const RegexItem(from: '-', to: '_'));
    items.add(const RegexItem(from: '@', to: '_AT_'));

    final YamlMap? options = config.configFileOptions;
    if (options != null) {
      final List<dynamic>? replace = options['replace'] as List<dynamic>?;
      if (replace != null) {
        for (final dynamic item in replace) {
          final Map<dynamic, dynamic> map = item as Map<dynamic, dynamic>;
          final String from = map['from'] as String? ?? '';
          final String to = map['to'] as String? ?? '';
          items.add(RegexItem(from: from, to: to));
        }
      }
    }
  }

  String replaceName(String path) {
    String result = path;
    for (final RegexItem item in items) {
      result = result.replaceAll(item.from, item.to);
    }
    return result;
  }
}
