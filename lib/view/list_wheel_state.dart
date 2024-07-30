import 'package:flutter/material.dart';

class ListWheelState<T> extends ChangeNotifier {
  int _index;
  T item;

  ListWheelState(int index, this.item) : _index = index;

  // notifyListeners when setting index, not item
  int get index => _index;
  set index(int index) { _index = index; notifyListeners(); }
}
