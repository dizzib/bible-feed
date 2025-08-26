import 'package:injectable/injectable.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'reading_list_stub.dart';

@LazySingleton(
  as: ReadingLists,
  env: [Environment.test],
)
class ReadingListsMock extends ReadingLists {
  @override
  final items = [rl0, rl1];
}
