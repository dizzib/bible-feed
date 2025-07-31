import 'package:flutter/material.dart';

abstract class ListWheelState with ChangeNotifier {
  late int _index;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}

class BookListWheelState extends ListWheelState {}
class ChapterListWheelState extends ListWheelState {}
