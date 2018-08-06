import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:flutter_asset_generator/template.dart';
import 'package:yaml/yaml.dart';

Builder resourceFileBuilder(BuilderOptions options) =>
    new ResourceDartBuilder();

var count = 0;
bool isWatch = false;

class ResourceDartBuilder extends Builder {
  BuildStep buildStep;

  @override
  Future build(BuildStep buildStep) async {
    this.buildStep = buildStep;
    if (!inputId.path.endsWith("main.dart")) {
      return;
    }
    logFile.writeAsStringSync(""); //clear file content
    generateResourceDartFile();

    watchFileChange();
    ProcessSignal.sigint.watch().listen((sign) {
      /// because the program is block, so your must use ctrl+c/cmd+c the exit the build program.
      writeText("program on exit event and will delete cache");

      /// because build program is dependent on build cache
      /// so exit will clear dart_tool cache
      Directory directory =
          new Directory(projectRootPath + "/.dart_tool/build");
      directory.delete(recursive: true);

      /// on exit will kill the dart program with current pid
      writeText("kill current pid = $pid");
      Process.killPid(pid);
    });
  }

  void generateResourceDartFile() {
    var pubYamlPath = "$projectRootPath/pubspec.yaml";
    try {
      var assetPathList = _getAssetPath(pubYamlPath);
      genarateImageFiles(assetPathList);
      writeText("allImageList = $allImageList");
      generateCode();
    } catch (e) {
      if (e is StackOverflowError) {
        writeText(e.stackTrace);
      } else {
        writeText(e);
      }
    }
  }

  File get logFile =>
      new File(new File(inputId.path).parent.parent.absolute.path +
          "/.dart_tool/log.txt");

  String get projectRootPath => logFile.parent.parent.path;

  AssetId get inputId => buildStep.inputId;

  /// write the
  /// default file is a log file in the .dart_tools/log.txt
  void writeText(Object text, {File file}) {
    file ??= logFile;
    logFile
      ..writeAsStringSync(new DateTime.now().toString(), mode: FileMode.append)
      ..writeAsStringSync("  : $text", mode: FileMode.append)
      ..writeAsStringSync("\n", mode: FileMode.append);
  }

  /// get the flutter asset path from yaml
  List<String> _getAssetPath(String yamlPath) {
    YamlMap map = loadYaml(new File(yamlPath).readAsStringSync());
    // writeText(map.toString());
    var flutterMap = map["flutter"];
    if (flutterMap is YamlMap) {
      // writeText("flutterMap is yamlMap");
      var assetMap = flutterMap["assets"];
      if (assetMap is YamlList) {
        // writeText("assetMap is YamlList");
        return getListFromYamlList(assetMap);
      } else {
        // writeText("assetMap type is ${assetMap.runtimeType}");
      }
    }
    return [];
  }

  /// get the yaml list
  List<String> getListFromYamlList(YamlList yamlList) {
    List<String> list = [];
    var r = yamlList.map((f) {
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
  Set<String> imageSet = new Set();

  /// all of the directory with yaml.
  List<Directory> dirList = [];

  /// scan the with path list
  void genarateImageFiles(List<String> paths) {
    imageSet.clear();
    dirList.clear();

    paths.forEach((path) {
      // File file = new File(path);
      // Directory
      genarateImageFileWithPath(path);
    });
  }

  /// if path is a directory ,add the directory to [dirList]
  /// else add it to [imageSet].
  void genarateImageFileWithPath(String path) {
    if (FileSystemEntity.isDirectorySync(path)) {
      Directory directory = new Directory(path);
      dirList.add(directory);
      var entitys = directory.listSync(recursive: false);
      entitys.forEach((entity) {
        genarateImageFileWithPath(entity.path);
      });
    } else if (FileSystemEntity.isFileSync(path)) {
      // writeTempText("path = $path");
      if (!imageSet.contains(path)) imageSet.add(path);
    }
  }

  var isWriting = false;
  File _resourceFile;
  File get resourceFile {
    _resourceFile ??= new File('$projectRootPath/lib/const/resource.dart');
    _resourceFile.createSync(recursive: true);
    return _resourceFile;
  }

  /// generate the dart code
  void generateCode() {
    writeText("start write code");
    resourceFile.deleteSync(recursive: true);
    resourceFile.createSync(recursive: true);
    var lock = resourceFile.openWrite(mode: FileMode.append);
    var genarate = (String text) {
      lock.write(text);
    };

    var template = new Template();
    genarate(template.licenese);
    genarate(template.classDeclare);
    allImageList.forEach((path) {
      genarate(template.format(path));
    });
    genarate(template.classDeclareFooter);
    lock.close();
    writeText("end write code");
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        ".dart": const [".dart.copy"],
      };

  /// watch all of path
  void watchFileChange() {
    if (isWatch) {
      return;
    }
    isWatch = true;
    dirList.forEach((dir) {
      _watch(dir);
    });
  }

  /// when the directory is change
  /// refresh the code
  void _watch(Directory dir) {
    dir.watch().listen((data) {
      generateResourceDartFile();
    });
  }
}
