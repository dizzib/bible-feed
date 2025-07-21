import 'package:mocktail/mocktail.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'mock_reading_list.dart';

class MockReadingLists extends Mock implements ReadingLists {}

void registerMockReadingLists() {
  final mockReadingLists = MockReadingLists();
  when(() => mockReadingLists.items).thenReturn([l0, l1]);
  sl.registerSingleton<ReadingLists>(mockReadingLists);
}
