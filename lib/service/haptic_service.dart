import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HapticService {
  void impact() {
    HapticFeedback.lightImpact();
  }
}
