import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextEntension<T> on BuildContext {
  ThemeData get theme => Theme.of(this);

  // colors
  bool get _isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
  Color get primaryColorDark => theme.primaryColorDark;
  Color get primaryColorLight => theme.primaryColorLight;
  Color get primaryColorByMode => _isDarkMode ? primaryColorDark : primaryColorLight;
  Color get backgroundColor => theme.colorScheme.background;

  // text styles
  TextStyle? get titleLarge => theme.textTheme.titleLarge;
  TextStyle? get bodyLarge => theme.textTheme.bodyLarge;

  // dialog
  Future<T?> showBlurBackgroundDialog(Widget child) {
    HapticFeedback.lightImpact();
    return showDialog(
      context: this,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: child,
      )
    );
  }
}
