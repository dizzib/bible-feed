import 'package:bible_feed/manager/app_lifecycle_manager.dart';
import 'package:bible_feed/model/priority.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppLifecycleManager calls resume callbacks in priority order', () {
    WidgetsFlutterBinding.ensureInitialized();

    final manager = AppLifecycleManager();
    final callOrder = <String>[];

    manager.onResume(() => callOrder.add('normal1'));
    manager.onResume(() => callOrder.add('high1'), priority: Priority.high);
    manager.onResume(() => callOrder.add('low1'), priority: Priority.low);
    manager.onResume(() => callOrder.add('normal2'));
    manager.onResume(() => callOrder.add('high2'), priority: Priority.high);

    manager.runCallbacks();

    expect(callOrder, ['high1', 'high2', 'normal1', 'normal2', 'low1']);
  });
}
