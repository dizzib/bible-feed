import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextEntension<T> on BuildContext {
  // device
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get deviceTextScale => mediaQuery.textScaler.scale(1); // from device settings
  bool get isDarkMode => mediaQuery.platformBrightness == Brightness.dark;
  bool get isOrientationLandscape => mediaQuery.orientation == Orientation.landscape;

  // theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  void navigateTo(Widget page) => Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));

  Future<T?> showDialogWithBlurBackground(Widget child) {
    HapticFeedback.lightImpact();
    return showDialog(
      context: this,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: child,
      ),
    );
  }
}
