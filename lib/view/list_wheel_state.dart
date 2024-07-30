import 'package:flutter/material.dart';

class WheelState<T> extends ChangeNotifier {
  WheelState(int index, this.item) : _index = index;

  int _index;
  T item;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}
