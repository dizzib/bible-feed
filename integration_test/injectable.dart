import 'package:injectable/injectable.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(
  generateForDir: ['integration_test', 'lib/model*', 'lib/manager*', 'lib/service*'],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies({required String environment}) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await di.reset();
  await di.init(environment: environment);
}
