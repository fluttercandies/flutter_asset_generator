class Logger {
  static Logger _instance;

  factory Logger() {
    _instance ??= Logger._();
    return _instance;
  }

  Logger._();

  var isDebug = false;

  void debug(Object msg) {
    if (isDebug) {
      print(msg);
    }
  }
}
