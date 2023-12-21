import 'package:args/args.dart';
import 'package:flutter_asset_generator/builder.dart';
import 'package:flutter_asset_generator/config.dart';
import 'package:flutter_asset_generator/logger.dart';

void main(List<String> args) {
  final ArgParser parser = ArgParser();
  parser.addFlag(
    'watch',
    abbr: 'w',
    defaultsTo: null,
    help: 'Continue to monitor changes after execution of orders.',
  );
  final String defaultPath = Config.defaultPath;
  parser.addOption(
    'output',
    abbr: 'o',
    help: 'Your resource file path. \n'
        "If it's a relative path, the relative flutter root directory.\n"
        "If you don't specify it, the default path is $defaultPath.\n",
  );
  parser.addOption(
    'src',
    abbr: 's',
    defaultsTo: '.',
    help: 'Flutter project root path',
  );
  parser.addOption(
    'name',
    abbr: 'n',
    help: 'The class name for the constant.\n'
        'If you don\'t specify it, the default name is R.',
  );
  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Help usage',
    defaultsTo: false,
    negatable: false,
  );

  parser.addFlag(
    'debug',
    abbr: 'd',
    help: 'debug info',
    defaultsTo: false,
    negatable: false,
  );

  parser.addFlag(
    'preview',
    abbr: 'p',
    help: 'Enable preview comments, defaults to true, '
        'use --no-preview to disable this functionality',
    defaultsTo: null,
  );

  final ArgResults results = parser.parse(args);

  Logger().isDebug = results['debug'] as bool;

  if (results.wasParsed('help')) {
    print(parser.usage);
    return;
  }

  final Config config = Config.fromArgResults(results);

  logger.debug('The config is: $config');

  final ResourceDartBuilder builder = ResourceDartBuilder(
    config,
  );
  builder.generateResourceDartFile();
}
