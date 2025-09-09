import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

class _AnsiColor {
  static const cyan = '\x1B[36m';
  static const reset = '\x1B[0m';
  static const yellow = '\x1B[33m';
  // static const blue = '\x1B[34m';
  // static const green = '\x1B[32m';
  // static const red = '\x1B[31m';
}

extension ObjectLog on Object {
  dynamic log() {
    if (kDebugMode) {
      debugPrint('${_AnsiColor.yellow}${clock.now().toString()} ${_AnsiColor.cyan}${toString()}${_AnsiColor.reset}');
    }
    return this;
  }
}
