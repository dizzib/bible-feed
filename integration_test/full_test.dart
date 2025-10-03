import 'test_case/end_to_end.dart';
import 'test_case/midnight_auto_advance.dart';
import 'test_case/widgets.dart';

void main() async {
  await runWidgetTests();
  await runEndToEndTest();
  await runMidnightAdvanceTest();
}
