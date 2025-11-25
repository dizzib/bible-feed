import 'package:flutter_test/flutter_test.dart';

import '../helper.dart';
import '../injectable.dart';

Future runSmokeTest() async {
  testWidgets('smoke', (t) async {
    await configureDependencies(environment: 'integration_test');
    await t.startApp();
    await t.tapAllLists();
    expectText('All done!'); // onboarding should happen
    await t.tapNo();
    await t.tapByKey('mat');
    expectNotInteractiveByKey('all_done_fab');
    await t.tapByKey('mat');
    expectNoText('All done!'); // onboarding should not happen
    expectChapters(1);
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(2);
    await t.tapAllLists();
    expectNoText('All done!'); // onboarding should not happen
    await t.tapAllDoneFab();
    await t.tapYes();
    expectChapters(3);
    await t.tapByKey('gos');
    await t.scrollToLastBook(); // subsequent t.pump breaks!?
    await t.scrollToLastChapter();
    await t.pumpAndSettle();
    await t.tapText('Update');
    await t.pumpAndSettle();
    expectBookAndChapter('John', 21);
    expectChapters(3, count: 9);
  });
}
