import 'package:flutter/material.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  // colors
  Color get primaryColorDark => theme.primaryColorDark;
  Color get primaryColorLight => theme.primaryColorLight;
  Color get backgroundColor => theme.colorScheme.background;
}
