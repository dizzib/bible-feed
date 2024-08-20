import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'model/list_wheel_state.dart';
import 'service/app_lifecycle.dart';
import 'service/background_service.dart';
import 'view/app.dart';
import 'util/log.dart';
import 'util/store.dart';

void main() async {
  'starting app'.log();
  await initApp();
  runApp(App());
  'started app'.log();
}

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  di.registerSingleton(Feeds(readingLists));
  di.registerSingleton(AppLifecycle());
  di.registerSingleton(BackgroundService());
  di.registerSingleton(ListWheelState<Book>());
  di.registerSingleton(ListWheelState<int>());
}
