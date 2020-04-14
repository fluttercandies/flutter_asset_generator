class Logger {
  factory Logger() {
    _instance ??= Logger._();
    return _instance;
  }

  Logger._();

  static Logger _instance;

  bool isDebug = false;

  void debug(Object msg) {
    if (isDebug) {
      print(msg);
    }
  }
}
