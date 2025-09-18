import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';

import '/view/app_base.dart';
import 'injectable.dart';

Future<void> main() async {
  Log.start('starting app');

  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(AppBase());

  final view = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
  Log.info('devicePixelRatio is ${view.devicePixelRatio}');
  Log.info('Logical screen is ${view.size}');
  Log.info('Physical screen is ${view.size * view.devicePixelRatio}');
}
