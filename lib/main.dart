import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'extension/object.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'model/list_wheel_state.dart';
import 'service/auto_advance_service.dart';
import 'service/bible_reader_service.dart';
import 'view/app_base.dart';

Future<void> main() async {
  'starting app'.log();
  WidgetsFlutterBinding.ensureInitialized();

  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(Feeds(readingLists));
  sl.registerSingleton(BibleReaderService());
  sl.registerSingleton(ListWheelState<Book>());
  sl.registerSingleton(ListWheelState<int>());
  sl.registerSingleton(AutoAdvanceService()); // last of all, for maybeAdvance()

  runApp(AppBase());
  'started app'.log();
}
