import 'package:flutter/material.dart';

class ListWheelState<T> extends ChangeNotifier {
  late int _index;

  // get/set index
  int get index => _index;
  set index(int index) { _index = index; notifyListeners(); }
}
