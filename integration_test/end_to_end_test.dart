import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('end-to-end', (WidgetTester t) async {
    await t.initialiseApp();
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
