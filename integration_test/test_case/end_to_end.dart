import 'package:flutter_test/flutter_test.dart';

import '../helper.dart';
import '../injectable.dart';

Future runEndToEndTest() async {
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
    await t.tapIconButton('gos');
    await t.pumpAndSettle();
    await t.scrollToLastBook(); // subsequent t.pump breaks!?
    await t.scrollToLastChapter();
    await t.pumpAndSettle();
    await t.tap(find.text('Update'));
    await t.pumpAndSettle();
    expectBookAndChapter('John', 21);
    expectChapters(3, count: 9);
  });
}
