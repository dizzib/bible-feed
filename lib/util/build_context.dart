import 'package:flutter/material.dart';

extension BuildContextEntension<T> on BuildContext {
  ThemeData get theme => Theme.of(this);

  // colors
  bool get _isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
  Color get primaryColorDark => theme.primaryColorDark;
  Color get primaryColorLight => theme.primaryColorLight;
  Color get primaryColorByMode => _isDarkMode ? primaryColorDark : primaryColorLight;
  Color get backgroundColor => theme.colorScheme.background;
}
