import 'package:flutter/material.dart';

class WheelState<T> extends ChangeNotifier {
  int _index;
  T item;

  WheelState(int index, this.item) : _index = index;

  // notifyListeners when setting index, not item
  int get index => _index;
  set index(int index) { _index = index; notifyListeners(); }
}
