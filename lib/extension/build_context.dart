import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextEntension<T> on BuildContext {
  // helper property getters
  double get deviceTextScale => MediaQuery.of(this).textScaler.scale(1); // from device settings
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
  bool get isOrientationLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Future<T?> showDialogNormal(Widget child) {
    return showDialog(
      context: this,
      builder: (_) => child,
    );
  }

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
