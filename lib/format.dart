import 'dart:io';

import 'package:io/ansi.dart';
import 'package:path/path.dart';

Future<void> formatFile(File file) async {
  if (file == null) {
    return;
  }

  if (!file.existsSync()) {
    print(red.wrap('format error: ${file?.absolute?.path} does not exist\n'));
    return;
  }

  final String path = file?.absolute?.path?.replaceAll('/', separator);

  processRunSync(
    executable: 'flutter',
    arguments: 'format $path',
    runInShell: true,
  );
}

void processRunSync({
  String executable,
  String arguments,
  bool runInShell = false,
}) {
  final ProcessResult result = Process.runSync(
    executable,
    arguments.split(' '),
    runInShell: runInShell,
  );
  if (result.exitCode != 0) {
    throw Exception(result.stderr);
  }
  print('${result.stdout}');
}
