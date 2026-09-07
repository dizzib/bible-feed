import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class ListWheelState with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }
}

@lazySingleton
class BookListWheelState extends ListWheelState {}

@lazySingleton
class ChapterListWheelState extends ListWheelState {}
