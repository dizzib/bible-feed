import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:injectable/injectable.dart';

@golden
@integrationTest
@LazySingleton(as: MidnightManager)
class StubMidnightManager extends MidnightManager {
  void notify() {
    notifyListeners();
  }
}
