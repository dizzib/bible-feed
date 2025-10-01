import 'package:flutter_test/flutter_test.dart';

import '../helper.dart';
import '../injectable.dart';

Future runMidnightAdvanceTest() async{
  testWidgets('auto advance at midnight', (t) async {
    await configureDependencies(environment: 'midnight_test');
    await t.startApp();
    expectChapters(1);
    await t.tapAllLists();
    expectText('All done!');
    await t.pumpAndSettle(const Duration(seconds: 2));
    expectChapters(2);
    expectNoText('All done!');
  });
}
