import 'package:flutter/material.dart';

abstract class ListWheelState<T> with ChangeNotifier {
  //// abstract

  T indexToItem(int index);
  String itemToString(T item);

  //// concrete

  late int _index;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}
