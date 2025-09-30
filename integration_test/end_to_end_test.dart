import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';
import 'injectable.dart';

void main() {
  testWidgets('end-to-end', (t) async {
    await configureDependencies(environment: 'prod');
    await t.startApp();
    expectChapters(1);
    await t.tapAllLists();
    await t.tapNo();
    expectChapters(1);
    await t.tapFab();
    await t.tapYes();
    expectChapters(2);
    await t.tapAllLists();
    expectNoText('All done!'); // 2nd time
    await t.tapFab();
    await t.tapYes();
    expectChapters(3);
    await t.selectLastBookAndChapter('Gospels');
    expectBookAndChapter('John', 21);
    expectChapters(3, count: 9);
  });
}
