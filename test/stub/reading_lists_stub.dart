import 'package:injectable/injectable.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'reading_list_stub.dart';

@test
@LazySingleton(as: ReadingLists)
class ReadingListsMock extends ReadingLists {
  @override
  final items = [rl0, rl1];
}
