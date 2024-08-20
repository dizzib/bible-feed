import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'view/app.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'model/list_wheel_state.dart';
import 'service/background_service.dart';
import 'util/log.dart';
import 'util/store.dart';

void main() async {
  'starting bible_feed app...'.log();
  await initApp();
  runApp(App());
  '...app started'.log();
}

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  di.registerSingleton(Feeds(readingLists));
  di.registerSingleton(BackgroundService());
  di.registerSingleton(ListWheelState<Book>());
  di.registerSingleton(ListWheelState<int>());
}
