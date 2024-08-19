import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'util/store.dart';
import 'view/list_wheel_state.dart';

Future init() async {
  await Store.init();
  di.registerSingleton(Feeds(readingLists));
  di.registerSingleton(ListWheelState<Book>());
  di.registerSingleton(ListWheelState<int>());
}