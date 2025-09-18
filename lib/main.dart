import 'package:flutter/material.dart';

import '/view/app_base.dart';
import 'injectable.dart';
import 'object_extension.dart';

Future<void> main() async {
  'starting app'.log();

  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(AppBase());

  final view = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
  'devicePixelRatio is ${view.devicePixelRatio}'.log();
  'Logical screen is ${view.size}'.log();
  'Physical screen is ${view.size * view.devicePixelRatio}'.log();

  'started app'.log();
}
