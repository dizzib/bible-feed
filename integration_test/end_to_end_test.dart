import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('end-to-end', (WidgetTester t) async {
    await initialiseApp(t);
    expectChapters(1);
    await markAllListsAsRead(t);
    await advanceManually(t);
    expectChapters(2);
    await selectLastBookAndChapter(t, 'Gospels', 'John', 21);
    expectChapters(2, count:9);
    await markAllListsAsRead(t);
    expect(find.text('All done!'), findsNothing);  // 2nd time
    // await advanceManually(t);
  });
}
