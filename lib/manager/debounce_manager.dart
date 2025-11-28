import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DebounceManager {
  Duration delay = 10.milliseconds;

  Timer? _timer;
  bool _canRun = true;

  void run(void Function() action) {
    if (!_canRun) return;
    _canRun = false;

    action();

    _timer?.cancel();
    _timer = Timer(delay, () => _canRun = true);
  }

  void dispose() {
    _timer?.cancel();
  }
}
