class Logger {
  factory Logger() => _instance;

  Logger._();

  static late final Logger _instance = Logger._();

  bool isDebug = false;

  void debug(Object msg) {
    if (isDebug) {
      print(msg);
    }
  }
}
