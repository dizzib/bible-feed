import 'test_case/catchup.dart';
import 'test_case/midnight_auto_advance.dart';
import 'test_case/smoke.dart';
import 'test_case/widgets.dart';

void main() async {
  await runWidgetTests();
  await runSmokeTest();
  await runCatchupTest();
  await runMidnightAdvanceTest();
}
