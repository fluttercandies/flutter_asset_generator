import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'config.dart';
import 'filter.dart';
import 'format.dart';
import 'logger.dart';
import 'template.dart';

const String _generateLogPrefix = 'Generating resource records';

const List<String> platformExcludeFiles = <String>[
  // For MacOS
  '.DS_Store',
  // For Windows
  'thumbs.db',
  'desktop.ini',
];
const int serverPort = 31313;
Logger logger = Logger();

class ResourceDartBuilder {
  // ResourceDartBuilder(String projectRootPath, this.outputPath) {
  ResourceDartBuilder(this.config);

  final Config config;
  Filter? get filter => config.filter;
  bool get isWatch => config.isWatch;
  bool _watching = false;
  bool get isPreview => config.preview;

  void generateResourceDartFile() {
    final String className = config.className;
    print('$_generateLogPrefix for project: $projectRootPath');
    stopWatch();
    final String pubYamlPath = '$projectRootPath${separator}pubspec.yaml';
    try {
      final List<String> assetPathList = _getAssetPath(pubYamlPath);
      logger.debug('The asset path list is: $assetPathList');
      generateImageFiles(assetPathList);
      writeText('allImageList = $allImageList');
      logger.debug('the image is $allImageList');
      generateCode(className);
    } catch (e) {
      if (e is StackOverflowError && e.stackTrace != null) {
        writeText(e.stackTrace!);
      } else {
        writeText(e);
      }
    }
    print('$_generateLogPrefix finish.');
    startWatch(className);
  }

  File get logFile => File('.dart_tool${separator}fgen_log.txt');

  String get projectRootPath => config.src;
  String get outputPath => config.output;

  /// Write logs to the file
  /// Defaults to `.dart_tools/fgen_log.txt`
  void writeText(Object text, {File? file}) {
    file ??= logFile;
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file
      ..writeAsStringSync(DateTime.now().toString(), mode: FileMode.append)
      ..writeAsStringSync('  : $text', mode: FileMode.append)
      ..writeAsStringSync('\n', mode: FileMode.append);
  }

  /// Get asset paths from [yamlPath].
  List<String> _getAssetPath(String yamlPath) {
    final YamlMap map = loadYaml(File(yamlPath).readAsStringSync()) as YamlMap;
    final dynamic flutterMap = map['flutter'];
    if (flutterMap is YamlMap) {
      final dynamic assetMap = flutterMap['assets'];
      if (assetMap is YamlList) {
        return getListFromYamlList(assetMap);
      }
    }
    return <String>[];
  }

  /// Get the asset from yaml list
  List<String> getListFromYamlList(YamlList yamlList) {
    final List<String> list = <String>[];
    final List<String> r = yamlList.map((dynamic f) => f.toString()).toList();
    list.addAll(r);
    return list;
  }

  /// Convert the set to the list
  List<String> get allImageList => imageSet.toList()..sort();

  /// The set is all file path，not exists directory.
  final Set<String> imageSet = <String>{};

  /// All of the directory with yaml.
  final List<Directory> dirList = <Directory>[];

  /// Scan the with path list
  void generateImageFiles(List<String> paths) {
    imageSet.clear();
    dirList.clear();

    for (final String path in paths) {
      generateImageFileWithPath(path, imageSet, dirList, true);
    }

    // Do filter
    if (filter != null) {
      final Iterable<String> result = filter!.filter(imageSet);
      imageSet.clear();
      imageSet.addAll(result);
    }
  }

  /// If path is a directory, add the directory to [dirList].
  /// If not, add it to [imageSet].
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
      final List<FileSystemEntity> entries = directory.listSync(
        recursive: false,
      );
      for (final FileSystemEntity entity in entries) {
        generateImageFileWithPath(entity.path, imageSet, dirList, false);
      }
    } else if (FileSystemEntity.isFileSync(fullPath)) {
      if (platformExcludeFiles.contains(basename(fullPath))) {
        return;
      }
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

  File get resourceFile {
    File res;
    if (File(outputPath).isAbsolute) {
      res = File(outputPath);
    } else {
      res = File('$projectRootPath/$outputPath');
    }

    res.createSync(recursive: true);
    return res;
  }

  /// Generate the dart code
  void generateCode(String className) {
    stopWatch();
    writeText('Start writing records');
    resourceFile.deleteSync(recursive: true);
    resourceFile.createSync(recursive: true);

    final StringBuffer source = StringBuffer();
    final Template template = Template(className, config);
    source.write(template.license);
    source.write(template.classDeclare);
    for (final String path in allImageList) {
      source.write(template.formatFiled(path, projectRootPath, isPreview));
    }
    source.write(template.classDeclareFooter);

    final Stopwatch sw = Stopwatch();
    sw.start();
    final String formattedCode = formatFile(source.toString());
    sw.stop();
    print('Formatted records in ${sw.elapsedMilliseconds}ms');
    sw.reset();
    resourceFile.writeAsString(formattedCode);
    sw.stop();
    writeText('End writing records ${sw.elapsedMilliseconds}');
  }

  /// Watch all paths
  Future<void> startWatch(String className) async {
    if (!isWatch) {
      return;
    }
    if (_watching) {
      return;
    }
    _watching = true;
    for (final Directory dir in dirList) {
      final StreamSubscription<FileSystemEvent>? sub = _watch(dir);
      if (sub != null) {
        sub.onDone(sub.cancel);
      }
      watchMap[dir] = sub;
    }
    final File pubspec = File('$projectRootPath${separator}pubspec.yaml');
    // ignore: cancel_subscriptions
    final StreamSubscription<FileSystemEvent>? sub = _watch(pubspec);
    if (sub != null) {
      watchMap[pubspec] = sub;
    }

    final File configFile = File('$projectRootPath${separator}fgen.yaml');
    if (configFile.existsSync()) {
      // ignore: cancel_subscriptions
      final StreamSubscription<FileSystemEvent>? configFileSub =
          _watch(configFile);
      if (sub != null) {
        watchMap[configFile] = configFileSub;
      }
    }

    print('Watching all resources file.');
  }

  void stopWatch() {
    _watching = false;
    for (final StreamSubscription<FileSystemEvent>? v in watchMap.values) {
      v?.cancel();
    }
    watchMap.clear();
  }

  /// When the directory is change, refresh records.
  StreamSubscription<FileSystemEvent>? _watch(
    FileSystemEntity file,
  ) {
    if (FileSystemEntity.isWatchSupported) {
      return file.watch().listen((FileSystemEvent data) {
        print('${data.path} has changed.');
        config.refresh();
        generateResourceDartFile();
      });
    }
    return null;
  }

  final Map<FileSystemEntity, StreamSubscription<FileSystemEvent>?> watchMap =
      <FileSystemEntity, StreamSubscription<FileSystemEvent>?>{};

  void removeAllWatches() {
    for (final StreamSubscription<FileSystemEvent>? sub in watchMap.values) {
      sub?.cancel();
    }
  }
}
