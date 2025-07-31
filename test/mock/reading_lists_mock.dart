import 'package:injectable/injectable.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'reading_list_mock.dart';

@LazySingleton(
  as: ReadingLists,
  env: [Environment.test],
)
class ReadingListsMock implements ReadingLists {
  @override
  final items = [l0, l1];
}
