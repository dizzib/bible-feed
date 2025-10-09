import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/view/app.dart';
import 'package:flutter/material.dart';

import '../injectable.dart';

enum Constraint {
  googlePixel3(Size(360, 720)),
  small(Size(180, 360)),
  iPadPro11(Size(834, 1194));

  const Constraint(this.logicalSize);

  final Size logicalSize;
}

Future<void> main() async {
  await configureDependencies('golden');
  WidgetsApp.debugAllowBannerOverride = false; // hide the debug banner

  goldenTest(
    'Golden tests',
    fileName: 'app',
    builder: () {
      return GoldenTestGroup(
        children:
            Constraint.values.map((constraint) {
              return GoldenTestScenario(
                name: constraint.name,
                constraints: BoxConstraints.tight(constraint.logicalSize),
                child: App(),
              );
            }).toList(),
      );
    },
  );
}
