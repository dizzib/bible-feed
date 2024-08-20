import 'package:flutter/foundation.dart';

class AnsiColor {
  static const reset = '\x1B[0m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
}

extension LogObjExt on Object {
  void log() {
    if(kDebugMode) {
      debugPrint('${AnsiColor.yellow}${DateTime.now().toString()} ${AnsiColor.cyan}${toString()}${AnsiColor.reset}');
    }
  }
}
