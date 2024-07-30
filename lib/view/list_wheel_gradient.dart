import 'package:flutter/material.dart';

class ListWheelGradient extends StatelessWidget {
  const ListWheelGradient({
    required this.begin,
    required this.end,
  });

  final Alignment begin;
  final Alignment end;

  @override
  Widget build(BuildContext context) {
    var surfaceColor = Theme.of(context).colorScheme.surface;
    return Align(
      alignment: begin,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            height: constraints.maxHeight * 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: [surfaceColor, surfaceColor.withOpacity(0.0)]
              )
            ),
          );
        }
      )
    );
  }
}
