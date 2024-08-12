import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;

  // themes and schemes
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

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
