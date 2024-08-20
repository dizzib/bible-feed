import 'package:flutter/foundation.dart';

extension LogExtension on Object {
  void log() {
    if(kDebugMode) debugPrint('${DateTime.now().toString()} ${toString()}');
  }
}
