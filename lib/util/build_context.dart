import 'package:flutter/material.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;

  // theme
  ThemeData get theme => Theme.of(this);
  Color get primaryColor => theme.primaryColor;
  Color get primaryColorDark => theme.primaryColorDark;
  Color get primaryColorLight => theme.primaryColorLight;
  Color get primary => theme.colorScheme.primary;
  Color get onPrimary => theme.colorScheme.onPrimary;
  Color get secondary => theme.colorScheme.secondary;
  Color get onSecondary => theme.colorScheme.onSecondary;
  Color get cardColor => theme.cardColor;
  Color get errorColor => theme.colorScheme.error;
  Color get background => theme.colorScheme.background;
}
