import '/model/book.dart';
import '/model/reading_list.dart';
import 'list_wheel_state.dart';

class BookListWheelState extends ListWheelState<Book> {
  late ReadingList readingList;

  @override
  Book indexToItem(int index) => readingList[index];

  @override
  String itemToString(Book item) => item.name;
}
