import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);

  // colors
  Color get surface => theme.colorScheme.surface;
  Color get surfaceTint => theme.colorScheme.surfaceTint;
  Color get surfaceContainer => theme.colorScheme.surfaceContainer;
  Color get surfaceContainerHigh => theme.colorScheme.surfaceContainerHigh;
  Color get surfaceContainerLow => theme.colorScheme.surfaceContainerLow;
  Color get surfaceContainerLowest => theme.colorScheme.surfaceContainerLowest;

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
