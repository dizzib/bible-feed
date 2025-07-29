import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'extension/object.dart';
import '/model/bible_readers.dart';
import '/model/book.dart';
import '/model/feeds.dart';
import '/model/list_wheel_state.dart';
import '/model/reading_lists.dart';
import '/service/all_done_dialog_service.dart';
import '/service/auto_advance_service.dart';
import '/service/bible_reader_app_install_service.dart';
import '/service/bible_reader_service.dart';
import '/view/app_base.dart';

Future<void> main() async {
  'starting app'.log();
  WidgetsFlutterBinding.ensureInitialized();

  sl.registerSingleton(await PackageInfo.fromPlatform());
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => ReadingLists());
  sl.registerLazySingleton(() => Feeds());
  sl.registerLazySingleton(() => AllDoneDialogService());
  sl.registerLazySingleton(() => BibleReaderAppInstallService());
  sl.registerLazySingleton(() => BibleReaders());
  sl.registerLazySingleton(() => BibleReaderService());
  sl.registerLazySingleton(() => ListWheelState<Book>());
  sl.registerLazySingleton(() => ListWheelState<int>());
  sl.registerSingleton(AutoAdvanceService()); // last of all, for maybeAdvance()

  runApp(AppBase());
  'started app'.log();
}
