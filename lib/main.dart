import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'model/list_wheel_state.dart';
import 'service/app_lifecycle.dart';
import 'service/background_service.dart';
import 'service/bible_app_service.dart';
import 'util/log.dart';
import 'view/app_base.dart';

Future<void> main() async {
  'starting app'.log();
  await initApp();
  runApp(AppBase());
  'started app'.log();
}

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(Feeds(readingLists));
  sl.registerSingleton(AppLifecycle());
  sl.registerSingleton(BackgroundService());
  sl.registerSingleton(BibleAppService());
  sl.registerSingleton(ListWheelState<Book>());
  sl.registerSingleton(ListWheelState<int>());
  sl<Feeds>().maybeAdvance();
}
