import 'package:flutter/material.dart';
import '/util/build_context.dart';

// highlight selected item
class ListWheelHighlight extends StatelessWidget {
  final double height;

  const ListWheelHighlight({
    required this.height,
  });

  @override
  build(context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

// background fade effect
class ListWheelGradient extends StatelessWidget {
  final Alignment begin, end;

  const ListWheelGradient({required this.begin, required this.end});

  @override
  build(context) {
    return Align(
      alignment: begin,
      child: LayoutBuilder(
        builder: (_, constraints) => Container(
          height: constraints.maxHeight * 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              context.colorScheme.surfaceContainerHigh.withValues(alpha: context.isDarkMode ? 0.0 : 1.0),
              context.colorScheme.surfaceContainerHigh.withValues(alpha: context.isDarkMode ? 1.0 : 0.0),
            ]),
          ),
        ),
      ),
    );
  }
}
