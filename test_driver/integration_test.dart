import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String path, List<int> bytes, [Map<String, Object?>? args]) async {
      final File image = await File('screenshots/$path.png').create(recursive: true);
      image.writeAsBytesSync(bytes);
      return true;
    },
  );
}
