import 'package:flutter/material.dart';

class AnimatedFab extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData iconData;
  final bool isVisible;
  final Function() onPressed;

  const AnimatedFab({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconData,
    required this.isVisible,
    required this.onPressed,
  });

  @override
  build(context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isVisible ? 1 : 0,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        onPressed: onPressed,
        shape: const CircleBorder(),
        child: Icon(iconData, size: 35),
      ),
    );
  }
}
