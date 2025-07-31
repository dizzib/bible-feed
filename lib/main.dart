import 'package:flutter/material.dart';
import '/extension/object.dart';
import '/view/app_base.dart';
import 'injectable.dart';

Future<void> main() async {
  'starting app'.log();
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(AppBase());
  'started app'.log();
}
