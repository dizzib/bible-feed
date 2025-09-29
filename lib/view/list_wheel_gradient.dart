import 'package:flutter/material.dart';

import 'build_context_extension.dart';

// background fade effect
class ListWheelGradient extends StatelessWidget {
  final Alignment begin, end;
  const ListWheelGradient({required this.begin, required this.end});

  @override
  build(context) {
    return Align(
      alignment: begin,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final colorStart = context.colorScheme.surfaceContainerHigh.withValues(alpha: context.isDarkMode ? 0.0 : 1.0);
          final colorEnd = context.colorScheme.surfaceContainerHigh.withValues(alpha: context.isDarkMode ? 1.0 : 0.0);
          return Container(
            height: constraints.maxHeight * 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: begin, end: end, colors: [colorStart, colorEnd]),
            ),
          );
        },
      ),
    );
  }
}
