import 'dart:async';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

import 'format.dart';
import 'logger.dart';
import 'template.dart';

const int serverPort = 31313;
Logger logger = Logger();

class ResourceDartBuilder {
  ResourceDartBuilder(String projectRootPath, this.outputPath) {
    this.projectRootPath = projectRootPath.replaceAll('$separator.', '');
  }

  bool isWatch = false;

  bool _watching = false;

  bool isPreview = true;

  void generateResourceDartFile() {
    print('Generating files for Project: $projectRootPath');
    stopWatch();
    final String pubYamlPath = '$projectRootPath${separator}pubspec.yaml';
    try {
      final List<String> assetPathList = _getAssetPath(pubYamlPath);
      logger.debug('the assetPath is $assetPathList');
      generateImageFiles(assetPathList);
      writeText('allImageList = $allImageList');
      logger.debug('the image is $allImageList');
      generateCode();
    } catch (e) {
      if (e is StackOverflowError) {
        writeText(e.stackTrace);
      } else {
        writeText(e);
      }
    }
    print('Generate dart resource file finish.');

    startWatch();
  }

  File get logFile => File('.dart_tool${separator}log.txt');

  String projectRootPath;
  String outputPath;

  /// write the
  /// default file is a log file in the .dart_tools/log.txt
  void writeText(Object text, {File file}) {
    file ??= logFile;
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file
      ..writeAsStringSync(DateTime.now().toString(), mode: FileMode.append)
      ..writeAsStringSync('  : $text', mode: FileMode.append)
      ..writeAsStringSync('\n', mode: FileMode.append);
  }

  /// get the flutter asset path from yaml
  List<String> _getAssetPath(String yamlPath) {
    final YamlMap map = loadYaml(File(yamlPath).readAsStringSync()) as YamlMap;
    // writeText(map.toString());
    final dynamic flutterMap = map['flutter'];
    if (flutterMap is YamlMap) {
      // writeText('flutterMap is yamlMap');
      final dynamic assetMap = flutterMap['assets'];
      if (assetMap is YamlList) {
        // writeText('assetMap is YamlList');
        return getListFromYamlList(assetMap);
      } else {
        // writeText('assetMap type is ${assetMap.runtimeType}');
      }
    }
    return <String>[];
  }

  /// get the asset from yaml list
  List<String> getListFromYamlList(YamlList yamlList) {
    final List<String> list = <String>[];
    final List<String> r = yamlList.map((dynamic f) {
      // writeTempText('file = $f , type is ${f.runtimeType}');
      return f.toString();
    }).toList();
    list.addAll(r);
    return list;
  }

  /// convert the set to the list
  List<String> get allImageList => imageSet.toList()..sort();

  /// the set is all file path，not exists directory
  // ignore: prefer_collection_literals
  final Set<String> imageSet = Set<String>();

  /// all of the directory with yaml.
  final List<Directory> dirList = <Directory>[];

  /// scan the with path list
  void generateImageFiles(List<String> paths) {
    imageSet.clear();
    dirList.clear();

    for (final String path in paths) {
      // File file =  File(path);
      // Directory
      generateImageFileWithPath(path, imageSet, dirList, true);
    }
  }

  /// if path is a directory ,add the directory to [dirList]
  /// else add it to [imageSet].
  void generateImageFileWithPath(
    String path,
    Set<String> imageSet,
    List<Directory> dirList,
    bool rootPath,
  ) {
    final String fullPath = _getAbsolutePath(path);
    if (FileSystemEntity.isDirectorySync(fullPath)) {
      if (!rootPath) {
        return;
      }
      final Directory directory = Directory(fullPath);
      dirList.add(directory);
      final List<FileSystemEntity> entries =
          directory.listSync(recursive: false);
      for (final FileSystemEntity entity in entries) {
        generateImageFileWithPath(entity.path, imageSet, dirList, false);
      }
    } else if (FileSystemEntity.isFileSync(fullPath)) {
      final String relativePath = path
          .replaceAll('$projectRootPath$separator', '')
          .replaceAll('$projectRootPath/', '');
      if (!imageSet.contains(path)) {
        imageSet.add(relativePath);
      }
    }
  }

  String _getAbsolutePath(String path) {
    final File f = File(path);
    if (f.isAbsolute) {
      return path;
    }
    return '$projectRootPath/$path';
  }

  final bool isWriting = false;
  File _resourceFile;

  File get resourceFile {
    if (File(outputPath).isAbsolute) {
      _resourceFile ??= File(outputPath);
    } else {
      _resourceFile ??= File('$projectRootPath/$outputPath');
    }

    _resourceFile.createSync(recursive: true);
    return _resourceFile;
  }

  /// generate the dart code
  void generateCode() {
    stopWatch();
    writeText('start write code');
    resourceFile.deleteSync(recursive: true);
    resourceFile.createSync(recursive: true);
    final IOSink lock = resourceFile.openWrite(mode: FileMode.append);
    final Function(String) generate = (String text) {
      lock.write(text);
    };

    final Template template = Template();
    generate(template.license);
    generate(template.classDeclare);
    for (final String path in allImageList) {
      generate(template.formatFiled(path, projectRootPath, isPreview));
    }
    generate(template.classDeclareFooter);
    lock.close();
    formatFile(resourceFile);
    writeText('end write code');
  }

  /// watch all of path
  Future<void> startWatch() async {
    if (!isWatch) {
      return;
    }
    if (_watching) {
      return;
    }
    _watching = true;
    for (final Directory dir in dirList) {
      final StreamSubscription<FileSystemEvent> sub = _watch(dir);
      if (sub != null) {
        sub.onDone(sub.cancel);
      }
      watchMap[dir] = sub;
    }
    final File pubspec = File('$projectRootPath${separator}pubspec.yaml');
    final StreamSubscription<FileSystemEvent> sub = _watch(pubspec);
    if (sub != null) {
      watchMap[pubspec] = sub;
    }

    print('watching files watch');
  }

  void stopWatch() {
    _watching = false;
    for (final StreamSubscription<FileSystemEvent> v in watchMap.values) {
      v.cancel();
    }

    watchMap.clear();
  }

  /// when the directory is change
  /// refresh the code
  StreamSubscription<FileSystemEvent> _watch(FileSystemEntity file) {
    if (FileSystemEntity.isWatchSupported) {
      return file.watch().listen((FileSystemEvent data) {
        print('${data.path} is changed.');
        generateResourceDartFile();
      });
    }
    return null;
  }

  Map<FileSystemEntity, StreamSubscription<FileSystemEvent>> watchMap =
      <FileSystemEntity, StreamSubscription<FileSystemEvent>>{};

  void removeAllWatches() {
    for (final StreamSubscription<FileSystemEvent> sub in watchMap.values) {
      sub?.cancel();
    }
  }
}
