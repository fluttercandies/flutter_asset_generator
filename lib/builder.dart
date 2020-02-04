import 'dart:async';
import 'dart:io';

import 'package:flutter_asset_generator/logger.dart';
import 'package:flutter_asset_generator/template.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart';

const int serverPort = 31313;
Logger logger = Logger();

class ResourceDartBuilder {
  ResourceDartBuilder(this.projectRootPath, this.outputPath);

  bool isWatch = false;

  void generateResourceDartFile() {
    print("Prepare generate resource dart file.");
    final pubYamlPath = "$projectRootPath${separator}pubspec.yaml";
    try {
      final assetPathList = _getAssetPath(pubYamlPath);
      logger.debug("the assetPath is $assetPathList");
      generateImageFiles(assetPathList);
      writeText("allImageList = $allImageList");
      logger.debug("the image is $allImageList");
      generateCode();
    } catch (e) {
      if (e is StackOverflowError) {
        writeText(e.stackTrace);
      } else {
        writeText(e);
      }
    }
    print("Generate dart resource file finish.");

    watchFileChange();
  }

  File get logFile => File(".dart_tool${separator}log.txt");

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
      ..writeAsStringSync("  : $text", mode: FileMode.append)
      ..writeAsStringSync("\n", mode: FileMode.append);
  }

  /// get the flutter asset path from yaml
  List<String> _getAssetPath(String yamlPath) {
    YamlMap map = loadYaml(File(yamlPath).readAsStringSync());
    // writeText(map.toString());
    final flutterMap = map["flutter"];
    if (flutterMap is YamlMap) {
      // writeText("flutterMap is yamlMap");
      final assetMap = flutterMap["assets"];
      if (assetMap is YamlList) {
        // writeText("assetMap is YamlList");
        return getListFromYamlList(assetMap);
      } else {
        // writeText("assetMap type is ${assetMap.runtimeType}");
      }
    }
    return [];
  }

  /// get the asset from yaml list
  List<String> getListFromYamlList(YamlList yamlList) {
    List<String> list = [];
    final r = yamlList.map((f) {
      // writeTempText("file = $f , type is ${f.runtimeType}");
      return f.toString();
    }).toList();
    list.addAll(r);
    return list;
  }

  /// convert the set to the list
  List<String> get allImageList {
    return imageSet.toList()..sort();
  }

  /// the set is all file path，not exists directory
  final imageSet = Set<String>();

  /// all of the directory with yaml.
  List<Directory> dirList = [];

  /// scan the with path list
  void generateImageFiles(List<String> paths) {
    imageSet.clear();
    dirList.clear();

    paths.forEach((path) {
      // File file =  File(path);
      // Directory
      generateImageFileWithPath(path, imageSet, dirList, true);
    });
  }

  /// if path is a directory ,add the directory to [dirList]
  /// else add it to [imageSet].
  void generateImageFileWithPath(String path, Set<String> imageSet,
      List<Directory> dirList, bool rootPath) {
    String fullPath = _getAbsolutePath(path);
    if (FileSystemEntity.isDirectorySync(fullPath)) {
      if (!rootPath) {
        return;
      }
      Directory directory = Directory(fullPath);
      dirList.add(directory);
      final entries = directory.listSync(recursive: false);
      entries.forEach((entity) {
        generateImageFileWithPath(entity.path, imageSet, dirList, false);
      });
    } else if (FileSystemEntity.isFileSync(fullPath)) {
      final relativePath = path.replaceAll(projectRootPath + separator, "");
      if (!imageSet.contains(path)) {
        imageSet.add(relativePath);
      }
    }
  }

  String _getAbsolutePath(String path) {
    final f = File(path);
    if (f.isAbsolute) {
      return path;
    }
    return "${projectRootPath}/$path";
  }

  final isWriting = false;
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
    writeText("start write code");
    resourceFile.deleteSync(recursive: true);
    resourceFile.createSync(recursive: true);
    final lock = resourceFile.openWrite(mode: FileMode.append);
    final generate = (String text) {
      lock.write(text);
    };

    final template = Template();
    generate(template.license);
    generate(template.classDeclare);
    allImageList.forEach((path) {
      generate(template.formatFiled(path, projectRootPath));
    });
    generate(template.classDeclareFooter);
    lock.close();
    writeText("end write code");
  }

  /// watch all of path
  void watchFileChange() async {
    if (!isWatch) {
      return;
    }
    isWatch = true;
    dirList.forEach((dir) {
      final sub = _watch(dir);
      watchMap[dir] = sub;
    });
    File pubspec = File("$projectRootPath${separator}pubspec.yaml");
    final sub = _watch(pubspec);
    watchMap[pubspec] = sub;

    print("watching files watch");
  }

  /// when the directory is change
  /// refresh the code
  StreamSubscription _watch(FileSystemEntity file) {
    if (FileSystemEntity.isWatchSupported) {
      return file.watch().listen((data) {
        print("${data.path} is changed.");
        generateResourceDartFile();
      });
    }
    return null;
  }

  Map<FileSystemEntity, StreamSubscription> watchMap = {};

  removeAllWatches() {
    watchMap.values.forEach((v) {
      v?.cancel();
    });
  }
}
