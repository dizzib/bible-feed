import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'model/list_wheel_state.dart';
import 'service/background_service.dart';
import 'util/store.dart';

Future init() async {
  await Store.init();
  di.registerSingleton(Feeds(readingLists));
  di.registerSingleton(BackgroundService());
  di.registerSingleton(ListWheelState<Book>());
  di.registerSingleton(ListWheelState<int>());
}
