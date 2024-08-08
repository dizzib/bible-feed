import 'package:flutter/material.dart';
import '../util/build_context.dart';

// highlight selected item
class ListWheelHighlight extends StatelessWidget {
  final double height;

  const ListWheelHighlight({ required this.height, });

  @override
  build(context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.red : Colors.amber,
          borderRadius: BorderRadius.circular(8.0),
        ),
      )
    );
  }
}

// background fade effect
class ListWheelGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;

  const ListWheelGradient({
    required this.begin,
    required this.end,
  });

  @override
  build(context) {
    var surfaceColor = Theme.of(context).colorScheme.surface;
    return Align(
      alignment: begin,
      child: LayoutBuilder(
        builder: (_, constraints) =>
          Container(
            height: constraints.maxHeight * 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: [surfaceColor, surfaceColor.withOpacity(0.0)]
              )
            ),
          )
      )
    );
  }
}
