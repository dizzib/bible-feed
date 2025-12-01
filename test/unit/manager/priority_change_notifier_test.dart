import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/manager/priority_change_notifier.dart';
import 'package:bible_feed/model/priority.dart';

class TestNotifier with ChangeNotifier, PriorityNotifier {}

void main() {
  test('PriorityNotifier calls listeners in priority order', () {
    final notifier = TestNotifier();
    final callOrder = <String>[];

    notifier.addListener(() => callOrder.add('normal1'));
    notifier.addListener(() => callOrder.add('high1'), priority: Priority.high);
    notifier.addListener(() => callOrder.add('low1'), priority: Priority.low);
    notifier.addListener(() => callOrder.add('normal2'));
    notifier.addListener(() => callOrder.add('high2'), priority: Priority.high);

    notifier.notifyListeners();

    expect(callOrder, ['high1', 'high2', 'normal1', 'normal2', 'low1']);
  });

  test('PriorityNotifier calls listeners the correct number of times', () {
    final notifier = TestNotifier();
    int callCount = 0;

    void listener() {
      callCount++;
    }

    notifier.addListener(listener, priority: Priority.high);
    notifier.addListener(listener, priority: Priority.low);

    notifier.notifyListeners();
    notifier.notifyListeners();

    expect(callCount, 4);
  });
}
