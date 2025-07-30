import 'list_wheel_state.dart';

class ChapterListWheelState extends ListWheelState<int> {
  @override
  int indexToItem(int index) => index + 1;

  @override
  String itemToString(int item) => item.toString();
}
